import 'dart:developer';
import 'package:hive/hive.dart';

import '../features/quiz/quiz_repository.dart';

/// 🎯 SyncManager (CLEAN & FINAL)
///
/// Responsibility:
/// • Upload DAILY RANKED QUIZ entry
/// • Retry pending daily leaderboard uploads
/// • NO background sync
/// • NO connectivity listener
class SyncManager {
  // ---------------------------------------------------------------------------
  // Singleton
  // ---------------------------------------------------------------------------
  static final SyncManager _instance = SyncManager._internal();
  factory SyncManager() => _instance;
  SyncManager._internal();

  final QuizRepository _quizRepo = QuizRepository();

  bool _isSyncing = false;

  // ---------------------------------------------------------------------------
  // 🚀 Sync DAILY LEADERBOARD entries
  // ---------------------------------------------------------------------------
  Future<void> syncRankedAttempts() async {
    if (_isSyncing) {
      log("⚙️ Sync already running — skipped");
      return;
    }

    _isSyncing = true;
    log("🚀 Syncing daily leaderboard entries...");

    try {
      await _syncDailyLeaderboardQueue();
      log("✅ Daily leaderboard sync complete");
    } catch (e, st) {
      log("❌ Daily leaderboard sync failed: $e", stackTrace: st);
    } finally {
      _isSyncing = false;
    }
  }

  // ---------------------------------------------------------------------------
  // 📦 Sync ONLY daily_leaderboard items from Hive queue
  // ---------------------------------------------------------------------------
  Future<void> _syncDailyLeaderboardQueue() async {
    if (!Hive.isBoxOpen('sync_queue')) {
      await Hive.openBox<Map>('sync_queue');
    }

    final Box<Map> box = Hive.box<Map>('sync_queue');

    if (box.isEmpty) {
      log("ℹ️ No pending daily leaderboard entries");
      return;
    }

    final keys = box.keys.toList();

    for (final key in keys) {
      final raw = box.get(key);
      if (raw == null) continue;

      final item = Map<String, dynamic>.from(raw);
      final type = item['type'];

      // ✅ ONLY daily_leaderboard
      if (type != 'daily_leaderboard') continue;

      final data = Map<String, dynamic>.from(item['data']);

      try {
        log("📤 Uploading daily leaderboard entry...");
        await _quizRepo.syncDailyLeaderboardEntry(data);

        await box.delete(key);
        log("🧹 Daily leaderboard entry synced & removed");
      } catch (e, st) {
        log("⚠️ Upload failed — will retry later", stackTrace: st);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // 🕓 Manual trigger (called after quiz submit)
  // ---------------------------------------------------------------------------
  Future<void> syncPendingSessions() async {
    await syncRankedAttempts();
  }

  // ---------------------------------------------------------------------------
  // 🛑 No-op (kept for backward compatibility)
  // ---------------------------------------------------------------------------
  void start() {}
  void stop() {}
}
