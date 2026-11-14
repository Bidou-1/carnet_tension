import 'package:flutter/material.dart';

/// Carte du numéro d'urgence qui clignote en rouge pour attirer l'attention.
class UrgenceCard extends StatefulWidget {
  const UrgenceCard({super.key});

  @override
  State<UrgenceCard> createState() => _UrgenceCardState();
}

class _UrgenceCardState extends State<UrgenceCard>
    with SingleTickerProviderStateMixin {
  static const _rougeFonce = Color(0xFF8E0000);
  static const _rougeVif = Color(0xFFFF1744);

  late final AnimationController _controleur = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controleur.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controleur,
      builder: (context, contenu) {
        final t = Curves.easeInOut.transform(_controleur.value);
        return Container(
          decoration: BoxDecoration(
            color: Color.lerp(_rougeFonce, _rougeVif, t),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _rougeVif.withValues(alpha: 0.2 + 0.5 * t),
                blurRadius: 8 + 22 * t,
                spreadRadius: 1 + 4 * t,
              ),
            ],
          ),
          child: contenu,
        );
      },
      child: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.white, size: 30),
                SizedBox(width: 8),
                Text(
                  'URGENCE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Structure de santé partenaire',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone_in_talk, color: Colors.white, size: 26),
                SizedBox(width: 10),
                SelectableText(
                  '+226 05 32 40 40',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Appelez ce numéro en cas d\'urgence ou de besoin médical.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
