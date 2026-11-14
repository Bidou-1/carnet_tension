import 'package:flutter/material.dart';

import '../widgets/urgence_card.dart';

/// Onglet Conseils : numéro d'urgence clignotant puis conseils de santé.
class ConseilsPage extends StatelessWidget {
  const ConseilsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const UrgenceCard(),
        const SizedBox(height: 28),
        Text(
          'Conseils de santé',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const _ConseilCard(
          icone: Icons.restaurant,
          couleur: Color(0xFF00897B),
          titre: 'Réduisez votre consommation de sel',
          texte:
              'Une alimentation moins salée aide à réguler la tension artérielle.',
        ),
        const _ConseilCard(
          icone: Icons.directions_walk,
          couleur: Color(0xFF1E88E5),
          titre: 'Pratiquez une activité physique régulière',
          texte:
              '30 minutes de marche par jour suffisent pour entretenir le cœur.',
        ),
        const _ConseilCard(
          icone: Icons.bedtime_outlined,
          couleur: Color(0xFF5E35B1),
          titre: 'Évitez le stress et veillez à bien dormir',
          texte:
              'Le repos est essentiel pour maintenir une bonne santé cardiovasculaire.',
        ),
        const _ConseilCard(
          icone: Icons.event_seat_outlined,
          couleur: Color(0xFFF4511E),
          titre: 'Mesurez-vous au calme',
          texte:
              'Restez assis 5 minutes avant la mesure, le bras posé à hauteur du cœur.',
        ),
      ],
    );
  }
}

class _ConseilCard extends StatelessWidget {
  const _ConseilCard({
    required this.icone,
    required this.couleur,
    required this.titre,
    required this.texte,
  });

  final IconData icone;
  final Color couleur;
  final String titre;
  final String texte;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: couleur.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icone, color: couleur, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      texte,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.35,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
