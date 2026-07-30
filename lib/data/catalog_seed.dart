import '../models/exercise.dart';
import '../models/exercise_performance.dart';
import '../models/interaction_format.dart';
import '../models/profile.dart';
import '../models/question.dart';
import '../models/response_mode.dart';
import '../models/school_grade.dart';
import '../models/subject.dart';

/// Vocabulaire des chiffres. 0-10 validés par le spike technique (cf.
/// docs/PRD.md section 12). 11-20 (pour l'exercice Addition ≤ 20) n'ont
/// PAS été soumis au même parcours systématique de validation sur
/// l'appareil — à vérifier comme H/M/N/X/Z l'ont été, notamment les
/// nombres composés ("dix-sept", "dix-huit", "dix-neuf") dont la
/// reconnaissance en un seul mot n'est pas garantie par le modèle Vosk.
const Map<String, String> digitWords = {
  '0': 'zéro',
  '1': 'un',
  '2': 'deux',
  '3': 'trois',
  '4': 'quatre',
  '5': 'cinq',
  '6': 'six',
  '7': 'sept',
  '8': 'huit',
  '9': 'neuf',
  '10': 'dix',
  '11': 'onze',
  '12': 'douze',
  '13': 'treize',
  '14': 'quatorze',
  '15': 'quinze',
  '16': 'seize',
  '17': 'dix-sept',
  '18': 'dix-huit',
  '19': 'dix-neuf',
  '20': 'vingt',
};

/// Prononciations supplémentaires acceptées pour certains nombres, sur le
/// même principe que les homophones de lettres validés au spike (cf.
/// docs/PRD.md section 12) : l'enfant ne change rien à ce qu'il dit, on
/// élargit seulement ce que le modèle a le droit de rendre.
///
/// Vide pour l'instant. Des variantes avaient été envisagées pour "un" (le
/// cas remonté en test : une syllabe nasale très brève, que le modèle rate
/// par moments au profit de "[unk]"), mais ni "hein" ni "une" ne sont
/// retenus — un enfant qui dit "hein ?" parce qu'il n'a pas compris ne doit
/// pas voir sa question validée comme la réponse "1". Seul "un" est accepté.
const Map<String, List<String>> digitSpokenVariants = {};

List<String> _variantsFor(String digit) =>
    digitSpokenVariants[digit] ?? const [];

/// Prononciation des lettres majuscules, avec les homophones validés par le
/// spike pour H/M/N/X (cf. docs/PRD.md section 12) : "hache" pour "ache" (H
/// est muet en français, même son), "aime" pour "emme" (M), "haine" pour
/// "enne" (N), "ixe" pour "iks" (X, sans lien étymologique mais confirmé
/// acoustiquement). Z reste non résolu ("zède" hors-vocabulaire) et n'a donc
/// pas de mot cible fiable pour l'instant.
const Map<String, String?> _letterWords = {
  'A': 'a',
  'B': 'bé',
  'C': 'cé',
  'D': 'dé',
  'E': 'e',
  'F': 'effe',
  'G': 'gé',
  'H': 'hache',
  'I': 'i',
  'J': 'ji',
  'K': 'ka',
  'L': 'elle',
  'M': 'aime',
  'N': 'haine',
  'O': 'o',
  'P': 'pé',
  'Q': 'ku',
  'R': 'erre',
  'S': 'esse',
  'T': 'té',
  'U': 'u',
  'V': 'vé',
  'W': 'double vé',
  'X': 'ixe',
  'Y': 'i grec',
  'Z': null,
};

List<Question> _letterQuestions(String exerciseId, {required bool lowercase}) {
  return _letterWords.entries.where((e) => e.value != null).map((e) {
    final display = lowercase ? e.key.toLowerCase() : e.key;
    return Question(
      id: '$exerciseId-${e.key}',
      exerciseId: exerciseId,
      displayValue: display,
      expectedSpokenWord: e.value,
    );
  }).toList();
}

List<Question> _digitQuestions(String exerciseId) {
  return digitWords.entries
      .where((e) => int.parse(e.key) <= 9) // exercice "Nombres" = 0 à 9
      .map(
        (e) => Question(
          id: '$exerciseId-${e.key}',
          exerciseId: exerciseId,
          displayValue: e.key,
          expectedSpokenWord: e.value,
          spokenVariants: _variantsFor(e.key),
        ),
      )
      .toList();
}

