//lib/features/home/widgets/master_basics_section.dart
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import 'practice_bottom_sheet.dart';

/// 🧮 Master Basics Section — Topic-based offline practice grid
class MasterBasicsSection extends StatelessWidget {
  const MasterBasicsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final basics = [
      {'type': 'text', 'symbol': '+', 'title': 'Addition'},
      {'type': 'text', 'symbol': '−', 'title': 'Subtraction'},
      {'type': 'text', 'symbol': '×', 'title': 'Multiplication'},
      {'type': 'text', 'symbol': '÷', 'title': 'Division'},
      {'type': 'icon', 'icon': Icons.percent, 'title': 'Percentage'},
      {'type': 'text', 'symbol': 'x̄', 'title': 'Average'},
      {'type': 'text', 'symbol': 'x²', 'title': 'Square'},
      {'type': 'text', 'symbol': 'x³', 'title': 'Cube'},
      {'type': 'text', 'symbol': '√x', 'title': 'Square Root'},
      {'type': 'text', 'symbol': '∛x', 'title': 'Cube Root'},
      {'type': 'table', 'title': 'Tables'},
      {'type': 'icon', 'icon': Icons.insights, 'title': 'Data Interpretation'},
    ];

    final textColor = AppTheme.adaptiveText(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Master Basics',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: basics.map((item) {
            return _topicTile(context, item);
          }).toList(),
        ),
      ],
    );
  }

  Widget _topicTile(BuildContext context, Map<String, dynamic> item) {
    final textColor = AppTheme.adaptiveText(context);
    final accent = AppTheme.adaptiveAccent(context);
    final theme = Theme.of(context);
    final title = item['title'] as String;

    return InkWell(
      onTap: () => showPracticeBottomSheet(context, topic: title),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.dividerColor.withOpacity(0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (item['type'] == 'icon')
              Icon(item['icon'] as IconData, size: 28, color: accent)
            else if (item['type'] == 'text')
              Text(
                item['symbol'] as String,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: accent,
                  height: 1.0,
                ),
              )
            else if (item['type'] == 'table')
              Column(
                children: [
                  Text(
                    '2×2=4',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: accent,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    '3×3=9',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: accent,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textColor,
                fontSize: 13.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
