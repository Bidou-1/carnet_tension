import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/stockage.dart';
import '../theme.dart';
import 'main_page.dart';

/// Écran de consentement RGPD, affiché uniquement au premier lancement.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, required this.stockage});

  final Stockage stockage;

  Future<void> _accepter(BuildContext context) async {
    await stockage.accepterConsentement();
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => MainPage(stockage: stockage)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [couleurPrincipaleFoncee, Color(0xFF1E88E5)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(26),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        size: 72,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Carnet de Tension',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Suivez votre santé cardiovasculaire en toute simplicité.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                    const SizedBox(height: 32),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.lock_outline, color: couleurPrincipale),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Vos données restent chez vous',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Conformément au RGPD, vos mesures sont enregistrées '
                              'uniquement sur cet appareil. Aucune donnée personnelle '
                              'n\'est partagée.',
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.4,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: couleurPrincipaleFoncee,
                          textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () => _accepter(context),
                        child: const Text('J\'accepte et je continue'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white70),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: () => SystemNavigator.pop(),
                        child: const Text('Je refuse (quitter)'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
