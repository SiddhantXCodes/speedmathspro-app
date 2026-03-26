import 'dart:developer';

import '../../services/hive_service.dart';
import '../../models/practice_log.dart';
import '../../models/question_history.dart';

/// 🧠 PracticeRepository — OFFLINE ONLY
///
/// Responsibilities:
/// • Save practice sessions to Hive
/// • Fetch local practice sessions
/// • Provide question history
/// • Provide activity map for heatmap
///
/// ❌ No Firebase
/// ❌ No sync queue
/// ❌ No auth dependency
class PracticeRepository {
  /// ----------------------------------------------------------
  /// 💾 Save a Practice Session (Hive only)
  /// ----------------------------------------------------------
  Future<void> savePracticeSession(PracticeLog entry) async {
    try {
      await HiveService.addPracticeLog(entry);
      log("🧩 Practice saved locally: ${entry.topic}");
    } catch (e, st) {
      log("⚠️ Failed to save practice session: $e", stackTrace: st);
    }
  }

  /// ----------------------------------------------------------
  /// 🧾 Get All Practice Sessions (Models)
  /// ----------------------------------------------------------
  List<PracticeLog> getAllLocalSessions() {
    try {
      return HiveService.getPracticeLogs();
    } catch (e, st) {
      log("⚠️ getAllLocalSessions error: $e", stackTrace: st);
      return [];
    }
  }

  /// ----------------------------------------------------------
  /// 🧾 Get All Practice Sessions (Maps)
  /// (Used by older UI code — safe adapter)
  /// ----------------------------------------------------------
  List<Map<String, dynamic>> getAllSessions() {
    try {
      return HiveService.getPracticeLogs()
          .map((e) => e.toMap())
          .toList();
    } catch (e, st) {
      log("⚠️ getAllSessions error: $e", stackTrace: st);
      return [];
    }
  }

  /// ----------------------------------------------------------
  /// 📜 Question History (Offline)
  /// ----------------------------------------------------------
  List<QuestionHistory> getQuestionHistory() {
    try {
      return HiveService.getHistory();
    } catch (e, st) {
      log("⚠️ Failed to get question history: $e", stackTrace: st);
      return [];
    }
  }

  /// ----------------------------------------------------------
  /// 🗓️ Heatmap Activity (Offline)
  /// ----------------------------------------------------------
  Map<DateTime, int> getActivityMapFromHive() {
    try {
      return HiveService.getActivityMap();
    } catch (e, st) {
      log("⚠️ Failed to load activity map: $e", stackTrace: st);
      return {};
    }
  }

  /// ----------------------------------------------------------
  /// 🧹 Clear Local Practice Data
  /// ----------------------------------------------------------
  Future<void> clearAllLocalData() async {
    try {
      await HiveService.clearPracticeLogs();
      log("🧹 All local practice logs cleared");
    } catch (e, st) {
      log("⚠️ clearAllLocalData error: $e", stackTrace: st);
    }
  }
}
