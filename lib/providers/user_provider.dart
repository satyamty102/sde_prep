import 'package:flutter/material.dart';
import '../models/index.dart';
import '../services/firebase_service.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  // State variables
  UserStats? _userStats;
  List<DailyTask>? _dailyTasks;
  Map<String, List<bool>>? _dsaProgress;
  bool _isLoading = true;
  String? _error;

  // Getters
  UserStats? get userStats => _userStats;
  List<DailyTask>? get dailyTasks => _dailyTasks;
  Map<String, List<bool>>? get dsaProgress => _dsaProgress;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get totalProblemsSolved => _userStats?.totalProblemsSolved ?? 0;
  int get currentStreak => _userStats?.currentStreak ?? 0;
  int get longestStreak => _userStats?.longestStreak ?? 0;

  /// Initialize provider and load all data
  Future<void> initialize() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Load initial data
      _userStats = await _firebaseService.getUserStats();
      _dailyTasks = await _firebaseService.getDailyTasks(DateTime.now());
      _dsaProgress = await _firebaseService.getDSAProgress();

      _isLoading = false;
      notifyListeners();

      // Set up real-time streams (but don't await them)
      _setupStreams();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set up real-time Firebase streams
  void _setupStreams() {
    // Listen to user stats changes
    _firebaseService.getUserStatsStream().listen(
      (stats) {
        _userStats = stats;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        notifyListeners();
      },
    );

    // Listen to today's daily tasks
    _firebaseService
        .getDailyTasksStream(DateTime.now())
        .listen(
          (tasks) {
            _dailyTasks = tasks;
            notifyListeners();
          },
          onError: (e) {
            _error = e.toString();
            notifyListeners();
          },
        );
  }

  // ==================== USER STATS ====================

  /// Add a problem as solved
  Future<void> addProblemSolved(String problemName) async {
    try {
      await _firebaseService.addProblemSolved(problemName);
      // Stats will update via stream auto-matically
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Increment apps sent count
  Future<void> incrementAppsCount() async {
    try {
      await _firebaseService.incrementAppsCount();
      // Stats will update via stream automatically
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ==================== DAILY TASKS ====================

  /// Reload today's daily tasks
  Future<void> reloadDailyTasks() async {
    try {
      _dailyTasks = await _firebaseService.getDailyTasks(DateTime.now());
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Toggle a daily task completion
  Future<void> toggleDailyTask(int taskId) async {
    if (_dailyTasks == null) return;

    try {
      final taskIndex = _dailyTasks!.indexWhere((t) => t.id == taskId);
      if (taskIndex != -1) {
        final task = _dailyTasks![taskIndex];
        final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
        await _firebaseService.updateDailyTask(DateTime.now(), updatedTask);

        // Check if all tasks completed for streak update
        final allCompleted = _dailyTasks!
            .asMap()
            .entries
            .map((e) => e.key == taskIndex ? updatedTask : _dailyTasks![e.key])
            .every((t) => t.isCompleted);

        if (allCompleted) {
          await _firebaseService.updateStreak();
        }
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Get completion percentage of today's tasks
  double getDailyCompletionPercent() {
    if (_dailyTasks == null || _dailyTasks!.isEmpty) return 0;
    final completed = _dailyTasks!.where((t) => t.isCompleted).length;
    return completed / _dailyTasks!.length;
  }

  /// Check if all tasks are completed today
  bool areAllTasksCompleted() {
    if (_dailyTasks == null) return false;
    return _dailyTasks!.isNotEmpty && _dailyTasks!.every((t) => t.isCompleted);
  }

  // ==================== DSA PROGRESS ====================

  /// Reload DSA progress
  Future<void> reloadDSAProgress() async {
    try {
      _dsaProgress = await _firebaseService.getDSAProgress();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Toggle a problem as solved in a topic
  Future<void> toggleProblemSolved(String topicId, int problemIndex) async {
    try {
      // Ensure _dsaProgress is initialized
      _dsaProgress ??= {};

      // Initialize topic if not exists
      if (_dsaProgress![topicId] == null) {
        final topic = allDSATopics.firstWhere(
          (t) => t.id == topicId,
          orElse: () => DSATopic(
            id: topicId,
            name: 'Unknown',
            difficulty: 'Unknown',
            problems: [],
          ),
        );
        _dsaProgress![topicId] = List.filled(topic.problems.length, false);
      }

      final current = _dsaProgress![topicId]!;
      if (problemIndex < current.length) {
        final newSolved = !current[problemIndex];
        await _firebaseService.toggleProblemSolved(
          topicId,
          problemIndex,
          newSolved,
        );
        // Progress will update automatically via stream
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Get solved count for a topic
  int getTopicSolvedCount(String topicId) {
    if (_dsaProgress?[topicId] == null) return 0;
    return _dsaProgress![topicId]!.where((p) => p).length;
  }

  /// Get total problems for a topic (from DSA data)
  int getTopicTotalCount(String topicId) {
    final topic = allDSATopics.firstWhere(
      (t) => t.id == topicId,
      orElse: () {
        return DSATopic(
          id: topicId,
          name: 'Unknown',
          difficulty: 'Unknown',
          problems: [],
        );
      },
    );
    return topic.problems.length;
  }

  /// Get completion percent for a topic
  double getTopicCompletionPercent(String topicId) {
    final total = getTopicTotalCount(topicId);
    if (total == 0) return 0;
    return getTopicSolvedCount(topicId) / total;
  }

  /// Get all solved problems count
  int getTotalSolvedProblems() {
    if (_dsaProgress == null) return 0;
    int total = 0;
    _dsaProgress!.forEach((_, problems) {
      total += problems.where((p) => p).length;
    });
    return total;
  }

  /// Get roadmap completion percent
  double getRoadmapCompletionPercent() {
    if (_dsaProgress == null || _dsaProgress!.isEmpty) return 0;
    int totalSolved = 0;
    int totalProblems = 0;

    for (var topic in allDSATopics) {
      final solved = _dsaProgress?[topic.id]?.where((p) => p).length ?? 0;
      totalSolved += solved;
      totalProblems += topic.problems.length;
    }

    if (totalProblems == 0) return 0;
    return totalSolved / totalProblems;
  }

  // ==================== UTILITIES ====================

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Force refresh all data
  Future<void> refreshAll() async {
    try {
      await initialize();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
