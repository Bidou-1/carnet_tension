import 'package:flutter/material.dart';

/// Halo lumineux qui pulse lentement autour de [child] quand [actif] est vrai.
/// Sert à signaler doucement une mesure anormale, sans effet agressif.
class PulsationDouce extends StatefulWidget {
  const PulsationDouce({
    super.key,
    required this.actif,
    required this.couleur,
    required this.borderRadius,
    required this.child,
    this.bordure = true,
  });

  final bool actif;
  final Color couleur;
  final BorderRadius borderRadius;
  final Widget child;

  /// Ajoute un contour coloré qui pulse aussi (utile sur les cartes blanches).
  final bool bordure;

  @override
  State<PulsationDouce> createState() => _PulsationDouceState();
}

class _PulsationDouceState extends State<PulsationDouce>
    with SingleTickerProviderStateMixin {
  // Cycle lent (1,8 s dans chaque sens) pour rester discret.
  late final AnimationController _controleur = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void initState() {
    super.initState();
    if (widget.actif) _controleur.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(PulsationDouce ancien) {
    super.didUpdateWidget(ancien);
    if (widget.actif && !_controleur.isAnimating) {
      _controleur.repeat(reverse: true);
    } else if (!widget.actif && _controleur.isAnimating) {
      _controleur
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _controleur.dispose();
    super.dispose();
  }

  Widget _decorer(double t, Widget? enfant) {
    final c = widget.couleur;
    return Container(
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        boxShadow: [
          BoxShadow(
            color: c.withValues(alpha: 0.10 + 0.30 * t),
            blurRadius: 6 + 12 * t,
            spreadRadius: 0.5 + 2 * t,
          ),
        ],
      ),
      foregroundDecoration: widget.bordure
          ? BoxDecoration(
              borderRadius: widget.borderRadius,
              border: Border.all(
                color: c.withValues(alpha: 0.25 + 0.45 * t),
                width: 2,
              ),
            )
          : null,
      child: enfant,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.actif) return widget.child;
    // Si l'utilisateur a demandé moins d'animations, halo fixe.
    if (MediaQuery.disableAnimationsOf(context)) {
      return _decorer(0.6, widget.child);
    }
    return AnimatedBuilder(
      animation: _controleur,
      builder: (context, enfant) =>
          _decorer(Curves.easeInOut.transform(_controleur.value), enfant),
      child: widget.child,
    );
  }
}
