import 'dart:math';
import 'question.dart';
import 'question_generator.dart';
import 'topic_normalizer.dart';
import 'difficulty.dart'; // ✅ FIXED

class RankedSession {
  final Random _rnd;

  final Set<String> _recentQuestions = {};
  static const int _maxMemory = 20;

  RankedSession(DateTime date)
      : _rnd = Random(QuestionGenerator.rankedSeed(date));

  Question nextQuestion({
    required List<String> topics,
    required int min,
    required int max,
    required int elapsedSeconds,
  }) {
    Question q;
    int guard = 0;

    do {
      final topic = topics[_rnd.nextInt(topics.length)];
      final normalized = TopicNormalizer.normalize(topic);

      final difficulty = _difficultyFromTime(elapsedSeconds);

      q = QuestionGenerator.generateOne(
        rnd: _rnd,
        topic: normalized,
        min: min,
        max: max,
        difficulty: difficulty, // ✅ now matches
      );

      guard++;
      if (guard > 10) break;
    } while (_recentQuestions.contains(_signature(q)));

    _remember(q);
    return q;
  }

  Difficulty _difficultyFromTime(int elapsedSeconds) {
    if (elapsedSeconds < 30) return Difficulty.easy;
    if (elapsedSeconds < 90) return Difficulty.medium;
    return Difficulty.hard;
  }

  String _signature(Question q) => q.expression;

  void _remember(Question q) {
    _recentQuestions.add(_signature(q));

    if (_recentQuestions.length > _maxMemory) {
      _recentQuestions.remove(_recentQuestions.first);
    }
  }
}