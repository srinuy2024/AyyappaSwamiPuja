// lib/widgets/sacred_glass_card.dart
import 'dart:ui';
import 'package:flutter/material.dart';

/// పవిత్ర స్ఫటిక / ట్రాన్స్‌పరెంట్ 3D గ్లాస్‌మార్ఫిక్ కంటైనర్ (Sacred Glassmorphic Container)
class SacredGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? glassColor;
  final Color? borderColor;
  final double blurAmount;
  final VoidCallback? onTap;

  const SacredGlassCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.borderRadius = 16.0,
    this.glassColor,
    this.borderColor,
    this.blurAmount = 14.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.shade900.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: glassColor ?? Colors.white.withValues(alpha: 0.68),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ?? Colors.white.withValues(alpha: 0.85),
                width: 1.4,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (glassColor ?? Colors.white).withValues(alpha: 0.80),
                  (glassColor ?? Colors.white).withValues(alpha: 0.55),
                  Colors.amber.shade50.withValues(alpha: 0.40),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      cardContent = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: cardContent,
      );
    }

    if (margin != null) {
      return Padding(
        padding: margin!,
        child: cardContent,
      );
    }

    return cardContent;
  }
}
