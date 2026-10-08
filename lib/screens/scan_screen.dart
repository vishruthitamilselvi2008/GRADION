import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../models/onion_model.dart';
import '../widgets/camera_preview_overlay.dart';
import 'analyzing_screen.dart';

class ScanScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const ScanScreen({super.key, this.onBack});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  OnionGrade? _selectedGradeFilter;
  bool _flashOn = false;
  bool _gridOn = true;

  void _startAnalysis() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AnalyzingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
      ),
    );
  }

  void _onUploadPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.photo_library, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text('Image lot selected from gallery. Analyzing...'),
          ],
        ),
        backgroundColor: AppColors.primaryDark,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Future.delayed(const Duration(milliseconds: 600), _startAnalysis);
  }

  void _showOnionQuickDetail(OnionDetection onion) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detection ${onion.id}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: onion.grade.backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: onion.grade.borderColor),
                    ),
                    child: Text(
                      onion.grade.label,
                      style: TextStyle(
                        color: onion.grade.color,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildModalRow('Caliber / Diameter', onion.diameterFormatted),
              _buildModalRow('Bulb Shape', onion.shape),
              _buildModalRow('Surface Integrity', onion.surfaceQuality),
              _buildModalRow('Visible Defects', onion.visibleDefects),
              _buildModalRow('AI Confidence', onion.confidencePercent),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalRow(String title, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          Text(
            val,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Scan Onion Lot'),
        elevation: 0,
        backgroundColor: AppColors.surface,
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
              )
            : null,
        actions: [
          // Flashlight button
          IconButton(
            icon: Icon(
              _flashOn ? Icons.flash_on : Icons.flash_off,
              color: _flashOn ? Colors.amber : AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _flashOn = !_flashOn;
              });
            },
          ),
          // Grid toggle button
          IconButton(
            icon: Icon(
              _gridOn ? Icons.grid_on : Icons.grid_off,
              color: _gridOn ? AppColors.primary : AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _gridOn = !_gridOn;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Scanner instructions & guidance
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryLight.withOpacity(0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Align tray under overhead camera. Ensure bulbs are spaced.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Filter pills for detection overlay
              Row(
                children: [
                  _buildFilterChip('All (12)', null),
                  const SizedBox(width: 6),
                  _buildFilterChip('Grade A (8)', OnionGrade.gradeA),
                  const SizedBox(width: 6),
                  _buildFilterChip('Grade B (3)', OnionGrade.gradeB),
                  const SizedBox(width: 6),
                  _buildFilterChip('Grade C (1)', OnionGrade.gradeC),
                ],
              ),

              const SizedBox(height: 12),

              // Large Camera-Preview Placeholder (Required by prompt)
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CameraPreviewOverlay(
                    detections: MockData.liveScanDetections,
                    isScanning: true,
                    filterGrade: _selectedGradeFilter,
                    onOnionTapped: _showOnionQuickDetail,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Bottom Action Controls: "Capture Lot" & "Upload Image" (Required by prompt)
              Row(
                children: [
                  // Upload Image secondary button
                  Expanded(
                    flex: 2,
                    child: OutlinedButton.icon(
                      onPressed: _onUploadPressed,
                      icon: const Icon(Icons.photo_library_outlined, size: 18),
                      label: const Text('Upload Image'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Capture Lot prominent primary button
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      onPressed: _startAnalysis,
                      icon: const Icon(Icons.camera_alt_rounded, size: 20),
                      label: const Text(
                        'Capture Lot',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 4,
                        shadowColor: AppColors.primaryDark.withOpacity(0.4),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, OnionGrade? grade) {
    final isSelected = _selectedGradeFilter == grade;
    final color = grade?.color ?? AppColors.primaryDark;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGradeFilter = grade;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? color : AppColors.surface,
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
