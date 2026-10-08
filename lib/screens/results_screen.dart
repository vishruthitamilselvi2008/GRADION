import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/lot_model.dart';
import '../models/onion_model.dart';
import '../widgets/grade_badge.dart';
import '../widgets/distribution_bar.dart';
import '../widgets/camera_preview_overlay.dart';
import 'detailed_analysis_screen.dart';
import 'procurement_report_screen.dart';

class ResultsScreen extends StatefulWidget {
  final OnionLot lot;

  const ResultsScreen({super.key, required this.lot});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  OnionGrade? _activePreviewFilter;

  @override
  Widget build(BuildContext context) {
    final lot = widget.lot;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Lot Results • ${lot.id}'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Lot report ${lot.id} ready to share'),
                  backgroundColor: AppColors.primaryDark,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Overall Grade Banner Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      lot.overallGrade.backgroundColor,
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: lot.overallGrade.borderColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: lot.overallGrade.color.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Big Grade Badge Icon
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: lot.overallGrade.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: lot.overallGrade.color.withOpacity(0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          lot.overallGrade.shortLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'OVERALL: ${lot.overallGrade.label.toUpperCase()}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: lot.overallGrade.color,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: lot.overallGrade.color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Score 88/100',
                                  style: TextStyle(
                                    color: lot.overallGrade.color,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lot.overallGrade.commercialName,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${lot.variety} • ${lot.dateFormatted}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 2. Primary Summary Metrics (Prompt requirements: 68 onions analyzed, Grade A 49, Grade B 14, Grade C 5, Avg 68mm)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    // Main Highlight: 68 onions analyzed & Average size 68 mm
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricTile(
                            'Total Analyzed',
                            '${lot.totalOnions}',
                            'onions in lot',
                            Icons.grid_view_rounded,
                            AppColors.primary,
                          ),
                        ),
                        Container(width: 1, height: 48, color: AppColors.borderLight),
                        Expanded(
                          child: _buildMetricTile(
                            'Average Size',
                            '${lot.averageSizeMm.toInt()} mm',
                            'Jumbo commercial caliber',
                            Icons.straighten_rounded,
                            AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(),
                    ),
                    // Specific Grade Counts: Grade A — 49, Grade B — 14, Grade C — 5
                    Row(
                      children: [
                        Expanded(
                          child: _buildGradeCountItem(
                            'Grade A',
                            '${lot.gradeACount}',
                            '(${lot.gradeAPercentFormatted})',
                            AppColors.gradeA,
                            AppColors.gradeABackground,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildGradeCountItem(
                            'Grade B',
                            '${lot.gradeBCount}',
                            '(${lot.gradeBPercentFormatted})',
                            AppColors.gradeB,
                            AppColors.gradeBBackground,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildGradeCountItem(
                            'Grade C',
                            '${lot.gradeCCount}',
                            '(${lot.gradeCPercentFormatted})',
                            AppColors.gradeC,
                            AppColors.gradeCBackground,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 3. Grade Distribution Visualization (Required by prompt)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Grade Distribution',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DistributionBar(
                      gradeACount: lot.gradeACount,
                      gradeBCount: lot.gradeBCount,
                      gradeCCount: lot.gradeCCount,
                      totalCount: lot.totalOnions,
                      showLegend: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 4. Quality Indicators (Required by prompt)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quality Indicators',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildQualityBar(
                      'Size Uniformity Index',
                      '${lot.uniformityIndex.toStringAsFixed(1)}%',
                      lot.uniformityIndex / 100,
                      AppColors.gradeA,
                    ),
                    const SizedBox(height: 10),
                    _buildQualityBar(
                      'Outer Skin Tunic Integrity',
                      '${lot.skinIntegrity.toStringAsFixed(1)}%',
                      lot.skinIntegrity / 100,
                      AppColors.primary,
                    ),
                    const SizedBox(height: 10),
                    _buildQualityBar(
                      'Neck Tightness Score',
                      '${lot.neckTightness.toStringAsFixed(1)}%',
                      lot.neckTightness / 100,
                      AppColors.gradeA,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Moisture Level',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            lot.moistureLevel,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 5. Scanned-Image Preview with Color-Coded Onion Detections (Required by prompt)
              Container(
                padding: const EdgeInsets.all(16),
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
                        const Text(
                          'Scanned Lot Preview',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Color-Coded Detections',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryLight.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Filter Chips to highlight Grade A / B / C
                    Row(
                      children: [
                        _buildPreviewFilterChip('All (${lot.detections.length})', null),
                        const SizedBox(width: 6),
                        _buildPreviewFilterChip('Grade A', OnionGrade.gradeA),
                        const SizedBox(width: 6),
                        _buildPreviewFilterChip('Grade B', OnionGrade.gradeB),
                        const SizedBox(width: 6),
                        _buildPreviewFilterChip('Grade C', OnionGrade.gradeC),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // High-tech scanned tray map
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: SizedBox(
                        height: 240,
                        width: double.infinity,
                        child: CameraPreviewOverlay(
                          detections: lot.detections,
                          isScanning: false,
                          filterGrade: _activePreviewFilter,
                          onOnionTapped: (onion) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DetailedAnalysisScreen(
                                  onions: lot.detections,
                                  initialId: onion.id,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Tap any bounding box to inspect individual onion specs',
                        style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 6. Navigation Action Buttons: "Detailed Analysis" & "Procurement Report"
              Row(
                children: [
                  // Detailed Analysis Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailedAnalysisScreen(
                              onions: lot.detections,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.analytics_outlined, size: 18),
                      label: const Text('Detailed Analysis'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Procurement Report Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProcurementReportScreen(
                              lot: lot,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.description_outlined, size: 18),
                      label: const Text('Procurement Report'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile(
    String label,
    String value,
    String sublabel,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            sublabel,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeCountItem(
    String label,
    String count,
    String pct,
    Color color,
    Color bg,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          Text(
            pct,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityBar(String label, String value, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: AppColors.surfaceMuted,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewFilterChip(String label, OnionGrade? grade) {
    final isSelected = _activePreviewFilter == grade;
    final color = grade?.color ?? AppColors.primaryDark;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activePreviewFilter = grade;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? color : AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? color : AppColors.border,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
