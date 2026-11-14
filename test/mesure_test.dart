import 'package:carnet_tension/models/mesure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('classer', () {
    final cas = <(int, int), Categorie>{
      (115, 75): Categorie.optimale,
      (119, 79): Categorie.optimale,
      (120, 80): Categorie.normale,
      (115, 82): Categorie.normale,
      (135, 80): Categorie.normaleHaute,
      (125, 87): Categorie.normaleHaute,
      (140, 90): Categorie.grade1,
      (125, 95): Categorie.grade1, // était classé « Normale » avant la correction
      (165, 105): Categorie.grade2,
      (125, 105): Categorie.grade2,
      (125, 115): Categorie.grade3, // était classé « Normale » avant la correction
      (185, 95): Categorie.grade3,
      (190, 80): Categorie.grade3,
      (145, 85): Categorie.systoliqueIsolee, // n'était jamais atteint avant
      (165, 70): Categorie.systoliqueIsolee,
    };

    cas.forEach((valeurs, attendu) {
      final (sys, dia) = valeurs;
      test('$sys/$dia → ${attendu.label}', () {
        expect(classer(sys, dia), attendu);
      });
    });
  });

  test('seules les hypertensions sont signalées comme anormales', () {
    expect(Categorie.optimale.estAnormale, isFalse);
    expect(Categorie.normale.estAnormale, isFalse);
    expect(Categorie.normaleHaute.estAnormale, isFalse);
    expect(Categorie.grade1.estAnormale, isTrue);
    expect(Categorie.grade2.estAnormale, isTrue);
    expect(Categorie.grade3.estAnormale, isTrue);
    expect(Categorie.systoliqueIsolee.estAnormale, isTrue);
  });

  test('une mesure survit à un aller-retour JSON', () {
    final mesure = Mesure(
      id: '42',
      date: DateTime(2026, 11, 14, 8, 30),
      systolique: 132,
      diastolique: 86,
      pouls: 70,
    );
    final copie = Mesure.fromJson(mesure.toJson());
    expect(copie.id, mesure.id);
    expect(copie.date, mesure.date);
    expect(copie.systolique, 132);
    expect(copie.diastolique, 86);
    expect(copie.pouls, 70);
  });
}
