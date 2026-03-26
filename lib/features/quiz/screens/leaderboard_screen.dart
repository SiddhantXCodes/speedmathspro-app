// lib/features/quiz/screens/leaderboard_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../../theme/app_theme.dart';
import '../../../providers/local_user_provider.dart';
import '../quiz_repository.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final QuizRepository _quizRepo = QuizRepository();

  String selectedTab = "daily";

  int? myDailyRank;
  int? myWeeklyRank;

  Map<String, dynamic>? myDailyData;
  Map<String, dynamic>? myWeeklyData;

  String get todayKey {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDailyRank();
      _fetchWeeklyRank();
    });
  }

  // -----------------------------------------------------------
  // DAILY RANK
  // -----------------------------------------------------------
  Future<void> _fetchDailyRank() async {
    final deviceId = context.read<LocalUserProvider>().deviceId;
    if (deviceId == null) return;

    final snap = await FirebaseFirestore.instance
        .collection("daily_leaderboard")
        .doc(todayKey)
        .collection("entries")
        .orderBy("score", descending: true)
        .orderBy("timeTaken")
        .get();

    int rank = 1;
    myDailyRank = null;
    myDailyData = null;

    for (final doc in snap.docs) {
      final data = doc.data();
      if (data["deviceId"] == deviceId) {
        myDailyRank = rank;
        myDailyData = data;
        break;
      }
      rank++;
    }

    if (mounted) setState(() {});
  }

  // -----------------------------------------------------------
  // WEEKLY RANK
  // -----------------------------------------------------------
  Future<void> _fetchWeeklyRank() async {
    final deviceId = context.read<LocalUserProvider>().deviceId;
    if (deviceId == null) return;

    final list = await _fetchWeeklyLeaderboardList();

    int rank = 1;
    myWeeklyRank = null;
    myWeeklyData = null;

    for (final entry in list) {
      if (entry["deviceId"] == deviceId) {
        myWeeklyRank = rank;
        myWeeklyData = entry;
        break;
      }
      rank++;
    }

    if (mounted) setState(() {});
  }

  // -----------------------------------------------------------
  // WEEKLY LIST
  // -----------------------------------------------------------
  Future<List<Map<String, dynamic>>> _fetchWeeklyLeaderboardList() async {
    final now = DateTime.now();
    final days = List.generate(7, (i) => now.subtract(Duration(days: i)));

    final Map<String, Map<String, dynamic>> bestByDevice = {};

    for (final d in days) {
      final key =
          "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

      final snap = await FirebaseFirestore.instance
          .collection("daily_leaderboard")
          .doc(key)
          .collection("entries")
          .get();

      for (final doc in snap.docs) {
        final data = doc.data();
        final id = data["deviceId"];
        final score = data["score"] ?? 0;
        final time = data["timeTaken"] ?? 9999;

        if (!bestByDevice.containsKey(id) ||
            score > bestByDevice[id]!["score"] ||
            (score == bestByDevice[id]!["score"] &&
                time < bestByDevice[id]!["timeTaken"])) {
          bestByDevice[id] = {
            "deviceId": id,
            "username": data["username"] ?? "Player",
            "score": score,
            "timeTaken": time,
          };
        }
      }
    }

    final list = bestByDevice.values.toList();

    list.sort((a, b) {
      final s = b["score"].compareTo(a["score"]);
      if (s != 0) return s;
      return a["timeTaken"].compareTo(b["timeTaken"]);
    });

    return list;
  }

  // -----------------------------------------------------------
  // UI
  // -----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final accent = AppTheme.adaptiveAccent(context);
    final card = AppTheme.adaptiveCard(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaderboard"),
        centerTitle: true,
        backgroundColor: accent,
  foregroundColor: Colors.white,
  elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _tabs(accent),
          const SizedBox(height: 12),
          Expanded(child: _tabContent(accent, card)),
          if (_yourRankSection() != null) _yourRankSection()!,
        ],
      ),
    );
  }

  Widget _tabs(Color accent) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ["daily", "weekly"].map((t) {
          final selected = selectedTab == t;
          return GestureDetector(
            onTap: () => setState(() => selectedTab = t),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? accent : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                t.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : accent,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _tabContent(Color accent, Color card) {
    if (selectedTab == "daily") {
      return StreamBuilder(
        stream: _quizRepo.getDailyLeaderboard(),
        builder: (_, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snap.data!.docs.map((d) => d.data()).toList();
          return _buildList(list, accent, card);
        },
      );
    } else {
      return FutureBuilder(
        future: _fetchWeeklyLeaderboardList(),
        builder: (_, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildList(snap.data!, accent, card);
        },
      );
    }
  }

  Widget _buildList(
      List<Map<String, dynamic>> list, Color accent, Color card) {
    if (list.isEmpty) {
      return const Center(child: Text("You haven't attempted ranked quizzes yet."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final e = list[i];
        final rank = i + 1;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: accent.withOpacity(0.15),
                child: Text(
                  rank <= 3 ? ["🥇", "🥈", "🥉"][rank - 1] : "$rank",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  e["username"] ?? "Player",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                "${e["score"]}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: accent,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget? _yourRankSection() {
    final rank = selectedTab == "daily" ? myDailyRank : myWeeklyRank;
    if (rank == null) return null;

    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        "🔥 Your Rank: #$rank",
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
