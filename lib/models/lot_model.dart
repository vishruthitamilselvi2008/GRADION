import 'onion_model.dart';

class OnionLot {
  final String id;
  final String dateFormatted;
  final int totalOnions;
  final int gradeACount;
  final int gradeBCount;
  final int gradeCCount;
  final double averageSizeMm;
  final OnionGrade overallGrade;
  final String variety;
  final String supplier;
  final String location;
  final double uniformityIndex;
  final double skinIntegrity;
  final double neckTightness;
  final String moistureLevel;
  final double estimatedWeightKg;
  final double recommendedRatePerKg;
  final List<OnionDetection> detections;

  const OnionLot({
    required this.id,
    required this.dateFormatted,
    required this.totalOnions,
    required this.gradeACount,
    required this.gradeBCount,
    required this.gradeCCount,
    required this.averageSizeMm,
    required this.overallGrade,
    this.variety = 'Nashik Red',
    this.supplier = 'Nashik Agri Producer FPO #4',
    this.location = 'Lasalgaon Mandi Yard 2',
    this.uniformityIndex = 92.4,
    this.skinIntegrity = 89.2,
    this.neckTightness = 94.0,
    this.moistureLevel = 'Optimal (12.2%)',
    this.estimatedWeightKg = 95.2,
    this.recommendedRatePerKg = 28.50,
    this.detections = const [],
  });

  double get gradeAPercentage =>
      totalOnions == 0 ? 0 : (gradeACount / totalOnions) * 100;
  double get gradeBPercentage =>
      totalOnions == 0 ? 0 : (gradeBCount / totalOnions) * 100;
  double get gradeCPercentage =>
      totalOnions == 0 ? 0 : (gradeCCount / totalOnions) * 100;

  String get gradeAPercentFormatted => '${gradeAPercentage.toStringAsFixed(0)}%';
  String get gradeBPercentFormatted => '${gradeBPercentage.toStringAsFixed(0)}%';
  String get gradeCPercentFormatted => '${gradeCPercentage.toStringAsFixed(0)}%';
  String get avgSizeFormatted => '${averageSizeMm.toStringAsFixed(0)} mm';
}
