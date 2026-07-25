import '../models/exercise.dart';
import '../models/exercise_performance.dart';
import '../models/interaction_format.dart';
import '../models/profile.dart';
import '../models/question.dart';
import '../models/response_mode.dart';
import '../models/school_grade.dart';
import '../models/subject.dart';

/// Vocabulaire des chiffres, validé par le spike technique (cf.
/// docs/PRD.md section 12).
const Map<String, String> _digitWords = {
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
};

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
  return _digitWords.entries
      .where((e) => e.key != '10') // exercice "Nombres" = 0 à 9 uniquement
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

List<Question> _additionQuestions(
  String exerciseId,
  List<(int, int)> pairs,
) {
  return pairs.map((pair) {
    final (a, b) = pair;
    final sum = a + b;
    return Question(
      id: '$exerciseId-$a-$b',
      exerciseId: exerciseId,
      displayValue: '$a + $b',
      expectedSpokenWord: _digitWords[sum.toString()],
      expectedAnswer: sum.toString(),
    );
  }).toList();
}

List<Question> _subtractionQuestions(
  String exerciseId,
  List<(int, int)> pairs,
) {
  return pairs.map((pair) {
    final (a, b) = pair;
    final diff = a - b;
    return Question(
      id: '$exerciseId-$a-$b',
      exerciseId: exerciseId,
      displayValue: '$a - $b',
      expectedSpokenWord: _digitWords[diff.toString()],
      expectedAnswer: diff.toString(),
    );
  }).toList();
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
      expectedSpokenWord: _digitWords[n.toString()],
    );
  });
}

List<Question> _denombrementQuestions(
  String exerciseId,
  int maxCount, {
  required List<String> categories,
}) {
  final questions = <Question>[];
  for (var i = 0; i < categories.length; i++) {
    final count = (i % maxCount) + 1;
    questions.add(
      Question(
        id: '$exerciseId-${categories[i]}',
        exerciseId: exerciseId,
        displayValue: '$count ${categories[i]}',
        expectedSpokenWord: _digitWords[count.toString()],
      ),
    );
  }
  return questions;
}

/// Les 12 exercices actés dans docs/PRD.md (sections 5.1 et 8.1).
List<Exercise> buildCatalogSeed() {
  const alphaMajStdId = 'ex-alphabet-majuscule-standard';
  const alphaMajAleaId = 'ex-alphabet-majuscule-aleatoire';
  const alphaMinStdId = 'ex-alphabet-minuscule-standard';
  const alphaMinAleaId = 'ex-alphabet-minuscule-aleatoire';
  const nombresId = 'ex-nombres';
  const additionCinqId = 'ex-addition-5';
  const additionDixId = 'ex-addition-10';
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
      questions: _additionQuestions(additionCinqId, const [
        (1, 1),
        (2, 1),
        (2, 2),
        (3, 1),
        (3, 2),
      ]),
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
      questions: _additionQuestions(additionDixId, const [
        (4, 3),
        (5, 3),
        (6, 2),
        (7, 2),
        (4, 6),
      ]),
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
      questions: _subtractionQuestions(soustractionDixId, const [
        (8, 3),
        (10, 4),
        (6, 2),
        (9, 5),
        (7, 3),
      ]),
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
      oralInstruction: 'Compte les objets affichés et dis le total.',
      schoolGrade: SchoolGrade.ps,
      responseMode: ResponseMode.vocal,
      interactionFormat: InteractionFormat.denombrement,
      questions: _denombrementQuestions(
        denombrementCinqId,
        5,
        categories: const ['chats', 'ballons', 'étoiles'],
      ),
    ),
    Exercise(
      id: denombrementDixId,
      subject: Subject.mathematiques,
      theme: 'Dénombrement',
      title: 'Dénombrement (1 à 10 objets)',
      oralInstruction: 'Compte les objets affichés et dis le total.',
      schoolGrade: SchoolGrade.ps,
      responseMode: ResponseMode.vocal,
      interactionFormat: InteractionFormat.denombrement,
      questions: _denombrementQuestions(
        denombrementDixId,
        10,
        categories: const ['tractopelles', 'chats', 'ballons'],
      ),
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
