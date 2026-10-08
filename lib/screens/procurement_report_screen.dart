import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/lot_model.dart';
import '../models/onion_model.dart';
import '../widgets/grade_badge.dart';
import '../widgets/distribution_bar.dart';

class ProcurementReportScreen extends StatelessWidget {
  final OnionLot lot;

  const ProcurementReportScreen({super.key, required this.lot});

  void _showMockFeedback(BuildContext context, String action) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Text('$action Triggered'),
            ],
          ),
          content: Text(
            'Procurement Certificate for lot ${lot.id} has been prepared successfully for $action.',
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Procurement Report'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    // Official Certificate Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Certificate Banner
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'GRADION AGRI-TECH CERTIFICATE',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Commercial Lot Procurement Sheet',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              // AGMARK Standard Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primarySurface,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: AppColors.primaryLight.withOpacity(0.4),
                                  ),
                                ),
                                child: const Text(
                                  'AGMARK SPEC',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 14),

                          // Prompt Requirement: Lot ID & Date
                          _buildReportRow('Lot ID', lot.id, isBold: true),
                          _buildReportRow('Inspection Date', lot.dateFormatted),
                          _buildReportRow('Procurement Facility', lot.location),
                          _buildReportRow('FPO Supplier', lot.supplier),
                          _buildReportRow('Crop Variety', lot.variety),

                          const SizedBox(height: 14),
                          const Divider(),
                          const SizedBox(height: 14),

                          // Prompt Requirement: Total Onions & Average Size & Overall Grade
                          _buildReportRow(
                            'Total Onions Graded',
                            '${lot.totalOnions} bulbs',
                            isBold: true,
                          ),
                          _buildReportRow(
                            'Average Size (Equatorial)',
                            lot.avgSizeFormatted,
                            isBold: true,
                          ),
                          _buildReportRow(
                            'Estimated Sample Weight',
                            '${lot.estimatedWeightKg} kg',
                          ),

                          const SizedBox(height: 14),
                          const Divider(),
                          const SizedBox(height: 14),

                          // Prompt Requirement: Grade Distribution
                          const Text(
                            'Grade Distribution Breakdown',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          DistributionBar(
                            gradeACount: lot.gradeACount,
                            gradeBCount: lot.gradeBCount,
                            gradeCCount: lot.gradeCCount,
                            totalCount: lot.totalOnions,
                            showLegend: true,
                          ),

                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 14),

                          // Prompt Requirement: Overall Grade
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Overall Lot Assessment',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    'Procurement Status: APPROVED',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.gradeA,
                                    ),
                                  ),
                                ],
                              ),
                              GradeBadge(
                                grade: lot.overallGrade,
                                isLarge: true,
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Commercial Rate Estimation Box
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceMuted,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Recommended Procurement Rate',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Based on Grade A export ratio (72%)',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '₹${lot.recommendedRatePerKg.toStringAsFixed(2)} / kg',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Digital Seal Stamp
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Inspector Signature',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Aswin Kumar (INS-4902)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.gradeA,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'SEALED & VERIFIED',
                                  style: TextStyle(
                                    color: AppColors.gradeA,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Buttons: "Export Report" & "Share Report" (Required by prompt)
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
                  // Export Report Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showMockFeedback(context, 'Export PDF Report'),
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: const Text('Export Report'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Share Report Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showMockFeedback(context, 'Share Procurement Report'),
                      icon: const Icon(Icons.share_rounded, size: 18),
                      label: const Text('Share Report'),
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

  Widget _buildReportRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              color: isBold ? AppColors.textPrimary : AppColors.textPrimary,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
