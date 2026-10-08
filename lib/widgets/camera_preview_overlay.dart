import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/onion_model.dart';
import '../theme/app_theme.dart';
import 'onion_visual_painter.dart';

class CameraPreviewOverlay extends StatefulWidget {
  final List<OnionDetection> detections;
  final bool isScanning;
  final OnionGrade? filterGrade;
  final ValueChanged<OnionDetection>? onOnionTapped;

  const CameraPreviewOverlay({
    super.key,
    required this.detections,
    this.isScanning = true,
    this.filterGrade,
    this.onOnionTapped,
  });

  @override
  State<CameraPreviewOverlay> createState() => _CameraPreviewOverlayState();
}

class _CameraPreviewOverlayState extends State<CameraPreviewOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _laserController;
  late Animation<double> _laserAnimation;

  @override
  void initState() {
    super.initState();
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _laserAnimation = Tween<double>(begin: 0.08, end: 0.92).animate(
      CurvedAnimation(parent: _laserController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _laserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredDetections = widget.filterGrade == null
        ? widget.detections
        : widget.detections
            .where((d) => d.grade == widget.filterGrade)
            .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Stack(
          children: [
            // 1. Dark high-tech camera feed surface with inspection table texture
            Container(
              width: w,
              height: h,
              decoration: BoxDecoration(
                color: const Color(0xFF161F1A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryLight.withOpacity(0.4), width: 1.5),
              ),
              child: CustomPaint(
                painter: _ViewfinderGridPainter(),
              ),
            ),

            // 2. Render each detected onion visual at its relative coordinate
            ...widget.detections.map((onion) {
              final onionPixelSize = w * onion.size;
              final onionX = (w * onion.x) - (onionPixelSize / 2);
              final onionY = (h * onion.y) - (onionPixelSize / 2);

              return Positioned(
                left: onionX,
                top: onionY,
                width: onionPixelSize,
                height: onionPixelSize,
                child: CustomPaint(
                  painter: OnionBulbPainter(
                    isRedOnion: onion.variety.contains('Red'),
                    scaleDefectRatio: onion.grade == OnionGrade.gradeC
                        ? 0.35
                        : (onion.grade == OnionGrade.gradeB ? 0.15 : 0.0),
                  ),
                ),
              );
            }),

            // 3. Render Fake Detection Bounding Boxes
            ...filteredDetections.map((onion) {
              final boxW = w * onion.size * 1.32;
              final boxH = h * onion.size * 1.32;
              final boxX = (w * onion.x) - (boxW / 2);
              final boxY = (h * onion.y) - (boxH / 2);
              final color = onion.grade.color;

              return Positioned(
                left: boxX,
                top: boxY,
                width: boxW,
                height: boxH,
                child: GestureDetector(
                  onTap: () => widget.onOnionTapped?.call(onion),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Bounding box border
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: color, width: 1.5),
                          borderRadius: BorderRadius.circular(6),
                          color: color.withOpacity(0.08),
                        ),
                      ),
                      // Corner reticles
                      Positioned(
                        top: -2,
                        left: -2,
                        child: Container(width: 8, height: 8, color: color),
                      ),
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(width: 8, height: 8, color: color),
                      ),
                      Positioned(
                        bottom: -2,
                        left: -2,
                        child: Container(width: 8, height: 8, color: color),
                      ),
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: Container(width: 8, height: 8, color: color),
                      ),
                      // Detection tag label above bounding box
                      Positioned(
                        top: -18,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${onion.id} • ${onion.grade.shortLabel}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${onion.diameterMm.toInt()}mm',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            // 4. Animated Laser Scan Line (when scanning is active)
            if (widget.isScanning)
              AnimatedBuilder(
                animation: _laserAnimation,
                builder: (context, child) {
                  return Positioned(
                    top: h * _laserAnimation.value,
                    left: 12,
                    right: 12,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.gradeA.withOpacity(0.0),
                            AppColors.gradeA,
                            AppColors.gradeA,
                            AppColors.gradeA.withOpacity(0.0),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gradeA.withOpacity(0.8),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            // 5. Camera Viewfinder Corner Guides (Large aesthetic agri-tech brackets)
            Positioned(
              top: 14,
              left: 14,
              child: _buildCornerBracket(isTop: true, isLeft: true),
            ),
            Positioned(
              top: 14,
              right: 14,
              child: _buildCornerBracket(isTop: true, isLeft: false),
            ),
            Positioned(
              bottom: 14,
              left: 14,
              child: _buildCornerBracket(isTop: false, isLeft: true),
            ),
            Positioned(
              bottom: 14,
              right: 14,
              child: _buildCornerBracket(isTop: false, isLeft: false),
            ),

            // 6. Top Telemetry Pill: "12 onions detected" with animated green pulse
            Positioned(
              top: 14,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.gradeA.withOpacity(0.6),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.gradeA,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gradeA.withOpacity(0.8),
                              blurRadius: 6,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.detections.length} onions detected',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 7. Bottom Live Caliber / Lighting telemetry readout
            Positioned(
              bottom: 14,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.wb_sunny_outlined, size: 12, color: Colors.amber),
                        SizedBox(width: 5),
                        Text(
                          'Illumination: Good (480 lux)',
                          style: TextStyle(color: Colors.white70, fontSize: 10.5),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.straighten, size: 12, color: AppColors.gradeA),
                        SizedBox(width: 5),
                        Text(
                          'Dist: 45 cm (Optimal)',
                          style: TextStyle(color: Colors.white70, fontSize: 10.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCornerBracket({required bool isTop, required bool isLeft}) {
    const double length = 20.0;
    const double thickness = 2.5;
    const color = Colors.white70;

    return SizedBox(
      width: length,
      height: length,
      child: Stack(
        children: [
          // Horizontal arm
          Positioned(
            top: isTop ? 0 : null,
            bottom: !isTop ? 0 : null,
            left: 0,
            right: 0,
            child: Container(height: thickness, color: color),
          ),
          // Vertical arm
          Positioned(
            top: 0,
            bottom: 0,
            left: isLeft ? 0 : null,
            right: !isLeft ? 0 : null,
            child: Container(width: thickness, color: color),
          ),
        ],
      ),
    );
  }
}

class _ViewfinderGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1.0;

    // Draw grid
    final double step = size.width / 6;
    for (double x = step; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = step; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Center optical alignment cross
    final crossPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1.2;
    final cx = size.width / 2;
    final cy = size.height / 2;
    canvas.drawLine(Offset(cx - 15, cy), Offset(cx + 15, cy), crossPaint);
    canvas.drawLine(Offset(cx, cy - 15), Offset(cx, cy + 15), crossPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
