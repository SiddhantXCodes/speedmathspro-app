import 'dart:math';
import '../question.dart';
import '../random_utils.dart';
import '../difficulty.dart';

class BasicGenerator {
  static Question generate(
    Random rnd,
    String op,
    int min,
    int max, {
    required Difficulty difficulty,
  }) {
    // 🎯 Adjust range based on difficulty
    int adjustedMin = min;
    int adjustedMax = max;

    switch (difficulty) {
      case Difficulty.easy:
        adjustedMax = (min + max) ~/ 2;
        break;

      case Difficulty.medium:
        // full range
        break;

      case Difficulty.hard:
        adjustedMin = (min + max) ~/ 2;
        break;
    }

    int a = randInt(rnd, adjustedMin, adjustedMax);
    int b = randInt(rnd, adjustedMin, adjustedMax);

    switch (op) {
      case 'addition':
        return Question(
          expression: '$a + $b = ?',
          correctAnswer: '${a + b}',
        );

      case 'subtraction':
        // ensure non-negative result for easier UX
        if (b > a) {
          final temp = a;
          a = b;
          b = temp;
        }
        return Question(
          expression: '$a - $b = ?',
          correctAnswer: '${a - b}',
        );

      case 'multiplication':
        return Question(
          expression: '$a × $b = ?',
          correctAnswer: '${a * b}',
        );

      case 'division':
        // avoid division by zero
        b = b == 0 ? 1 : b;

        // make division cleaner (optional but better UX)
        a = a * b;

        return Question(
          expression: '$a ÷ $b = ?',
          correctAnswer: '${a ~/ b}',
        );

      default:
        return Question(
          expression: '$a + $b = ?',
          correctAnswer: '${a + b}',
        );
    }
  }
}