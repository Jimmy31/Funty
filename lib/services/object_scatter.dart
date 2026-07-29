import 'dart:math';
import 'dart:ui' show Offset;

/// Disposition aléatoire sans chevauchement des objets à dénombrer (cf. PRD
/// 5.1 et le risque identifié en section 10) : position, taille et
/// orientation tirées au hasard, avec un algorithme de placement qui
/// réessaie tant qu'une position choisie chevauche un objet déjà placé.
///
/// Tout est exprimé en **coordonnées normalisées** : le cadre fait 1.0 de
/// large et `boxAspect` de haut, et les tailles sont des fractions de cette
/// largeur. L'écran n'a plus qu'à multiplier par la largeur réellement
/// disponible.
///
/// Le rapport hauteur/largeur est passé en paramètre plutôt que figé, pour
/// que les objets occupent toute la place que l'écran leur laisse — un cadre
/// plus haut donne mécaniquement des objets plus gros (cf. [_baseSizeFor]).
const double defaultScatterBoxAspect = 0.62;

/// Part du cadre effectivement couverte par les objets. Au-delà, le placement
/// sans chevauchement devient trop contraint et les objets finissent alignés
/// faute de place — l'inverse de l'effet recherché.
const double _targetFillRatio = 0.26;

/// Bornes de la taille d'un objet, en fraction de la largeur du cadre.
const double _minObjectSize = 0.13;
const double _maxObjectSize = 0.50;

/// Écart de taille entre objets d'une même question, en multiples de la
/// taille de base. Volontairement large : une variation discrète se lit comme
/// un défaut de rendu plutôt que comme une intention, l'objectif étant une
/// disposition franchement irrégulière (cf. PRD 5.1). Le facteur moyen reste
/// proche de 1, donc l'encombrement total ne change pas.
const double _minSizeFactor = 0.60;
const double _maxSizeFactor = 1.45;

/// Rotation maximale, en degrés. Volontairement modérée : un animal trop
/// incliné devient pénible à identifier pour un enfant de PS.
const double _maxRotationDegrees = 18.0;

/// Marge ajoutée au rayon de chaque objet lors du test de chevauchement.
const double _collisionPadding = 1.04;

/// Nombre d'essais de placement pour une taille donnée — garantit que le
/// calcul se termine même quand le cadre est très encombré (cf. PRD 10 :
/// temps de calcul raisonnable sur un appareil d'entrée de gamme).
const int _placementAttempts = 120;

/// Quand aucune place ne se libère, l'objet est rétréci et on réessaie,
/// plutôt que d'accepter un chevauchement. Le cas se produit surtout avec
/// peu d'objets : ils sont alors grands, et la zone où leur *centre* peut
/// tomber sans déborder du cadre devient si petite que deux voisins
/// suffisent à la saturer.
const double _shrinkFactor = 0.85;
const int _maxShrinkSteps = 14;

/// Taille plancher, pour qu'un objet rétréci en dernier recours reste
/// visible.
const double _floorObjectSize = 0.05;

class ScatteredObject {
  const ScatteredObject({
    required this.asset,
    required this.center,
    required this.size,
    required this.rotation,
  });

  final String asset;

  /// Centre de l'objet dans le cadre normalisé (x dans [0, 1], y dans
  /// [0, `boxAspect`]).
  final Offset center;

  /// Côté de l'objet, en fraction de la largeur du cadre.
  final double size;

  /// Angle en radians, prêt pour `Transform.rotate`.
  final double rotation;
}

/// Répartit [assets] dans un cadre normalisé de 1.0 de large et [boxAspect]
/// de haut, sans chevauchement.
List<ScatteredObject> scatterObjects(
  List<String> assets,
  Random random, {
  double boxAspect = defaultScatterBoxAspect,
}) {
  if (assets.isEmpty) return const [];

  final baseSize = _baseSizeFor(assets.length, boxAspect);
  final placed = <ScatteredObject>[];

  for (final asset in assets) {
    var size =
        baseSize *
        (_minSizeFactor +
            random.nextDouble() * (_maxSizeFactor - _minSizeFactor));
    var spot = _findSpot(size, placed, random, boxAspect);

    // Pas de place à cette taille : on rétrécit et on réessaie, plutôt que
    // de poser l'objet sur un voisin.
    for (var step = 0; spot.clearance < 0 && step < _maxShrinkSteps; step++) {
      size *= _shrinkFactor;
      spot = _findSpot(size, placed, random, boxAspect);
    }

    if (spot.clearance < 0) {
      // Dernier recours : on garde la position la moins mauvaise et on retire
      // à l'objet exactement le recouvrement qui restait, ce qui ramène
      // l'écart à zéro. La contrainte de non-chevauchement est donc tenue
      // dans tous les cas, quitte à ce qu'un objet soit plus petit.
      size = max(
        size + 2 * spot.clearance / _collisionPadding,
        _floorObjectSize,
      );
    }

    placed.add(
      ScatteredObject(
        asset: asset,
        center: spot.center,
        size: size,
        rotation:
            (random.nextDouble() * 2 - 1) * _maxRotationDegrees * pi / 180,
      ),
    );
  }

  return placed;
}

/// Taille de base des objets : elle décroît avec leur nombre, pour garder la
/// même densité visuelle qu'il y en ait 1 ou 10, et croît avec la hauteur du
/// cadre — plus l'écran laisse de place, plus les objets sont gros.
double _baseSizeFor(int count, double boxAspect) {
  final area = boxAspect * _targetFillRatio / count;
  return sqrt(area).clamp(_minObjectSize, _maxObjectSize);
}

/// Cherche une position libre pour un objet de côté [size]. Renvoie la
/// première position sans chevauchement trouvée ; si le cadre est saturé,
/// renvoie la moins mauvaise avec un `clearance` négatif indiquant de combien
/// elle empiète.
({Offset center, double clearance}) _findSpot(
  double size,
  List<ScatteredObject> placed,
  Random random,
  double boxAspect,
) {
  final radius = size / 2 * _collisionPadding;
  // L'objet doit rester entièrement dans le cadre : son centre est donc
  // borné par son propre rayon.
  final minX = min(radius, 0.5);
  final maxX = max(1 - radius, 0.5);
  final minY = min(radius, boxAspect / 2);
  final maxY = max(boxAspect - radius, boxAspect / 2);

  var best = Offset((minX + maxX) / 2, (minY + maxY) / 2);
  var bestClearance = double.negativeInfinity;
  for (var attempt = 0; attempt < _placementAttempts; attempt++) {
    final candidate = Offset(
      minX + random.nextDouble() * (maxX - minX),
      minY + random.nextDouble() * (maxY - minY),
    );
    final clearance = _clearance(candidate, radius, placed);
    if (clearance >= 0) return (center: candidate, clearance: clearance);
    if (clearance > bestClearance) {
      bestClearance = clearance;
      best = candidate;
    }
  }
  return (center: best, clearance: bestClearance);
}

/// Distance libre entre un candidat et les objets déjà placés : positive ou
/// nulle s'il n'y a pas chevauchement, négative sinon (la valeur sert alors
/// à retenir le candidat le moins mauvais).
double _clearance(
  Offset candidate,
  double radius,
  List<ScatteredObject> placed,
) {
  var worst = double.infinity;
  for (final other in placed) {
    final otherRadius = other.size / 2 * _collisionPadding;
    final gap = (candidate - other.center).distance - (radius + otherRadius);
    if (gap < worst) worst = gap;
  }
  return worst == double.infinity ? 0 : worst;
}
