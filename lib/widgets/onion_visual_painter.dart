import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/onion_model.dart';
import '../theme/app_theme.dart';

/// Custom painter to draw an agricultural onion with realistic bulb shape,
/// concentric tunic skin layers, dry neck, root disc, and subtle highlights.
class OnionBulbPainter extends CustomPainter {
  final Color baseColor;
  final Color secondaryColor;
  final Color highlightColor;
  final bool isRedOnion;
  final double scaleDefectRatio;

  const OnionBulbPainter({
    this.baseColor = const Color(0xFF881337), // Crimson red onion
    this.secondaryColor = const Color(0xFF9F1239),
    this.highlightColor = const Color(0xFFBE123C),
    this.isRedOnion = true,
    this.scaleDefectRatio = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final center = Offset(w / 2, h / 2);

    // 1. Root disc at bottom
    final rootPaint = Paint()
      ..color = const Color(0xFF78350F)
      ..style = PaintingStyle.fill;
    final rootPath = Path();
    rootPath.moveTo(w * 0.44, h * 0.88);
    rootPath.quadraticBezierTo(w * 0.5, h * 0.96, w * 0.56, h * 0.88);
    canvas.drawPath(rootPath, rootPaint);

    // Root hairs
    final hairPaint = Paint()
      ..color = const Color(0xFF92400E)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.47, h * 0.92), Offset(w * 0.45, h * 0.98), hairPaint);
    canvas.drawLine(Offset(w * 0.50, h * 0.93), Offset(w * 0.50, h * 0.99), hairPaint);
    canvas.drawLine(Offset(w * 0.53, h * 0.92), Offset(w * 0.55, h * 0.98), hairPaint);

    // 2. Main onion bulb outline path
    final bulbPath = Path();
    bulbPath.moveTo(w * 0.50, h * 0.12); // Neck top
    // Right shoulder and belly
    bulbPath.cubicTo(
      w * 0.70, h * 0.18, // Neck flare
      w * 0.92, h * 0.45, // Right belly
      w * 0.78, h * 0.82, // Lower right
    );
    // Base curves to root disc
    bulbPath.quadraticBezierTo(w * 0.55, h * 0.90, w * 0.50, h * 0.90);
    // Base curves to left
    bulbPath.quadraticBezierTo(w * 0.45, h * 0.90, w * 0.22, h * 0.82);
    // Left belly and shoulder
    bulbPath.cubicTo(
      w * 0.08, h * 0.45,
      w * 0.30, h * 0.18,
      w * 0.50, h * 0.12,
    );
    bulbPath.close();

    // 3. Bulb gradient fill (simulate spherical volume & shiny outer tunic)
    final bulbGradient = RadialGradient(
      center: const Alignment(-0.25, -0.2),
      radius: 0.85,
      colors: isRedOnion
          ? [
              const Color(0xFFBE185D), // Highlight red-purple
              baseColor,               // Deep burgundy
              const Color(0xFF4C0519), // Shadow burgundy
            ]
          : [
              const Color(0xFFFDE68A), // Light gold
              const Color(0xFFD97706), // Rich onion gold
              const Color(0xFF78350F), // Bronze base
            ],
      stops: const [0.0, 0.65, 1.0],
    );

    final bulbPaint = Paint()
      ..shader = bulbGradient.createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;
    canvas.drawPath(bulbPath, bulbPaint);

    // 4. Concentric longitudinal tunic scale veins
    final veinPaint = Paint()
      ..color = (isRedOnion ? const Color(0xFF4C0519) : const Color(0xFF92400E)).withOpacity(0.35)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final vein1 = Path();
    vein1.moveTo(w * 0.50, h * 0.14);
    vein1.cubicTo(w * 0.65, h * 0.38, w * 0.68, h * 0.65, w * 0.50, h * 0.88);
    canvas.drawPath(vein1, veinPaint);

    final vein2 = Path();
    vein2.moveTo(w * 0.50, h * 0.14);
    vein2.cubicTo(w * 0.35, h * 0.38, w * 0.32, h * 0.65, w * 0.50, h * 0.88);
    canvas.drawPath(vein2, veinPaint);

    final vein3 = Path();
    vein3.moveTo(w * 0.50, h * 0.14);
    vein3.cubicTo(w * 0.80, h * 0.42, w * 0.78, h * 0.70, w * 0.50, h * 0.88);
    canvas.drawPath(vein3, veinPaint);

