import 'dart:math';
import '../question.dart';
import '../random_utils.dart';

class TrigonometryGenerator {
  static Question generate(Random rnd) {
    const funcs = ['sin', 'cos', 'tan'];
    const angles = [0, 30, 45, 60, 90];

    const values = {
      'sin': ['0', '0.5', '0.707', '0.866', '1'],
      'cos': ['1', '0.866', '0.707', '0.5', '0'],
      'tan': ['0', '0.577', '1', '1.732', '∞'],
    };

    final f = choice(rnd, funcs);
    final idx = randInt(rnd, 0, angles.length - 1);

    return Question(
      expression: '$f(${angles[idx]}°) = ?',
      correctAnswer: values[f]![idx],
    );
  }
}
