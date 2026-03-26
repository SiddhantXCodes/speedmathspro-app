import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/hive_service.dart';
import '../../models/daily_score.dart';

/// 🎯 QuizRepository
///
/// Architecture:
/// • Practice & Mixed → Local (Hive) only
/// • Daily Ranked → Local first + single Firebase write
/// • Firebase uses ONLY:
///   daily_leaderboard/{yyyy-MM-dd}/entries/{deviceId}
class QuizRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ===========================================================================
  // 🟦 PRACTICE QUIZ → LOCAL ONLY
  // ===========================================================================
  Future<void> savePracticeScore(int score, int timeTakenSeconds) async {
    try {
      await HiveService.savePracticeScore(
        DailyScore(
          date: DateTime.now(),
          score: score,
          totalQuestions: score,
          timeTakenSeconds: timeTakenSeconds,
          isRanked: false,
        ),
      );
      dev.log("📘 Practice score saved");
    } catch (e, st) {
      dev.log("❌ Practice save failed: $e", stackTrace: st);
    }
  }

  // ===========================================================================
  // 🟨 MIXED QUIZ → LOCAL ONLY
  // ===========================================================================
  Future<void> saveMixedScore(int score, int timeTakenSeconds) async {
    try {
      await HiveService.saveMixedScore(
        DailyScore(
          date: DateTime.now(),
          score: score,
          totalQuestions: score,
          timeTakenSeconds: timeTakenSeconds,
          isRanked: false,
        ),
      );
      dev.log("📙 Mixed score saved");
    } catch (e, st) {
      dev.log("❌ Mixed save failed: $e", stackTrace: st);
    }
  }

  // ===========================================================================
  // 🟥 DAILY RANKED QUIZ → LOCAL FIRST
  // ===========================================================================
  Future<void> saveRankedScore({
    required String username,
    required String deviceId,
    required int score,
    required int timeTakenSeconds,
  }) async {
    final now = DateTime.now();
    final dateKey = _todayKey(now);

    // 1️⃣ Save locally (SOURCE OF TRUTH)
    await HiveService.saveRankedScore(
      DailyScore(
        date: now,
        score: score,
        totalQuestions: score,
        timeTakenSeconds: timeTakenSeconds,
        isRanked: true,
      ),
    );

    // 2️⃣ Queue Firebase upload
    await HiveService.queueForSync("daily_leaderboard", {
      "dateKey": dateKey,
      "deviceId": deviceId,
      "username": username,
      "score": score,
      "timeTaken": timeTakenSeconds,
    });

    dev.log("🔥 Daily ranked score saved & queued ($dateKey)");
  }

  // ===========================================================================
  // 🔄 SYNC DAILY LEADERBOARD ENTRY (CALLED BY SyncManager)
  // ===========================================================================
  Future<void> syncDailyLeaderboardEntry(
    Map<String, dynamic> data,
  ) async {
    try {
      final String dateKey = data["dateKey"];
      final String deviceId = data["deviceId"];

      final ref = _firestore
          .collection("daily_leaderboard")
          .doc(dateKey)
          .collection("entries")
          .doc(deviceId);

      await ref.set({
        "deviceId": deviceId,
        "username": data["username"],
        "score": data["score"],
        "timeTaken": data["timeTaken"],
        "timestamp": FieldValue.serverTimestamp(),
      });

      dev.log("🏆 Daily leaderboard entry synced ($dateKey)");
    } catch (e, st) {
      dev.log("❌ Daily leaderboard sync failed: $e", stackTrace: st);
      rethrow;
    }
  }

  // ===========================================================================
  // 🟦 DAILY LEADERBOARD STREAM
  // ===========================================================================
  Stream<QuerySnapshot<Map<String, dynamic>>> getDailyLeaderboard() {
    final dateKey = _todayKey(DateTime.now());

    return _firestore
        .collection("daily_leaderboard")
        .doc(dateKey)
        .collection("entries")
        .orderBy("score", descending: true)
        .orderBy("timeTaken")
        .snapshots();
  }

  // ===========================================================================
  // 🧠 LOCAL CHECK — HAS USER PLAYED TODAY?
  // ===========================================================================
  Future<bool> hasPlayedTodayLocal() async {
    return HiveService.hasRankedAttemptToday();
  }

  // ===========================================================================
  // 🔑 UTIL
  // ===========================================================================
  String _todayKey(DateTime now) {
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }
}
