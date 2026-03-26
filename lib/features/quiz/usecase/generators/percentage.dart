import 'dart:math';
import '../question.dart';
import '../random_utils.dart';

class PercentageGenerator {
  static Question generate(Random rnd, int min, int max) {
    final base = randInt(rnd, min, max);
    final percent = randInt(rnd, 5, 95);
    final result = (base * percent / 100).toStringAsFixed(2);

    return Question(
      expression: '$percent% of $base = ?',
      correctAnswer: result,
    );
  }
}
