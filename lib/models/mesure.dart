import 'package:flutter/material.dart';

/// Catégories de tension artérielle (classification ESH), de la meilleure à la plus grave.
/// Chaque catégorie a sa propre nuance : vert → jaune → orange → rouge.
enum Categorie {
  optimale('Optimale', '< 120 et < 80', Color(0xFF2E7D32)),
  normale('Normale', '120–129 ou 80–84', Color(0xFF7CB342)),
  normaleHaute('Normale haute', '130–139 ou 85–89', Color(0xFFF9A825)),
  grade1('Hypertension grade 1', '140–159 ou 90–99', Color(0xFFEF6C00)),
  grade2('Hypertension grade 2', '160–179 ou 100–109', Color(0xFFD84315)),
  grade3('Hypertension grade 3', '≥ 180 ou ≥ 110', Color(0xFFB71C1C)),
  systoliqueIsolee(
    'Hypertension systolique isolée',
    '≥ 140 et < 90',
    Color(0xFFAD1457),
  );

  const Categorie(this.label, this.seuils, this.couleur);

  final String label;
  final String seuils;
  final Color couleur;

  /// Vrai pour toutes les formes d'hypertension : la mesure doit être signalée.
  bool get estAnormale => index >= Categorie.grade1.index;

  /// Version plus foncée de la couleur, lisible sur fond clair.
  Color get couleurFoncee => Color.lerp(couleur, Colors.black, 0.3)!;
}

/// Classe une mesure. Les catégories sont testées de la plus grave à la moins
/// grave : c'est la valeur (systolique ou diastolique) la plus haute qui compte.
Categorie classer(int systolique, int diastolique) {
  if (systolique >= 180 || diastolique >= 110) return Categorie.grade3;
  if (systolique >= 140 && diastolique < 90) {
    return Categorie.systoliqueIsolee;
  }
  if (systolique >= 160 || diastolique >= 100) return Categorie.grade2;
  if (systolique >= 140 || diastolique >= 90) return Categorie.grade1;
  if (systolique >= 130 || diastolique >= 85) return Categorie.normaleHaute;
  if (systolique >= 120 || diastolique >= 80) return Categorie.normale;
  return Categorie.optimale;
}

class Mesure {
  Mesure({
    required this.id,
    required this.date,
    required this.systolique,
    required this.diastolique,
    required this.pouls,
  });

  factory Mesure.fromJson(Map<String, dynamic> json) => Mesure(
    id: json['id'] as String,
    date: DateTime.parse(json['date'] as String),
    systolique: json['systolique'] as int,
    diastolique: json['diastolique'] as int,
    pouls: json['pouls'] as int,
  );

  final String id;
  final DateTime date;
  final int systolique;
  final int diastolique;
  final int pouls;

  Categorie get categorie => classer(systolique, diastolique);

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'systolique': systolique,
    'diastolique': diastolique,
    'pouls': pouls,
  };
}
