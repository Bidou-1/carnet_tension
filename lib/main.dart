import 'package:flutter/material.dart';

import 'pages/main_page.dart';
import 'pages/onboarding_page.dart';
import 'services/stockage.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final stockage = await Stockage.ouvrir();
  runApp(CarnetTensionApp(stockage: stockage));
}

class CarnetTensionApp extends StatelessWidget {
  const CarnetTensionApp({super.key, required this.stockage});

  final Stockage stockage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carnet de Tension',
      theme: construireTheme(),
      debugShowCheckedModeBanner: false,
      // L'écran de consentement ne s'affiche qu'une seule fois.
      home: stockage.consentementDonne
          ? MainPage(stockage: stockage)
          : OnboardingPage(stockage: stockage),
    );
  }
}
