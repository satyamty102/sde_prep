import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/index.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get uid => _auth.currentUser?.uid;

  // ==================== USER STATS ====================

  /// Get or create user stats
  Future<UserStats> getUserStats() async {
    if (uid == null) return _getLocalStats();

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserStats.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        // Create new user stats
        final stats = UserStats(uid: uid!);
        await _firestore.collection('users').doc(uid).set(stats.toJson());
        return stats;
      }
    } catch (e) {
      print('Error getting user stats: $e');
      return _getLocalStats();
    }
  }

  /// Stream user stats for real-time updates
  Stream<UserStats> getUserStatsStream() {
    if (uid == null) {
      return Stream.value(_getLocalStats());
    }

    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) {
          if (doc.exists) {
            return UserStats.fromJson(doc.data() as Map<String, dynamic>);
          }
          return UserStats(uid: uid!);
        })
        .handleError((e) {
          print('Error in getUserStatsStream: $e');
          return _getLocalStats();
        });
  }

  /// Update user stats
  Future<void> updateUserStats(UserStats stats) async {
    if (uid == null) {
      await _saveLocalStats(stats);
      return;
    }

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .set(stats.toJson(), SetOptions(merge: true));
      await _saveLocalStats(stats); // Cache locally
    } catch (e) {
      print('Error updating user stats: $e');
      await _saveLocalStats(stats);
    }
  }

  /// Add a problem as solved
  Future<void> addProblemSolved(String problemName) async {
    final stats = await getUserStats();
    final updated = stats.addProblemSolved(problemName);
    await updateUserStats(updated);
  }

  /// Increment apps count
  Future<void> incrementAppsCount() async {
    final stats = await getUserStats();
    final updated = stats.incrementAppsCount();
    await updateUserStats(updated);
  }

  // ==================== DAILY TASKS ====================

  /// Get or create today's daily tasks
  Future<List<DailyTask>> getDailyTasks(DateTime date) async {
    if (uid == null) return _getLocalDailyTasks(date);

    try {
      final dateStr = _dateToString(date);
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('dailyTasks')
          .doc(dateStr)
          .get();

      if (doc.exists) {
        final tasks = (doc.data()?['tasks'] as List? ?? [])
            .cast<Map<String, dynamic>>()
            .map((t) => DailyTask.fromJson(t))
            .toList();
        return tasks;
      } else {
        // Initialize today's tasks
        final tasks = dailyTasks.map((t) => t.copyWith()).toList();
        await setDailyTasks(date, tasks);
        return tasks;
      }
    } catch (e) {
      print('Error getting daily tasks: $e');
      return _getLocalDailyTasks(date);
    }
  }

  /// Stream today's daily tasks
  Stream<List<DailyTask>> getDailyTasksStream(DateTime date) {
    if (uid == null) {
      return Stream.value(_getLocalDailyTasks(date));
    }

    final dateStr = _dateToString(date);
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('dailyTasks')
        .doc(dateStr)
        .snapshots()
        .map((doc) {
          if (doc.exists) {
            final tasks = (doc.data()?['tasks'] as List? ?? [])
                .cast<Map<String, dynamic>>()
                .map((t) => DailyTask.fromJson(t))
                .toList();
            return tasks;
          }
          return dailyTasks.map((t) => t.copyWith()).toList();
        })
        .handleError((e) {
          print('Error in getDailyTasksStream: $e');
          return _getLocalDailyTasks(date);
        });
  }

  /// Update daily tasks
  Future<void> setDailyTasks(DateTime date, List<DailyTask> tasks) async {
    if (uid == null) {
      await _saveLocalDailyTasks(date, tasks);
      return;
    }

    try {
      final dateStr = _dateToString(date);
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('dailyTasks')
          .doc(dateStr)
          .set({
            'tasks': tasks.map((t) => t.toJson()).toList(),
            'date': dateStr,
            'allCompleted': tasks.every((t) => t.isCompleted),
          });
      await _saveLocalDailyTasks(date, tasks); // Cache locally
    } catch (e) {
      print('Error setting daily tasks: $e');
      await _saveLocalDailyTasks(date, tasks);
    }
  }

  /// Update a single task
  Future<void> updateDailyTask(DateTime date, DailyTask task) async {
    final tasks = await getDailyTasks(date);
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await setDailyTasks(date, tasks);
    }
  }

  /// Check if all tasks completed today for streak
  Future<bool> areAllTasksCompleted(DateTime date) async {
    final tasks = await getDailyTasks(date);
    return tasks.isNotEmpty && tasks.every((t) => t.isCompleted);
  }

  // ==================== DSA PROGRESS ====================

  /// Get or create DSA topic progress
  Future<Map<String, List<bool>>> getDSAProgress() async {
    if (uid == null) return _getLocalDSAProgress();

    try {
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('progress')
          .doc('dsa')
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data.map(
          (key, value) => MapEntry(key, List<bool>.from(value as List)),
        );
      }
      return {};
    } catch (e) {
      print('Error getting DSA progress: $e');
      return _getLocalDSAProgress();
    }
  }

  /// Update DSA progress for a topic
  Future<void> updateDSAProgress(String topicId, List<bool> solved) async {
    if (uid == null) {
      await _saveLocalDSAProgress(topicId, solved);
      return;
    }

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('progress')
          .doc('dsa')
          .set({topicId: solved}, SetOptions(merge: true));
      await _saveLocalDSAProgress(topicId, solved);
    } catch (e) {
      print('Error updating DSA progress: $e');
      await _saveLocalDSAProgress(topicId, solved);
    }
  }

  /// Toggle a problem as solved
  Future<void> toggleProblemSolved(
    String topicId,
    int problemIndex,
    bool solved,
  ) async {
    final progress = await getDSAProgress();
    final topicProgress = progress[topicId] ?? List.filled(10, false);
    if (problemIndex < topicProgress.length) {
      topicProgress[problemIndex] = solved;
      await updateDSAProgress(topicId, topicProgress);
    }
  }

  // ==================== STREAK MANAGEMENT ====================

  /// Update streak based on daily completion
  Future<void> updateStreak() async {
    final stats = await getUserStats();
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    // Check if tasks were all completed yesterday
    final yesterdayCompleted = await areAllTasksCompleted(yesterday);
    int newStreak = stats.currentStreak;

    if (yesterdayCompleted) {
      newStreak += 1;
    } else {
      newStreak = 0;
    }

    final maxStreak = newStreak > stats.longestStreak
        ? newStreak
        : stats.longestStreak;
    final updated = stats.updateStreak(newStreak, maxStreak);
    await updateUserStats(updated);
  }

  // ==================== LOCAL STORAGE FALLBACK ====================

  Future<void> _saveLocalStats(UserStats stats) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_stats', _jsonEncode(stats.toJson()));
    } catch (e) {
      print('Error saving local stats: $e');
    }
  }

  UserStats _getLocalStats() {
    try {
      // For now, return empty stats during sync
      // In a real app, you'd load from SharedPreferences
      return UserStats(uid: uid ?? 'anonymous');
    } catch (e) {
      print('Error getting local stats: $e');
      return UserStats(uid: uid ?? 'anonymous');
    }
  }

  Future<void> _saveLocalDailyTasks(
    DateTime date,
    List<DailyTask> tasks,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'daily_tasks_${_dateToString(date)}';
      final json = tasks.map((t) => t.toJson()).toList();
      await prefs.setString(key, _jsonEncode(json));
    } catch (e) {
      print('Error saving local daily tasks: $e');
    }
  }

  List<DailyTask> _getLocalDailyTasks(DateTime date) {
    return dailyTasks.map((t) => t.copyWith()).toList();
  }

  Future<void> _saveLocalDSAProgress(String topicId, List<bool> solved) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'dsa_progress_$topicId';
      await prefs.setString(key, _jsonEncode(solved));
    } catch (e) {
      print('Error saving local DSA progress: $e');
    }
  }

  Map<String, List<bool>> _getLocalDSAProgress() {
    return {};
  }

  // ==================== HELPERS ====================

  String _dateToString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _jsonEncode(dynamic obj) {
    // Simple JSON encoding for SharedPreferences
    // In production, use dart:convert
    return obj.toString();
  }
}