/// Nombre de paires distinctes proposées par résultat possible — sans
/// compter l'ordre des termes, chacune donnant deux questions (cf.
/// [_additionQuestions]). Assez pour que le même résultat ne soit pas
/// toujours associé à la même écriture, sans faire exploser la banque de
/// questions (la sélection adaptative privilégiant les questions jamais
/// vues, cf. PRD 6.5).
const _pairsPerResult = 3;

/// Additions couvrant **tous** les résultats de 0 à [maxSum] (cf. PRD 5.1).
/// Les listes de paires figées utilisées auparavant ne couvraient qu'une
/// poignée de résultats — Addition ≤ 20 ne proposait par exemple que des
/// résultats compris entre 13 et 20.
///
/// Chaque paire est posée **dans les deux ordres**, comme deux questions
/// distinctes : 7 + 11 et 11 + 7 reviennent au même pour un adulte, pas pour
/// un enfant qui apprend — la commutativité est justement une des choses à
/// acquérir. Seule une paire de termes égaux (3 + 3) ne donne qu'une
/// question.
///
/// Les paires les plus équilibrées viennent en premier (5 + 5 avant 9 + 1),
/// et les écritures triviales "n + 0" sont écartées tant qu'il existe une
/// autre façon d'atteindre le même résultat.
List<Question> _additionQuestions(String exerciseId, int maxSum) {
  final questions = <Question>[];
  for (var sum = 0; sum <= maxSum; sum++) {
    var kept = 0;
    for (var a = (sum + 1) ~/ 2; a <= sum && kept < _pairsPerResult; a++) {
      final b = sum - a;
      if (b == 0 && sum >= 2) continue;
      kept++;
      final orders = a == b ? [(a, b)] : [(a, b), (b, a)];
      for (final (first, second) in orders) {
        questions.add(
          Question(
            id: '$exerciseId-$first-$second',
            exerciseId: exerciseId,
            displayValue: '$first + $second',
            expectedSpokenWord: digitWords[sum.toString()],
            spokenVariants: _variantsFor(sum.toString()),
            expectedAnswer: sum.toString(),
          ),
        );
      }
    }
  }
  return questions;
}

/// Soustractions couvrant tous les résultats de 1 à [maxValue], le second
/// terme restant toujours inférieur au premier et les deux termes bornés
/// par [maxValue] (cf. PRD 5.1) — même correction de couverture que pour
/// [_additionQuestions].
List<Question> _subtractionQuestions(String exerciseId, int maxValue) {
  final questions = <Question>[];
  for (var diff = 1; diff <= maxValue; diff++) {
    var kept = 0;
    for (var b = 0; diff + b <= maxValue && kept < _pairsPerResult; b++) {
      // "n - 0" seulement quand aucune autre écriture ne tient dans la borne
      // (cas du résultat maximal, ex. 10 - 0 pour l'exercice ≤ 10).
      if (b == 0 && diff + 1 <= maxValue) continue;
      final a = diff + b;
      questions.add(
        Question(
          id: '$exerciseId-$a-$b',
          exerciseId: exerciseId,
          displayValue: '$a - $b',
          expectedSpokenWord: digitWords[diff.toString()],
          spokenVariants: _variantsFor(diff.toString()),
          expectedAnswer: diff.toString(),
        ),
      );
      kept++;
    }
  }
  return questions;
}

List<Question> _shapeQuestions(String exerciseId) {
  const shapes = {'cercle': 'cercle', 'carré': 'carré', 'triangle': 'triangle'};
  return shapes.entries
      .map(
        (e) => Question(
          id: '$exerciseId-${e.key}',
          exerciseId: exerciseId,
          displayValue: e.key,
          expectedSpokenWord: e.value,
        ),
      )
      .toList();
}

List<Question> _countingQuestions(String exerciseId) {
  // Comptage 1 -> 10, dans l'ordre (exercice séquentiel, cf. isSequentialException).
  return List.generate(10, (i) {
    final n = i + 1;
    return Question(
      id: '$exerciseId-$n',
      exerciseId: exerciseId,
      displayValue: '$n',
      expectedSpokenWord: digitWords[n.toString()],
      spokenVariants: _variantsFor(n.toString()),
    );
  });
}

List<Question> _denombrementQuestions(String exerciseId, int maxCount) {
  final questions = <Question>[];
  for (var count = 1; count <= maxCount; count++) {
    questions.add(
      Question(
        id: '$exerciseId-$count',
        exerciseId: exerciseId,
        displayValue: '$count animaux',
        expectedSpokenWord: digitWords[count.toString()],
        spokenVariants: _variantsFor(count.toString()),
        expectedAnswer: count.toString(),
        objectCount: count,
      ),
    );
  }
  return questions;
}

