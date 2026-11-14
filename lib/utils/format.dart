String _deuxChiffres(int n) => n.toString().padLeft(2, '0');

/// Exemple : 14/11/2026 à 08h30
String formatDateHeure(DateTime d) =>
    '${_deuxChiffres(d.day)}/${_deuxChiffres(d.month)}/${d.year} '
    'à ${_deuxChiffres(d.hour)}h${_deuxChiffres(d.minute)}';

/// Exemple : 14/11
String formatJourCourt(DateTime d) =>
    '${_deuxChiffres(d.day)}/${_deuxChiffres(d.month)}';
