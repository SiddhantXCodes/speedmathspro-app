import 'dart:math';
import '../question.dart';
import '../random_utils.dart';

class AverageGenerator {
  static Question generate(Random rnd, int min, int max) {
    final nums = List.generate(3, (_) => randInt(rnd, min, max));
    final avg =
        (nums.reduce((a, b) => a + b) / nums.length).toStringAsFixed(2);

    return Question(
      expression: 'Average of ${nums.join(", ")} = ?',
      correctAnswer: avg,
    );
  }
}