/// Les exercices du catalogue (cf. docs/PRD.md sections 5.1 et 8.1) : les 12
/// actés initialement, plus Addition ≤ 20 (13ᵉ, ajouté ensuite).
List<Exercise> buildCatalogSeed() {
  const alphaMajStdId = 'ex-alphabet-majuscule-standard';
  const alphaMajAleaId = 'ex-alphabet-majuscule-aleatoire';
  const alphaMinStdId = 'ex-alphabet-minuscule-standard';
  const alphaMinAleaId = 'ex-alphabet-minuscule-aleatoire';
  const nombresId = 'ex-nombres';
  const additionCinqId = 'ex-addition-5';
  const additionDixId = 'ex-addition-10';
  const additionVingtId = 'ex-addition-20';
  const soustractionDixId = 'ex-soustraction-10';
  const formesId = 'ex-formes';
  const comptageId = 'ex-comptage';
  const denombrementCinqId = 'ex-denombrement-5';
  const denombrementDixId = 'ex-denombrement-10';

  return [
    Exercise(
      id: alphaMajStdId,
      subject: Subject.lectureLangage,
      theme: 'Alphabet',
      title: 'Lettres majuscules',
      oralInstruction: 'Dis le nom de la lettre affichée.',
      schoolGrade: SchoolGrade.ps,
      responseMode: ResponseMode.vocal,
      questions: _letterQuestions(alphaMajStdId, lowercase: false),
    ),
    Exercise(
      id: alphaMajAleaId,
      subject: Subject.lectureLangage,
      theme: 'Alphabet',
      title: 'Lettres majuscules (police et orientation aléatoires)',
      oralInstruction: 'Dis le nom de la lettre affichée.',
      schoolGrade: SchoolGrade.ps,
      responseMode: ResponseMode.vocal,
      randomPresentation: true,
      questions: _letterQuestions(alphaMajAleaId, lowercase: false),
    ),
    Exercise(
      id: alphaMinStdId,
      subject: Subject.lectureLangage,
      theme: 'Alphabet',
      title: 'Lettres minuscules',
      oralInstruction: 'Dis le nom de la lettre affichée.',
      schoolGrade: SchoolGrade.ms,
      responseMode: ResponseMode.vocal,
      questions: _letterQuestions(alphaMinStdId, lowercase: true),
    ),
    Exercise(
      id: alphaMinAleaId,
      subject: Subject.lectureLangage,
      theme: 'Alphabet',
      title: 'Lettres minuscules (police et orientation aléatoires)',
      oralInstruction: 'Dis le nom de la lettre affichée.',
      schoolGrade: SchoolGrade.ms,
      responseMode: ResponseMode.vocal,
      randomPresentation: true,
      questions: _letterQuestions(alphaMinAleaId, lowercase: true),
    ),
    Exercise(
      id: nombresId,
      subject: Subject.mathematiques,
      theme: 'Nombres',
      title: 'Reconnaissance des chiffres (0 à 9)',
      oralInstruction: 'Dis le chiffre affiché.',
      schoolGrade: SchoolGrade.ps,
      responseMode: ResponseMode.vocal,
      questions: _digitQuestions(nombresId),
    ),
    Exercise(
      id: additionCinqId,
      subject: Subject.mathematiques,
      theme: 'Addition',
      title: 'Addition (résultat ≤ 5)',
      oralInstruction: 'Dis ou choisis le résultat de l\'addition.',
      schoolGrade: SchoolGrade.gs,
      responseMode: ResponseMode.vocalEtTactile,
      interactionFormat: InteractionFormat.qcm,
      frogAnimation: true,
      maxAnswerValue: 5,
      questions: _additionQuestions(additionCinqId, 5),
    ),
    Exercise(
      id: additionDixId,
      subject: Subject.mathematiques,
      theme: 'Addition',
      title: 'Addition (résultat ≤ 10)',
      oralInstruction: 'Dis ou choisis le résultat de l\'addition.',
      schoolGrade: SchoolGrade.gs,
      responseMode: ResponseMode.vocalEtTactile,
      interactionFormat: InteractionFormat.qcm,
      frogAnimation: true,
      maxAnswerValue: 10,
      questions: _additionQuestions(additionDixId, 10),
    ),
    Exercise(
      id: additionVingtId,
      subject: Subject.mathematiques,
      theme: 'Addition',
      title: 'Addition (résultat ≤ 20)',
      oralInstruction: 'Dis ou choisis le résultat de l\'addition.',
      schoolGrade: SchoolGrade.cp,
      responseMode: ResponseMode.vocalEtTactile,
      interactionFormat: InteractionFormat.qcm,
      frogAnimation: true,
      maxAnswerValue: 20,
      questions: _additionQuestions(additionVingtId, 20),
    ),
    Exercise(
      id: soustractionDixId,
      subject: Subject.mathematiques,
      theme: 'Soustraction',
      title: 'Soustraction (≤ 10, second nombre < premier)',
      oralInstruction: 'Dis ou choisis le résultat de la soustraction.',
      schoolGrade: SchoolGrade.gs,
      responseMode: ResponseMode.vocalEtTactile,
      interactionFormat: InteractionFormat.qcm,
      frogAnimation: true,
      maxAnswerValue: 10,
      questions: _subtractionQuestions(soustractionDixId, 10),
    ),
    Exercise(
      id: formesId,
      subject: Subject.mathematiques,
      theme: 'Formes et grandeurs',
      title: 'Reconnaissance des formes',
      oralInstruction: 'Dis le nom de la forme affichée.',
      schoolGrade: SchoolGrade.ps,
      responseMode: ResponseMode.vocal,
      questions: _shapeQuestions(formesId),
    ),
    Exercise(
      id: comptageId,
      subject: Subject.mathematiques,
      theme: 'Comptage',
      title: 'Compter de 1 à 10',
      oralInstruction: 'Compte à voix haute, un chiffre à la fois.',
      schoolGrade: SchoolGrade.ps,
      responseMode: ResponseMode.vocal,
      isSequentialException: true,
      questions: _countingQuestions(comptageId),
    ),
    Exercise(
      id: denombrementCinqId,
      subject: Subject.mathematiques,
      theme: 'Dénombrement',
      title: 'Dénombrement (1 à 5 objets)',
      oralInstruction: 'Compte les objets affichés et dis ou choisis le total.',
      schoolGrade: SchoolGrade.ps,
      responseMode: ResponseMode.vocalEtTactile,
      interactionFormat: InteractionFormat.denombrement,
      maxAnswerValue: 5,
      questions: _denombrementQuestions(denombrementCinqId, 5),
    ),
    Exercise(
      id: denombrementDixId,
      subject: Subject.mathematiques,
      theme: 'Dénombrement',
      title: 'Dénombrement (1 à 10 objets)',
      oralInstruction: 'Compte les objets affichés et dis ou choisis le total.',
      schoolGrade: SchoolGrade.ps,
      responseMode: ResponseMode.vocalEtTactile,
      interactionFormat: InteractionFormat.denombrement,
      maxAnswerValue: 10,
      questions: _denombrementQuestions(denombrementDixId, 10),
    ),
  ];
}

