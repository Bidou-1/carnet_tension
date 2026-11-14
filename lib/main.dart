import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CarnetTensionApp());
}

class CarnetTensionApp extends StatelessWidget {
  const CarnetTensionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carnet de Tension',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const OnboardingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 1. Écran de consentement RGPD
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenue - Carnet de Tension'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.favorite, size: 80, color: Colors.redAccent),
            const SizedBox(height: 20),
            const Text(
              'Suivez votre santé cardiovasculaire en toute simplicité.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Conformité RGPD :\n'
              'Les données de tension enregistrées sont stockées uniquement de manière locale sur votre appareil. Aucune donnée personnelle n\'est partagée.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              },
              child: const Text(
                'J\'accepte et continuer',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text(
                'Je refuse (Quitter)',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Classe Mesure mise à jour selon le tableau officiel fourni
class Mesure {
  final String date;
  final int systolique;
  final int diastolique;
  final int pouls;

  Mesure({
    required this.date,
    required this.systolique,
    required this.diastolique,
    required this.pouls,
  });

  String get statut {
    if (systolique < 120 && diastolique < 80) {
      return 'Optimale';
    } else if ((systolique >= 120 && systolique <= 129) ||
        (diastolique >= 80 && diastolique <= 84)) {
      return 'Normale';
    } else if ((systolique >= 130 && systolique <= 139) ||
        (diastolique >= 85 && diastolique <= 89)) {
      return 'Normal Haute';
    } else if (systolique >= 180 || diastolique >= 110) {
      return 'Hypertension grade 3';
    } else if ((systolique >= 160 && systolique <= 179) ||
        (diastolique >= 100 && diastolique <= 109)) {
      return 'Hypertension grade 2';
    } else if ((systolique >= 140 && systolique <= 159) ||
        (diastolique >= 90 && diastolique <= 99)) {
      return 'Hypertension grade 1';
    } else if (systolique >= 140 && diastolique < 90) {
      return 'Hypertension systolique isolée';
    } else {
      return 'Normal Haute';
    }
  }

  Color get couleur {
    if (systolique < 120 && diastolique < 80) {
      return Colors.green; // Optimale
    } else if ((systolique >= 120 && systolique <= 129) ||
        (diastolique >= 80 && diastolique <= 84)) {
      return Colors.lightGreen; // Normale
    } else if ((systolique >= 130 && systolique <= 139) ||
        (diastolique >= 85 && diastolique <= 89)) {
      return Colors.orange; // Normal Haute
    } else if (systolique >= 140 || diastolique >= 90) {
      return Colors.red; // Grades 1, 2, 3 et systolique isolée
    } else {
      return Colors.blue;
    }
  }
}

// 2. Page principale avec les onglets
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Mesure> _mesures = [
    Mesure(
      date: '14/11/2026 08:30',
      systolique: 120,
      diastolique: 80,
      pouls: 72,
    ),
    Mesure(
      date: '13/11/2026 09:00',
      systolique: 145,
      diastolique: 95,
      pouls: 80,
    ),
  ];

  final _systoliqueController = TextEditingController();
  final _diastoliqueController = TextEditingController();
  final _poulsController = TextEditingController();

  void _ajouterMesure() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nouvelle mesure'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Signal / Avertissement pour les adultes et personnes âgées
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade700),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info, color: Colors.amber), // Correction ici
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Attention : Cette application est réservée aux adultes et personnes âgées.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _systoliqueController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Tension Systolique (mmHg)',
                  ),
                ),
                TextField(
                  controller: _diastoliqueController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Tension Diastolique (mmHg)',
                  ),
                ),
                TextField(
                  controller: _poulsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Pouls (bpm)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_systoliqueController.text.isNotEmpty &&
                    _diastoliqueController.text.isNotEmpty &&
                    _poulsController.text.isNotEmpty) {
                  final now = DateTime.now();
                  final dateFormatted =
                      '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

                  setState(() {
                    _mesures.insert(
                      0,
                      Mesure(
                        date: dateFormatted,
                        systolique: int.parse(_systoliqueController.text),
                        diastolique: int.parse(_diastoliqueController.text),
                        pouls: int.parse(_poulsController.text),
                      ),
                    );
                  });

                  _systoliqueController.clear();
                  _diastoliqueController.clear();
                  _poulsController.clear();

                  Navigator.pop(context);
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void _supprimerMesure(int index) {
    setState(() {
      _mesures.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // Onglet 0 : Accueil / Historique
      _mesures.isEmpty
          ? const Center(
              child: Text('Aucune mesure enregistrée pour le moment.'),
            )
          : ListView.builder(
              itemCount: _mesures.length,
              itemBuilder: (context, index) {
                final mesure = _mesures[index];
                return Dismissible(
                  key: Key(mesure.date + index.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _supprimerMesure(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mesure supprimée')),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: mesure.couleur,
                        child: const Icon(Icons.favorite, color: Colors.white),
                      ),
                      title: Text(
                        '${mesure.systolique} / ${mesure.diastolique} mmHg',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Pouls : ${mesure.pouls} bpm\nDate : ${mesure.date}',
                      ),
                      isThreeLine: true,
                      trailing: Chip(
                        label: Text(
                          mesure.statut,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                        backgroundColor: mesure.couleur,
                      ),
                    ),
                  ),
                );
              },
            ),

      // Onglet 1 : Statistiques, Moyenne & Graphique d'évolution
      SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistiques et Évolution',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Moyenne Hebdomadaire',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _mesures.isNotEmpty
                          ? '${(_mesures.map((e) => e.systolique).reduce((a, b) => a + b) / _mesures.length).toStringAsFixed(0)} / ${(_mesures.map((e) => e.diastolique).reduce((a, b) => a + b) / _mesures.length).toStringAsFixed(0)} mmHg'
                          : 'N/A',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Graphique d\'évolution (Tension Systolique)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _mesures.isEmpty
                ? const Text('Aucune donnée à afficher.')
                : Container(
                    height: 220,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _mesures.length,
                      itemBuilder: (context, index) {
                        final m = _mesures[_mesures.length - 1 - index];
                        double hauteurBarre = (m.systolique / 200) * 150;
                        if (hauteurBarre > 150) hauteurBarre = 150;
                        if (hauteurBarre < 20) hauteurBarre = 20;

                        return Container(
                          width: 70,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${m.systolique}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 25,
                                height: hauteurBarre,
                                decoration: BoxDecoration(
                                  color: m.couleur,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                m.date.split(' ')[0],
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
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

      // Onglet 2 : Conseils & Numéro d'urgence
      ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Text(
            'Conseils de Santé',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text('Réduisez votre consommation de sel'),
            subtitle: Text(
              'Une alimentation moins salée aide à réguler la tension artérielle.',
            ),
          ),
          ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text('Pratiquez une activité physique régulière'),
            subtitle: Text(
              '30 minutes de marche par jour suffisent pour entretenir le cœur.',
            ),
          ),
          ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text('Évitez le stress et veillez à bien dormir'),
            subtitle: Text(
              'Le repos est essentiel pour maintenir une bonne santé cardiovasculaire.',
            ),
          ),
          Divider(height: 30),
          Card(
            color: Colors.redAccent,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(Icons.phone, color: Colors.white, size: 30),
                  SizedBox(height: 10),
                  Text(
                    'Structure de santé partenaire',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '+226 05 32 40 40',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Contactez ce numéro en cas d\'urgence ou de besoin médical.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carnet de Suivi de Tension'),
        backgroundColor: Colors.blueAccent,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistiques',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Conseils',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: _ajouterMesure,
              backgroundColor: Colors.blueAccent,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
