import 'package:flutter/material.dart';

import '../models/mesure.dart';

/// Pastille colorée indiquant la catégorie de tension.
class BadgeCategorie extends StatelessWidget {
  const BadgeCategorie(this.categorie, {super.key});

  final Categorie categorie;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: categorie.couleur.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: categorie.couleur.withValues(alpha: 0.55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: categorie.couleur,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              categorie.label,
              style: TextStyle(
                color: categorie.couleurFoncee,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
