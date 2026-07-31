import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:funty/data/catalog_seed.dart';
import 'package:funty/models/geometric_shape.dart';
import 'package:funty/services/shape_presentation.dart';

/// Vérifie l'exercice de reconnaissance des formes (cf. PRD 5.1) : la banque
/// de questions couvre bien les 5 formes, chacune avec un mot cible utilisable
/// par la grammaire vocale, et la présentation ne réutilise jamais la même
/// couleur deux questions de suite.
void main() {
  final formes = buildCatalogSeed().firstWhere((e) => e.id == 'ex-formes');

  group('banque de questions', () {
    test('couvre les 5 formes, une question chacune', () {
      expect(formes.questions, hasLength(GeometricShape.values.length));
      expect(
        formes.questions.map((q) => q.shape).toSet(),
        GeometricShape.values.toSet(),
      );
      expect(formes.questions.map((q) => q.id).toSet(), hasLength(5));
    });

    test('donne à chaque question un mot cible et une forme à dessiner', () {
      for (final question in formes.questions) {
        expect(question.shape, isNotNull);
        expect(question.expectedSpokenWord, isNotNull);
        expect(question.acceptedSpokenWords, isNotEmpty);
        // Le nom sert au parent et à la révélation, pas à l'affichage de la
        // question — mais il doit rester renseigné.
        expect(question.displayValue, question.shape!.label);
      }
    });

    test('accepte "rond" comme réponse au cercle', () {
      final cercle = formes.questions.firstWhere(
        (q) => q.shape == GeometricShape.cercle,
      );
      expect(cercle.acceptedSpokenWords, containsAll(['cercle', 'rond']));
    });

    test('n\'accepte aucun mot cible pour deux formes différentes', () {
      final words = [
        for (final question in formes.questions) ...question.acceptedSpokenWords,
      ];
      expect(words.toSet(), hasLength(words.length));
    });
  });

  group('randomShapePresentation', () {
    test('ne rejoue jamais la couleur précédente', () {
      final random = Random(7);
      var previous = randomShapePresentation(random);
      for (var i = 0; i < 200; i++) {
        final next = randomShapePresentation(random, avoid: previous.color);
        expect(next.color, isNot(previous.color));
        expect(shapePalette, contains(next.color));
        previous = next;
      }
    });
  });
}
