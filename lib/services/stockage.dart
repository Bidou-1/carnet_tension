import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/mesure.dart';

/// Sauvegarde locale (sur l'appareil uniquement) des mesures et du consentement RGPD.
class Stockage {
  Stockage(this._prefs);

  static Future<Stockage> ouvrir() async =>
      Stockage(await SharedPreferences.getInstance());

  static const _cleMesures = 'mesures';
  static const _cleConsentement = 'consentement_rgpd';

  final SharedPreferences _prefs;

  bool get consentementDonne => _prefs.getBool(_cleConsentement) ?? false;

  Future<void> accepterConsentement() =>
      _prefs.setBool(_cleConsentement, true);

  /// Mesures triées de la plus récente à la plus ancienne.
  List<Mesure> chargerMesures() {
    final brut = _prefs.getString(_cleMesures);
    if (brut == null) return [];
    try {
      final liste = jsonDecode(brut) as List<dynamic>;
      return liste
          .map((e) => Mesure.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    } on Object {
      // Données illisibles : on repart d'une liste vide plutôt que de planter.
      return [];
    }
  }

  Future<void> enregistrerMesures(List<Mesure> mesures) => _prefs.setString(
    _cleMesures,
    jsonEncode(mesures.map((m) => m.toJson()).toList()),
  );
}
