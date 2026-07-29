import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:funty/services/object_scatter.dart';

/// Vérifie l'algorithme de placement aléatoire du Dénombrement (cf. PRD 5.1
/// et le risque identifié en section 10 : disposition sans chevauchement,
/// jusqu'à 10 objets, en un temps de calcul raisonnable).
void main() {
  List<String> assets(int count) => List.generate(count, (i) => 'objet$i.png');

  group('scatterObjects', () {
    test('place exactement le nombre d\'objets demandé', () {
      final random = Random(1);
      for (var count = 1; count <= 10; count++) {
        expect(scatterObjects(assets(count), random), hasLength(count));
      }
      expect(scatterObjects(const [], random), isEmpty);
    });

    // Formats représentatifs : le cadre par défaut, et une zone haute comme
    // celle que l'écran réserve désormais au dénombrement.
    const aspects = [defaultScatterBoxAspect, 1.0, 1.4];

    test('garde chaque objet entièrement dans le cadre', () {
      final random = Random(2);
      for (final aspect in aspects) {
        for (var count = 1; count <= 10; count++) {
          for (var run = 0; run < 60; run++) {
            final objects = scatterObjects(
              assets(count),
              random,
              boxAspect: aspect,
            );
            for (final object in objects) {
              final r = object.size / 2;
              expect(object.center.dx - r, greaterThanOrEqualTo(-1e-9));
              expect(object.center.dx + r, lessThanOrEqualTo(1 + 1e-9));
              expect(object.center.dy - r, greaterThanOrEqualTo(-1e-9));
              expect(object.center.dy + r, lessThanOrEqualTo(aspect + 1e-9));
            }
          }
        }
      }
    });

    test('ne fait jamais se chevaucher deux objets', () {
      final random = Random(3);
      for (final aspect in aspects) {
        for (var count = 2; count <= 10; count++) {
          for (var run = 0; run < 80; run++) {
            final objects = scatterObjects(
              assets(count),
              random,
              boxAspect: aspect,
            );
            for (var i = 0; i < objects.length; i++) {
              for (var j = i + 1; j < objects.length; j++) {
                final a = objects[i];
                final b = objects[j];
                final distance = (a.center - b.center).distance;
                expect(
                  distance,
                  greaterThanOrEqualTo(a.size / 2 + b.size / 2),
                  reason:
                      'chevauchement à $count objets (aspect $aspect) '
                      'entre $i et $j',
                );
              }
            }
          }
        }
      }
    });

    test(
      'donne des tailles franchement différentes dans une même question',
      () {
        // Une variation seulement mesurable ne suffit pas : elle doit se voir.
        // On vérifie donc un vrai rapport entre le plus petit et le plus grand,
        // sur la majorité des tirages.
        final random = Random(4);
        var bienContrastes = 0;
        const runs = 60;
        for (var run = 0; run < runs; run++) {
          final objects = scatterObjects(assets(6), random, boxAspect: 1.2);
          final sizes = objects.map((o) => o.size).toList()..sort();
          if (sizes.last / sizes.first >= 1.5) bienContrastes++;
        }
        expect(bienContrastes, greaterThan(runs * 0.8));
      },
    );

    test('varie les orientations sans gêner la lecture', () {
      final objects = scatterObjects(assets(10), Random(5));
      expect(objects.map((o) => o.rotation).toSet().length, greaterThan(1));
      // Une rotation trop forte rendrait l'animal pénible à identifier.
      for (final object in objects) {
        expect(object.rotation.abs(), lessThanOrEqualTo(20 * pi / 180));
      }
    });

    test('réduit la taille des objets quand ils sont plus nombreux', () {
      double moyenne(int count) {
        // Moyenne sur plusieurs tirages : avec un écart de taille volontaire-
        // ment large, un tirage isolé n'est pas représentatif.
        final random = Random(6);
        var total = 0.0;
        var n = 0;
        for (var run = 0; run < 40; run++) {
          for (final object in scatterObjects(assets(count), random)) {
            total += object.size;
            n++;
          }
        }
        return total / n;
      }

      expect(moyenne(10), lessThan(moyenne(3)));
      expect(moyenne(3), lessThan(moyenne(1)));
    });

    test('agrandit les objets quand le cadre est plus haut', () {
      double moyenne(double aspect) {
        final random = Random(7);
        var total = 0.0;
        var n = 0;
        for (var run = 0; run < 40; run++) {
          final objects = scatterObjects(assets(6), random, boxAspect: aspect);
          for (final object in objects) {
            total += object.size;
            n++;
          }
        }
        return total / n;
      }

      expect(moyenne(1.4), greaterThan(moyenne(defaultScatterBoxAspect)));
    });

    test('reste rapide sur le cas le plus chargé', () {
      final random = Random(8);
      final chrono = Stopwatch()..start();
      for (var run = 0; run < 200; run++) {
        scatterObjects(assets(10), random, boxAspect: 1.4);
      }
      chrono.stop();
      // Large marge : on cherche à détecter un placement qui partirait en
      // boucle, pas à mesurer finement la performance.
      expect(chrono.elapsedMilliseconds, lessThan(2000));
    });
  });
}
