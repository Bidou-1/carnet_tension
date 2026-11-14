import 'package:flutter/material.dart';

import '../models/mesure.dart';
import '../utils/format.dart';
import '../widgets/badge_categorie.dart';
import '../widgets/pulsation_douce.dart';

/// Onglet Statistiques : moyenne des 7 derniers jours, évolution et légende.
class StatistiquesPage extends StatelessWidget {
  const StatistiquesPage({super.key, required this.mesures});

  /// Mesures triées de la plus récente à la plus ancienne.
  final List<Mesure> mesures;

  @override
  Widget build(BuildContext context) {
    final limite = DateTime.now().subtract(const Duration(days: 7));
    final recentes = mesures.where((m) => m.date.isAfter(limite)).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _MoyenneCard(recentes: recentes),
        const SizedBox(height: 16),
        _GraphiqueCard(mesures: mesures),
        const SizedBox(height: 16),
        const _LegendeCard(),
      ],
    );
  }
}

class _Titre extends StatelessWidget {
  const _Titre(this.icone, this.texte);

  final IconData icone;
  final String texte;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icone, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            texte,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _MoyenneCard extends StatelessWidget {
  const _MoyenneCard({required this.recentes});

  final List<Mesure> recentes;

  @override
  Widget build(BuildContext context) {
    final contenu = <Widget>[
      const _Titre(Icons.calendar_month, 'Moyenne des 7 derniers jours'),
      const SizedBox(height: 16),
    ];

    Categorie? categorieMoyenne;
    if (recentes.isEmpty) {
      contenu.add(
        Text(
          'Aucune mesure ces 7 derniers jours.',
          style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
        ),
      );
    } else {
      int moyenne(int Function(Mesure) valeur) =>
          (recentes.fold<int>(0, (s, m) => s + valeur(m)) / recentes.length)
              .round();
      final systolique = moyenne((m) => m.systolique);
      final diastolique = moyenne((m) => m.diastolique);
      final pouls = moyenne((m) => m.pouls);
      final categorie = classer(systolique, diastolique);
      categorieMoyenne = categorie;

      contenu.addAll([
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '$systolique / $diastolique',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: categorie.couleurFoncee,
              ),
            ),
            const SizedBox(width: 6),
            Text('mmHg', style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Pouls moyen : $pouls bpm  ·  ${recentes.length} '
          'mesure${recentes.length > 1 ? 's' : ''}',
          style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 12),
        BadgeCategorie(categorie),
      ]);
    }

    return PulsationDouce(
      actif: categorieMoyenne?.estAnormale ?? false,
      couleur: categorieMoyenne?.couleur ?? Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: contenu,
          ),
        ),
      ),
    );
  }
}

class _GraphiqueCard extends StatelessWidget {
  const _GraphiqueCard({required this.mesures});

  final List<Mesure> mesures;

  static const _hauteurMax = 150.0;

  double _hauteur(int valeur) =>
      (valeur / 200 * _hauteurMax).clamp(8.0, _hauteurMax);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Titre(Icons.show_chart, 'Évolution de la tension'),
            const SizedBox(height: 6),
            Text(
              'Barre pleine : systolique  ·  barre claire : diastolique',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            if (mesures.isEmpty)
              Text(
                'Aucune donnée à afficher.',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              )
            else
              SizedBox(
                height: 200,
                // reverse : la mesure la plus récente est à droite et visible d'emblée.
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  itemCount: mesures.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final m = mesures[index];
                    final couleur = m.categorie.couleur;
                    return SizedBox(
                      width: 52,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${m.systolique}/${m.diastolique}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: m.categorie.couleurFoncee,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _Barre(_hauteur(m.systolique), couleur),
                              const SizedBox(width: 3),
                              _Barre(
                                _hauteur(m.diastolique),
                                couleur.withValues(alpha: 0.45),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            formatJourCourt(m.date),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Barre extends StatelessWidget {
  const _Barre(this.hauteur, this.couleur);

  final double hauteur;
  final Color couleur;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: hauteur,
      decoration: BoxDecoration(
        color: couleur,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
      ),
    );
  }
}

class _LegendeCard extends StatelessWidget {
  const _LegendeCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Titre(Icons.palette_outlined, 'Comprendre les couleurs'),
            const SizedBox(height: 4),
            Text(
              'Valeurs en mmHg (systolique / diastolique)',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            for (final c in Categorie.values)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: c.couleur,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.label,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: c.couleurFoncee,
                            ),
                          ),
                          Text(
                            c.seuils,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
