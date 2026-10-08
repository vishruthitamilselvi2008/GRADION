import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../widgets/onion_visual_painter.dart';
import 'results_screen.dart';

class AnalyzingScreen extends StatefulWidget {
  const AnalyzingScreen({super.key});

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  int _currentStep = 0;
  Timer? _stepTimer;
  Timer? _completionTimer;

  final List<Map<String, String>> _analysisSteps = [
    {
      'title': 'Detecting onions',
      'detail': 'Localizing individual bulbs and spatial layout...',
      'result': '68 onions detected',
    },
    {
      'title': 'Measuring size',
      'detail': 'Computing equatorial caliber and sphericity...',
      'result': 'Average diameter: 68 mm',
    },
    {
      'title': 'Checking appearance',
      'detail': 'Scanning tunic scales, skin color, and blemishes...',
      'result': 'Uniformity: 92.4% • Integrity: 89%',
    },
    {
      'title': 'Assigning grade',
      'detail': 'Classifying according to AGMARK/Codex thresholds...',
      'result': 'Batch Grade: GRADE A',
    },
  ];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..forward();

    // Step 0 -> Step 1 -> Step 2 -> Step 3 progression
    _stepTimer = Timer.periodic(const Duration(milliseconds: 750), (timer) {
      if (mounted) {
        setState(() {
          if (_currentStep < _analysisSteps.length - 1) {
            _currentStep++;
          }
        });
      }
    });

    // Auto transition to Results screen after animation finishes
    _completionTimer = Timer(const Duration(milliseconds: 3600), () {
      if (mounted) {
        _navigateToResults();
      }
    });
  }

  void _navigateToResults() {
    _stepTimer?.cancel();
    _completionTimer?.cancel();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) =>
            ResultsScreen(lot: MockData.currentLot),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    _completionTimer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Analyzing Onion Lot'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Animated central radar inspection graphic
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer pulsating ring
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                      );
                    },
                  ),

                  // Progress circular spinner
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: _progressController.value,
                          strokeWidth: 4,
                          backgroundColor: AppColors.border,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.gradeA,
                          ),
                        ),
                      );
                    },
                  ),

                  // Central Onion Emblem
                  const SizedBox(
                    width: 70,
                    height: 70,
                    child: CustomPaint(
                      painter: OnionBulbPainter(isRedOnion: true),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Progress percentage text
              AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  final pct = (_progressController.value * 100).toInt();
                  return Column(
                    children: [
                      Text(
                        '$pct%',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryDark,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pct < 100
                            ? 'Processing computer vision models...'
                            : 'Grading complete! Finalizing lot sheet...',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 32),

              // Step-by-step pipeline cards (Detecting, Measuring, Checking, Assigning)
              Expanded(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _analysisSteps.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final step = _analysisSteps[index];
                    final bool isFinished = index <= _currentStep;
                    final bool isCurrent = index == _currentStep;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isFinished
                            ? (isCurrent
                                ? AppColors.primarySurface
                                : AppColors.surface)
                            : AppColors.surfaceMuted.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isCurrent
                              ? AppColors.primary
                              : (isFinished ? AppColors.gradeABorder : AppColors.border),
                          width: isCurrent ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Status indicator icon
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isFinished
                                  ? (isCurrent
                                      ? AppColors.primary
                                      : AppColors.gradeA)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isFinished
                                    ? Colors.transparent
                                    : AppColors.textMuted.withOpacity(0.4),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: isFinished
                                  ? const Icon(
                                      Icons.check,
                                      size: 18,
                                      color: Colors.white,
                                    )
                                  : Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Step text & details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step['title']!,
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    color: isFinished
                                        ? AppColors.textPrimary
                                        : AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  isFinished ? step['result']! : step['detail']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isFinished
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isFinished
                                        ? AppColors.textSecondary
                                        : AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isCurrent && _progressController.value < 0.95)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Skip / View Results Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _navigateToResults,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('View Results'),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