    final vein4 = Path();
    vein4.moveTo(w * 0.50, h * 0.14);
    vein4.cubicTo(w * 0.20, h * 0.42, w * 0.22, h * 0.70, w * 0.50, h * 0.88);
    canvas.drawPath(vein4, veinPaint);

    // 5. Specular spherical highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.38, h * 0.38),
        width: w * 0.28,
        height: h * 0.38,
      ),
      highlightPaint,
    );

    // 6. Dried neck tip at the top
    final neckPaint = Paint()
      ..color = const Color(0xFF78350F)
      ..style = PaintingStyle.fill;
    final neckPath = Path();
    neckPath.moveTo(w * 0.48, h * 0.14);
    neckPath.lineTo(w * 0.47, h * 0.05);
    neckPath.lineTo(w * 0.53, h * 0.04);
    neckPath.lineTo(w * 0.52, h * 0.14);
    neckPath.close();
    canvas.drawPath(neckPath, neckPaint);

    // Dried papery twist
    final twistPaint = Paint()
      ..color = const Color(0xFFD97706)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.50, h * 0.05), Offset(w * 0.52, h * 0.01), twistPaint);

    // 7. Optional defect indication marker if defect ratio > 0
    if (scaleDefectRatio > 0) {
      final defectPaint = Paint()
        ..color = AppColors.gradeC.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(Offset(w * 0.65, h * 0.60), w * 0.14, defectPaint);
    }
  }

  @override
  bool shouldRepaint(covariant OnionBulbPainter oldDelegate) {
    return oldDelegate.baseColor != baseColor ||
        oldDelegate.isRedOnion != isRedOnion ||
        oldDelegate.scaleDefectRatio != scaleDefectRatio;
  }
}

/// Standalone GRADION High-Tech Logo Widget
class GradionLogoWidget extends StatelessWidget {
  final double size;
  final bool showBadge;

  const GradionLogoWidget({
    super.key,
    this.size = 80,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Optical scanner concentric circles backdrop
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primarySurface,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 1.5,
              ),
            ),
          ),
          Container(
            width: size * 0.78,
            height: size * 0.78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 1.2,
                style: BorderStyle.solid,
              ),
            ),
          ),
          // Onion bulb graphic
          SizedBox(
            width: size * 0.56,
            height: size * 0.56,
            child: const CustomPaint(
              painter: OnionBulbPainter(isRedOnion: true),
            ),
          ),
          // Agronomic Grade A badge in corner
          if (showBadge)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.gradeA,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gradeA.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Detailed Onion Caliber & Inspection Diagram for Detailed Analysis Screen
class DetailedOnionDiagram extends StatelessWidget {
  final OnionDetection onion;
  final double size;

  const DetailedOnionDiagram({
    super.key,
    required this.onion,
    this.size = 220,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background engineering millimeter grid
          CustomPaint(
            size: Size(size, size),
            painter: _EngineeringGridPainter(),
          ),

          // Render Onion Bulb
          SizedBox(
            width: size * 0.70,
            height: size * 0.70,
            child: CustomPaint(
              painter: OnionBulbPainter(
                isRedOnion: onion.variety.contains('Red'),
                scaleDefectRatio: onion.grade == OnionGrade.gradeC
                    ? 0.4
                    : (onion.grade == OnionGrade.gradeB ? 0.15 : 0.0),
              ),
            ),
          ),

          // Caliber measurement caliper line across equatorial diameter
          Positioned(
            left: 12,
            right: 12,
            child: Row(
              children: [
                // Left caliper bracket
                Container(
                  width: 3,
                  height: 24,
                  color: AppColors.primary,
                ),
                Expanded(
                  child: Container(
                    height: 1.5,
                    color: AppColors.primary.withOpacity(0.6),
                  ),
                ),
                // Caliber Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    onion.diameterFormatted,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1.5,
                    color: AppColors.primary.withOpacity(0.6),
                  ),
                ),
                // Right caliper bracket
                Container(
                  width: 3,
                  height: 24,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),

          // Grade Badge tag top-right
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: onion.grade.backgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: onion.grade.borderColor),
              ),
              child: Text(
                onion.grade.label,
                style: TextStyle(
                  color: onion.grade.color,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          // Confidence score pill bottom-left
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                'AI Confidence: ${onion.confidencePercent}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EngineeringGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.borderLight.withOpacity(0.7)
      ..strokeWidth = 0.8;

    const double step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
