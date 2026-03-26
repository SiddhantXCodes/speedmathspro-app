import 'dart:math';
import 'question.dart';
import 'topic_normalizer.dart';

import 'generators/basic.dart';
import 'generators/percentage.dart';
import 'generators/average.dart';
import 'generators/power.dart';
import 'generators/root.dart';
import 'generators/trigonometry.dart';
import 'generators/data_interpretation.dart';
import 'difficulty.dart';

class QuestionGenerator {
  static int rankedSeed(DateTime date) {
    return date.year * 10000 + date.month * 100 + date.day;
  }

  static Question generateOne({
    required Random rnd,
    required String topic,
    required int min,
    required int max,
    required Difficulty difficulty,
  }) {
    final t = TopicNormalizer.normalize(topic);

    switch (t) {
      case 'addition':
      case 'subtraction':
      case 'multiplication':
      case 'division':
        return BasicGenerator.generate(
          rnd,
          t,
          min,
          max,
          difficulty: difficulty,
        );

      case 'percentage':
        return PercentageGenerator.generate(rnd, min, max);

      case 'average':
        return AverageGenerator.generate(rnd, min, max);

      case 'square':
      case 'cube':
        return PowerGenerator.generate(rnd, t, min, max);

      case 'square root':
      case 'cube root':
        return RootGenerator.generate(rnd, t, min, max);

      case 'trigonometry':
        return TrigonometryGenerator.generate(rnd);

      case 'data interpretation':
        return DataInterpretationGenerator.generate(rnd, min, max);

      default:
        // ✅ FIXED: added difficulty
        return BasicGenerator.generate(
          rnd,
          'addition',
          min,
          max,
          difficulty: difficulty,
        );
    }
  }
}