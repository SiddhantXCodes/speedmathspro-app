import 'dart:math';
import '../question.dart';
import '../random_utils.dart';

class PowerGenerator {
  static Question generate(Random rnd, String type, int min, int max) {
    final n = randInt(rnd, min, max);

    if (type == 'square') {
      return Question(
        expression: '$n² = ?',
        correctAnswer: '${n * n}',
      );
    }

    // cube
    return Question(
      expression: '$n³ = ?',
      correctAnswer: '${n * n * n}',
    );
  }
}
