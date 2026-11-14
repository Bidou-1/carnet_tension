import 'package:flutter/material.dart';

import '../models/mesure.dart';
import '../utils/format.dart';
import '../widgets/badge_categorie.dart';
import '../widgets/pulsation_douce.dart';

/// Onglet Accueil : dernière mesure en évidence, puis l'historique.
class HistoriquePage extends StatelessWidget {
  const HistoriquePage({
    super.key,
    required this.mesures,
    required this.onSupprimer,
  });

  final List<Mesure> mesures;
  final ValueChanged<Mesure> onSupprimer;

  @override
  Widget build(BuildContext context) {
    if (mesures.isEmpty) return const _EtatVide();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        PulsationDouce(
          actif: mesures.first.categorie.estAnormale,
          couleur: mesures.first.categorie.couleur,
          borderRadius: BorderRadius.circular(22),
          bordure: false,
          child: _DerniereMesureCard(mesure: mesures.first),
        ),
        const SizedBox(height: 24),
        Text(
          'Historique',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          'Glissez une mesure vers la gauche pour la supprimer.',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 12),
        for (final mesure in mesures)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Dismissible(
              key: ValueKey(mesure.id),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => onSupprimer(mesure),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              child: PulsationDouce(
                actif: mesure.categorie.estAnormale,
                couleur: mesure.categorie.couleur,
                borderRadius: BorderRadius.circular(18),
                child: _MesureTile(mesure: mesure),
              ),
            ),
          ),
      ],
    );
  }
}

class _DerniereMesureCard extends StatelessWidget {
  const _DerniereMesureCard({required this.mesure});

  final Mesure mesure;

  @override
  Widget build(BuildContext context) {
    final couleur = mesure.categorie.couleur;
    const blanc = TextStyle(color: Colors.white);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(couleur, Colors.black, 0.1)!,
            Color.lerp(couleur, Colors.black, 0.4)!,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: couleur.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dernière mesure',
            style: blanc.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${mesure.systolique} / ${mesure.diastolique}',
                style: blanc.copyWith(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text('mmHg', style: blanc.copyWith(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                '${mesure.pouls} bpm',
                style: blanc.copyWith(fontSize: 15),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.schedule, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  formatDateHeure(mesure.date),
                  style: blanc.copyWith(fontSize: 15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              mesure.categorie.label,
              style: TextStyle(
                color: mesure.categorie.couleurFoncee,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MesureTile extends StatelessWidget {
  const _MesureTile({required this.mesure});

  final Mesure mesure;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 7, color: mesure.categorie.couleur),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${mesure.systolique} / ${mesure.diastolique}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'mmHg',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.favorite,
                          size: 16,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${mesure.pouls} bpm',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDateHeure(mesure.date),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 10),
                    BadgeCategorie(mesure.categorie),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EtatVide extends StatelessWidget {
  const _EtatVide();

  @override
  Widget build(BuildContext context) {
    final primaire = Theme.of(context).colorScheme.primary;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: primaire.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.monitor_heart_outlined, size: 64, color: primaire),
            ),
            const SizedBox(height: 20),
            const Text(
              'Aucune mesure pour le moment',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Appuyez sur « Nouvelle mesure » pour enregistrer votre première tension.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
