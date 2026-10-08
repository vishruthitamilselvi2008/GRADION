import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DistributionBar extends StatelessWidget {
  final int gradeACount;
  final int gradeBCount;
  final int gradeCCount;
  final int totalCount;
  final bool showLegend;

  const DistributionBar({
    super.key,
    required this.gradeACount,
    required this.gradeBCount,
    required this.gradeCCount,
    required this.totalCount,
    this.showLegend = true,
  });

  @override
  Widget build(BuildContext context) {
    final double safeTotal = totalCount > 0 ? totalCount.toDouble() : 1.0;
    final double pctA = (gradeACount / safeTotal) * 100;
    final double pctB = (gradeBCount / safeTotal) * 100;
    final double pctC = (gradeCCount / safeTotal) * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Multi-segment horizontal bar
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 16,
            width: double.infinity,
            color: AppColors.surfaceMuted,
            child: Row(
              children: [
                if (gradeACount > 0)
                  Expanded(
                    flex: gradeACount,
                    child: Container(
                      color: AppColors.gradeA,
                    ),
                  ),
                if (gradeBCount > 0)
                  Expanded(
                    flex: gradeBCount,
                    child: Container(
                      color: AppColors.gradeB,
                    ),
                  ),
                if (gradeCCount > 0)
                  Expanded(
                    flex: gradeCCount,
                    child: Container(
                      color: AppColors.gradeC,
                    ),
                  ),
              ],
            ),
          ),
        ),

        if (showLegend) ...[
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildLegendItem(
                  'Grade A',
                  '$gradeACount (${pctA.toStringAsFixed(0)}%)',
                  AppColors.gradeA,
                  AppColors.gradeABackground,
                  AppColors.gradeABorder,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildLegendItem(
                  'Grade B',
                  '$gradeBCount (${pctB.toStringAsFixed(0)}%)',
                  AppColors.gradeB,
                  AppColors.gradeBBackground,
                  AppColors.gradeBBorder,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildLegendItem(
                  'Grade C',
                  '$gradeCCount (${pctC.toStringAsFixed(0)}%)',
                  AppColors.gradeC,
                  AppColors.gradeCBackground,
                  AppColors.gradeCBorder,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildLegendItem(
    String label,
    String value,
    Color color,
    Color bg,
    Color border,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
