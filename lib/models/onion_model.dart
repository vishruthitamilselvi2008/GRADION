import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum OnionGrade {
  gradeA,
  gradeB,
  gradeC,
}

extension OnionGradeExtension on OnionGrade {
  String get label {
    switch (this) {
      case OnionGrade.gradeA:
        return 'Grade A';
      case OnionGrade.gradeB:
        return 'Grade B';
      case OnionGrade.gradeC:
        return 'Grade C';
    }
  }

  String get shortLabel {
    switch (this) {
      case OnionGrade.gradeA:
        return 'A';
      case OnionGrade.gradeB:
        return 'B';
      case OnionGrade.gradeC:
        return 'C';
    }
  }

  String get commercialName {
    switch (this) {
      case OnionGrade.gradeA:
        return 'Premium Export Quality';
      case OnionGrade.gradeB:
        return 'Standard Commercial Retail';
      case OnionGrade.gradeC:
        return 'Industrial / Processing Only';
    }
  }

  Color get color {
    switch (this) {
      case OnionGrade.gradeA:
        return AppColors.gradeA;
      case OnionGrade.gradeB:
        return AppColors.gradeB;
      case OnionGrade.gradeC:
        return AppColors.gradeC;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case OnionGrade.gradeA:
        return AppColors.gradeABackground;
      case OnionGrade.gradeB:
        return AppColors.gradeBBackground;
      case OnionGrade.gradeC:
        return AppColors.gradeCBackground;
    }
  }

  Color get borderColor {
    switch (this) {
      case OnionGrade.gradeA:
        return AppColors.gradeABorder;
      case OnionGrade.gradeB:
        return AppColors.gradeBBorder;
      case OnionGrade.gradeC:
        return AppColors.gradeCBorder;
    }
  }
}

class OnionDetection {
  final String id;
  final OnionGrade grade;
  final double diameterMm;
  final String shape;
  final String surfaceQuality;
  final String visibleDefects;
  final double confidence;
  final double x; // Relative X coordinate (0.0 to 1.0)
  final double y; // Relative Y coordinate (0.0 to 1.0)
  final double size; // Relative size (0.0 to 1.0)
  final String variety;

  const OnionDetection({
    required this.id,
    required this.grade,
    required this.diameterMm,
    required this.shape,
    required this.surfaceQuality,
    required this.visibleDefects,
    required this.confidence,
    required this.x,
    required this.y,
    required this.size,
    this.variety = 'Nashik Red',
  });

  String get confidencePercent => '${(confidence * 100).toStringAsFixed(1)}%';
  String get diameterFormatted => '${diameterMm.toStringAsFixed(1)} mm';
}
