import 'dart:math';

import 'question.dart';
import 'ranked_session.dart';
import 'question_generator.dart';
import 'difficulty.dart'; // ✅ REQUIRED

/// ✅ Usecase-level enum (DO NOT use UI QuizMode here)
enum QuestionFlowMode { practice, ranked }

class GenerateQuestionsUseCase {
  RankedSession? _rankedSession;

  // ------------------------------------------------------------
  // RANKED LIFECYCLE
  // ------------------------------------------------------------
  void startRanked(DateTime date) {
    _rankedSession = RankedSession(date);
  }

  void endRanked() {
    _rankedSession = null;
  }

  // ------------------------------------------------------------
  // QUESTION FETCH
  // ------------------------------------------------------------
  Question next({
    required QuestionFlowMode mode,
    required List<String> topics,
    required int min,
    required int max,

    /// ⬅️ REQUIRED ONLY FOR RANKED
    int elapsedSeconds = 0,
  }) {
    // -------------------------------
    // PRACTICE (free, non-deterministic)
    // -------------------------------
    if (mode == QuestionFlowMode.practice) {
      return QuestionGenerator.generateOne(
        rnd: Random(),
        topic: topics.first,
        min: min,
        max: max,
        difficulty: Difficulty.medium, // ✅ FIXED
      );
    }

    // -------------------------------
    // RANKED (deterministic, strict)
    // -------------------------------
    if (_rankedSession == null) {
      throw StateError(
        "Ranked session not started. Call startRanked() first.",
      );
    }

    return _rankedSession!.nextQuestion(
      topics: topics,
      min: min,
      max: max,
      elapsedSeconds: elapsedSeconds,
    );
  }
}