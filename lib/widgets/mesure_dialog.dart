import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/mesure.dart';

/// Formulaire de saisie d'une mesure. Renvoie la [Mesure] créée, ou null si annulé.
class MesureDialog extends StatefulWidget {
  const MesureDialog({super.key});

  @override
  State<MesureDialog> createState() => _MesureDialogState();
}

class _MesureDialogState extends State<MesureDialog> {
  final _formKey = GlobalKey<FormState>();
  final _systolique = TextEditingController();
  final _diastolique = TextEditingController();
  final _pouls = TextEditingController();

  @override
  void dispose() {
    _systolique.dispose();
    _diastolique.dispose();
    _pouls.dispose();
    super.dispose();
  }

  int? _lire(String? texte) => int.tryParse(texte?.trim() ?? '');

  String? _verifierPlage(String? texte, int min, int max) {
    final valeur = _lire(texte);
    if (valeur == null) return 'Valeur obligatoire';
    if (valeur < min || valeur > max) return 'Doit être entre $min et $max';
    return null;
  }

  String? _verifierDiastolique(String? texte) {
    final erreur = _verifierPlage(texte, 40, 150);
    if (erreur != null) return erreur;
    final systolique = _lire(_systolique.text);
    if (systolique != null && _lire(texte)! >= systolique) {
      return 'Doit être inférieure à la systolique';
    }
    return null;
  }

  void _enregistrer() {
    if (!_formKey.currentState!.validate()) return;
    final maintenant = DateTime.now();
    Navigator.of(context).pop(
      Mesure(
        id: maintenant.microsecondsSinceEpoch.toString(),
        date: maintenant,
        systolique: _lire(_systolique.text)!,
        diastolique: _lire(_diastolique.text)!,
        pouls: _lire(_pouls.text)!,
      ),
    );
  }

  Widget _champ({
    required TextEditingController controleur,
    required String label,
    required String unite,
    required FormFieldValidator<String> validateur,
    bool dernier = false,
  }) {
    return TextFormField(
      controller: controleur,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      textInputAction: dernier ? TextInputAction.done : TextInputAction.next,
      onFieldSubmitted: dernier ? (_) => _enregistrer() : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateur,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(labelText: label, suffixText: unite),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.monitor_heart, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          const Text('Nouvelle mesure'),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade600),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber.shade800),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Cette application est réservée aux adultes et aux personnes âgées.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _champ(
                controleur: _systolique,
                label: 'Systolique (chiffre du haut)',
                unite: 'mmHg',
                validateur: (v) => _verifierPlage(v, 70, 250),
              ),
              const SizedBox(height: 12),
              _champ(
                controleur: _diastolique,
                label: 'Diastolique (chiffre du bas)',
                unite: 'mmHg',
                validateur: _verifierDiastolique,
              ),
              const SizedBox(height: 12),
              _champ(
                controleur: _pouls,
                label: 'Pouls',
                unite: 'bpm',
                validateur: (v) => _verifierPlage(v, 30, 220),
                dernier: true,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton.icon(
          onPressed: _enregistrer,
          icon: const Icon(Icons.check),
          label: const Text('Enregistrer'),
        ),
      ],
    );
  }
}
