// lib/features/quiz/widgets/quiz_options.dart
import 'package:flutter/material.dart';

class QuizOptions extends StatelessWidget {
  final List<String> options;
  final Color primary;
  final Function(String) onSelect;

  const QuizOptions({
    super.key,
    required this.options,
    required this.primary,
    required this.onSelect,
  });

  // 🔧 FIX: remove trailing .0 for whole numbers
  String _formatOption(String value) {
    final n = num.tryParse(value);
    if (n != null && n % 1 == 0) {
      return n.toInt().toString();
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 3,
      physics: const NeverScrollableScrollPhysics(),
      children: options
          .map(
            (opt) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => onSelect(opt), // unchanged
              child: Text(
                _formatOption(opt), // display-only fix
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
