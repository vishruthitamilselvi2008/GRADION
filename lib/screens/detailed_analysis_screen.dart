import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/onion_model.dart';
import '../widgets/grade_badge.dart';
import '../widgets/onion_visual_painter.dart';

class DetailedAnalysisScreen extends StatefulWidget {
  final List<OnionDetection> onions;
  final String? initialId;

  const DetailedAnalysisScreen({
    super.key,
    required this.onions,
    this.initialId,
  });

  @override
  State<DetailedAnalysisScreen> createState() => _DetailedAnalysisScreenState();
}

class _DetailedAnalysisScreenState extends State<DetailedAnalysisScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    if (widget.initialId != null) {
      final found = widget.onions.indexWhere((o) => o.id == widget.initialId);
      if (found != -1) {
        _currentIndex = found;
      }
    }
  }

  void _previousOnion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _nextOnion() {
    if (_currentIndex < widget.onions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detailed Analysis')),
        body: const Center(child: Text('No onion detections available.')),
      );
    }

    final currentOnion = widget.onions[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detailed Analysis'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: Text(
                '${_currentIndex + 1} of ${widget.onions.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Horizontal quick selector strip of all onions
            Container(
              height: 52,
              color: AppColors.surface,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                itemCount: widget.onions.length,
                itemBuilder: (context, index) {
                  final item = widget.onions[index];
                  final isSelected = index == _currentIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? item.grade.color
                            : item.grade.backgroundColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? item.grade.color
                              : item.grade.borderColor,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          item.id,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : item.grade.color,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Scrollable detailed analysis view
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // High-Tech Onion Caliber Graphic with millimeter lines
                    DetailedOnionDiagram(
                      onion: currentOnion,
                      size: 200,
                    ),

                    const SizedBox(height: 20),

                    // Identification & Grade Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentOnion.id,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textPrimary,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  Text(
                                    currentOnion.variety,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              GradeBadge(
                                grade: currentOnion.grade,
                                isLarge: true,
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 12),

                          // Prompt requirements: Diameter, Shape, Surface Quality, Visible Defects, Confidence
                          _buildDetailRow(
                            icon: Icons.straighten_rounded,
                            label: 'Diameter / Caliber',
                            value: currentOnion.diameterFormatted,
                            highlight: true,
                          ),
                          _buildDetailRow(
                            icon: Icons.bubble_chart_outlined,
                            label: 'Bulb Shape',
                            value: currentOnion.shape,
                          ),
                          _buildDetailRow(
                            icon: Icons.texture_rounded,
                            label: 'Surface Quality',
                            value: currentOnion.surfaceQuality,
                          ),
                          _buildDetailRow(
                            icon: Icons.remove_red_eye_outlined,
                            label: 'Visible Defects',
                            value: currentOnion.visibleDefects,
                            isDefect: currentOnion.visibleDefects != 'None' &&
                                !currentOnion.visibleDefects.contains('None detected'),
                          ),
                          _buildDetailRow(
                            icon: Icons.verified_user_outlined,
                            label: 'AI Model Confidence',
                            value: currentOnion.confidencePercent,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Controls: Previous / Next Buttons (Required by prompt)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: const Border(top: BorderSide(color: AppColors.borderLight)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Previous Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _currentIndex > 0 ? _previousOnion : null,
                      icon: const Icon(Icons.arrow_back_ios_rounded, size: 15),
                      label: const Text('Previous'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Next Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _currentIndex < widget.onions.length - 1
                          ? _nextOnion
                          : null,
                      icon: const Text('Next'),
                      label: const Icon(Icons.arrow_forward_ios_rounded, size: 15),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool highlight = false,
    bool isDefect = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: isDefect ? AppColors.gradeC : AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13,
                fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
                color: isDefect
                    ? AppColors.gradeC
                    : (highlight ? AppColors.primaryDark : AppColors.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