/// Quelques profils de départ pour ne pas avoir un écran vide au premier
/// lancement de ce squelette.
List<Profile> buildProfileSeed() {
  return [
    Profile(
      id: 'profile-demo-1',
      name: 'Alice',
      avatarId: '🦊',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Profile(
      id: 'profile-demo-2',
      name: 'Lucas',
      avatarId: '🐸',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}

/// Activation initiale des exercices pour les profils seedés, pour que la
/// vue enfant ne soit pas vide au tout premier lancement.
Map<String, Set<String>> buildActivationSeed() {
  return {
    'profile-demo-1': {
      'ex-nombres',
      'ex-alphabet-majuscule-standard',
      'ex-comptage',
    },
    'profile-demo-2': {'ex-formes', 'ex-alphabet-majuscule-standard'},
  };
}

/// Quelques lignes de performance factices pour que le tableau de bord ne
/// soit pas vide (cf. PRD 6.6) — pas de vrai calcul pour ce passage.
List<ExercisePerformanceStub> buildPerformanceSeed() {
  return const [
    ExercisePerformanceStub(
      profileId: 'profile-demo-1',
      exerciseId: 'ex-nombres',
      badgeLevel: 3,
      successRatePercent: 95,
      attemptsCount: 12,
    ),
    ExercisePerformanceStub(
      profileId: 'profile-demo-1',
      exerciseId: 'ex-alphabet-majuscule-standard',
      badgeLevel: 2,
      successRatePercent: 80,
      attemptsCount: 8,
    ),
    ExercisePerformanceStub(
      profileId: 'profile-demo-2',
      exerciseId: 'ex-formes',
      badgeLevel: 1,
      successRatePercent: 60,
      attemptsCount: 4,
    ),
  ];
}
