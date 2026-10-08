import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../models/lot_model.dart';
import '../models/onion_model.dart';
import '../widgets/grade_badge.dart';
import 'results_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _searchQuery = '';
  OnionGrade? _gradeFilter;

  @override
  Widget build(BuildContext context) {
    final filteredLots = MockData.lotHistory.where((lot) {
      final matchesQuery = _searchQuery.isEmpty ||
          lot.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          lot.variety.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          lot.supplier.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesGrade = _gradeFilter == null || lot.overallGrade == _gradeFilter;

      return matchesQuery && matchesGrade;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Inspection History'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar & Filter Options
            Container(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
              color: AppColors.surface,
              child: Column(
                children: [
                  // Search Input Field
                  TextField(
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search by Lot ID, variety, supplier...',
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                      prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textMuted),
                      filled: true,
                      fillColor: AppColors.surfaceMuted,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Filter Chips (All, Grade A, Grade B, Grade C)
                  Row(
                    children: [
                      _buildFilterChip('All Lots', null),
                      const SizedBox(width: 8),
                      _buildFilterChip('Grade A', OnionGrade.gradeA),
                      const SizedBox(width: 8),
                      _buildFilterChip('Grade B', OnionGrade.gradeB),
                      const SizedBox(width: 8),
                      _buildFilterChip('Grade C', OnionGrade.gradeC),
                    ],
                  ),
                ],
              ),
            ),

            // History Lots List
            Expanded(
              child: filteredLots.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 48, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          const Text(
                            'No matching lots found',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Try adjusting your search or filter criteria',
                            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(18),
                      itemCount: filteredLots.length,
                      itemBuilder: (context, index) {
                        final lot = filteredLots[index];
                        return _buildLotHistoryCard(context, lot);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, OnionGrade? grade) {
    final isSelected = _gradeFilter == grade;
    final color = grade?.color ?? AppColors.primaryDark;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _gradeFilter = grade;
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
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLotHistoryCard(BuildContext context, OnionLot lot) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Lot ID and Grade Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    lot.id,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              GradeBadge(grade: lot.overallGrade),
            ],
          ),

          const SizedBox(height: 10),

          // Middle info: Variety & Date
          Text(
            '${lot.variety} • ${lot.supplier}',
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 10),

          // Bottom Info & "Details" Button (Required by prompt: Lot ID, Date, Onion count, Grade, Details button)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${lot.totalOnions} onions (${lot.avgSizeFormatted} avg)',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lot.dateFormatted,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              // Details Button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ResultsScreen(lot: lot),
                    ),
                  );
                },
                icon: const Icon(Icons.visibility_outlined, size: 15),
                label: const Text('Details'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primarySurface,
                  foregroundColor: AppColors.primaryDark,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
