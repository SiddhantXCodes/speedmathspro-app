import 'dart:math';
import '../question.dart';
import '../random_utils.dart';

class DataInterpretationGenerator {
  static Question generate(Random rnd, int min, int max) {
    final prev = randInt(rnd, min, max);
    var curr = randInt(rnd, min, max);
    if (curr == prev) curr++;

    final change =
        (((curr - prev) / prev) * 100).toStringAsFixed(1);

    return Question(
      expression: 'From $prev to $curr, change (%) = ?',
      correctAnswer: '$change%',
    );
  }
}
