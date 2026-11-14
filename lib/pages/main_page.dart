import 'package:flutter/material.dart';

import '../models/mesure.dart';
import '../services/stockage.dart';
import '../widgets/mesure_dialog.dart';
import 'conseils_page.dart';
import 'historique_page.dart';
import 'statistiques_page.dart';

/// Écran principal avec les 3 onglets : Accueil, Statistiques, Conseils.
class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.stockage});

  final Stockage stockage;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const _titres = ['Mes mesures', 'Statistiques', 'Conseils & urgence'];

  int _onglet = 0;
  late final List<Mesure> _mesures = widget.stockage.chargerMesures();

  Future<void> _ajouterMesure() async {
    final mesure = await showDialog<Mesure>(
      context: context,
      builder: (_) => const MesureDialog(),
    );
    if (mesure == null || !mounted) return;
    setState(() => _mesures.insert(0, mesure));
    await widget.stockage.enregistrerMesures(_mesures);
  }

  void _supprimerMesure(Mesure mesure) {
    setState(() => _mesures.removeWhere((m) => m.id == mesure.id));
    widget.stockage.enregistrerMesures(_mesures);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Mesure supprimée')));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HistoriquePage(mesures: _mesures, onSupprimer: _supprimerMesure),
      StatistiquesPage(mesures: _mesures),
      const ConseilsPage(),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(_titres[_onglet])),
      body: pages[_onglet],
      floatingActionButton: _onglet == 0
          ? FloatingActionButton.extended(
              onPressed: _ajouterMesure,
              icon: const Icon(Icons.add),
              label: const Text('Nouvelle mesure'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _onglet,
        onDestinationSelected: (i) => setState(() => _onglet = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Statistiques',
          ),
          NavigationDestination(
            icon: Icon(Icons.medical_services_outlined),
            selectedIcon: Icon(Icons.medical_services),
            label: 'Conseils',
          ),
        ],
      ),
    );
  }
}
