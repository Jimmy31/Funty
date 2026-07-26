/// Familles d'animaux illustrées pour l'exercice Dénombrement (cf.
/// docs/PRD.md) — 10 images distinctes par famille, extraites des planches
/// dans docs/graphics. L'écran d'exercice change de famille à chaque
/// question et pioche aléatoirement dedans (cf. [ExerciseRunnerScreen]),
/// plutôt que de figer les illustrations à la construction du catalogue.
const List<String> animalFamilyFolders = [
  'coccinelles/coccinelle',
  'chats/chat',
  'chiens/chien',
  'poissons/poisson',
  'oiseaux/oiseau',
  'insectes/insecte',
  'singes/singe',
];

const int imagesPerAnimalFamily = 10;

String animalImagePath(String familyFolder, int index) {
  final n = index.toString().padLeft(2, '0');
  return 'assets/images/${familyFolder}_$n.png';
}
