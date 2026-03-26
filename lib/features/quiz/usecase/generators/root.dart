import 'dart:math';
import '../question.dart';
import '../random_utils.dart';

class RootGenerator {
  static Question generate(Random rnd, String type, int min, int max) {
    final x = randInt(rnd, min, max);

    if (type == 'square root') {
      return Question(
        expression: '√$x ≈ ?',
        correctAnswer: sqrt(x).toStringAsFixed(2),
      );
    }

    // cube root
    return Question(
      expression: '∛$x ≈ ?',
      correctAnswer: pow(x, 1 / 3).toStringAsFixed(2),
    );
  }
}
