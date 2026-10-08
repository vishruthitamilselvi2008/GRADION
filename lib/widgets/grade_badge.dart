import 'package:flutter/material.dart';
import '../models/onion_model.dart';

class GradeBadge extends StatelessWidget {
  final OnionGrade grade;
  final bool showShort;
  final bool isLarge;

  const GradeBadge({
    super.key,
    required this.grade,
    this.showShort = false,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = grade.color;
    final bgColor = grade.backgroundColor;
    final borderColor = grade.borderColor;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 14 : 10,
        vertical: isLarge ? 8 : 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(isLarge ? 12 : 8),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isLarge ? 10 : 8,
            height: isLarge ? 10 : 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: isLarge ? 8 : 6),
          Text(
            showShort ? grade.shortLabel : grade.label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: isLarge ? 15 : 12,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
