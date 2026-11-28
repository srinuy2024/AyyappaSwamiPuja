// lib/widgets/sacred_glass_card.dart
import 'dart:ui';
import 'package:flutter/material.dart';

/// పవిత్ర స్ఫటిక / ట్రాన్స్‌పరెంట్ 3D గ్లాస్‌మార్ఫిక్ కంటైనర్ (Ultra-Transparent Glassmorphic Container)
/// Inspired by modern OxygenOS / iOS control-center frosted glass aesthetics
class SacredGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? glassColor;
  final Color? borderColor;
  final double blurAmount;
  final bool isLight;
  final VoidCallback? onTap;

  const SacredGlassCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(14.0),
    this.margin,
    this.borderRadius = 20.0,
    this.glassColor,
    this.borderColor,
    this.blurAmount = 18.0,
    this.isLight = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isLight ? 0.06 : 0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: (borderColor ?? Colors.amber).withValues(alpha: isLight ? 0.05 : 0.08),
            blurRadius: 8,
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
              color: glassColor ??
                  (isLight ? Colors.white.withValues(alpha: 0.60) : Colors.white.withValues(alpha: 0.10)),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ??
                    (isLight ? Colors.white.withValues(alpha: 0.85) : Colors.white.withValues(alpha: 0.22)),
                width: 1.0,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isLight
                    ? [
                        (glassColor ?? Colors.white).withValues(alpha: 0.75),
                        (glassColor ?? Colors.white).withValues(alpha: 0.45),
                        Colors.amber.shade50.withValues(alpha: 0.30),
                      ]
                    : [
                        (glassColor ?? Colors.white).withValues(alpha: 0.16),
                        (glassColor ?? Colors.white).withValues(alpha: 0.07),
                        Colors.black.withValues(alpha: 0.24),
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
