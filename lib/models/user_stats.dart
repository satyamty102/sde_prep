class UserStats {
  final String uid;
  final List<String> problemsDone;
  final int currentStreak;
  final int longestStreak;
  final int appsCount;
  final Map<String, int> weeklyProblems; // date -> count
  final DateTime lastActiveDate;

  UserStats({
    required this.uid,
    this.problemsDone = const [],
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.appsCount = 0,
    this.weeklyProblems = const {},
    DateTime? lastActiveDate,
  }) : lastActiveDate = lastActiveDate ?? DateTime.now();

  // Firestore serialization
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'problemsDone': problemsDone,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'appsCount': appsCount,
      'weeklyProblems': weeklyProblems,
      'lastActiveDate': lastActiveDate.toIso8601String(),
    };
  }

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      uid: json['uid'] as String,
      problemsDone: List<String>.from(json['problemsDone'] as List? ?? []),
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      appsCount: json['appsCount'] as int? ?? 0,
      weeklyProblems: Map<String, int>.from(
        (json['weeklyProblems'] as Map? ?? {}).cast<String, int>(),
      ),
      lastActiveDate: json['lastActiveDate'] != null
          ? DateTime.parse(json['lastActiveDate'] as String)
          : DateTime.now(),
    );
  }

  UserStats copyWith({
    String? uid,
    List<String>? problemsDone,
    int? currentStreak,
    int? longestStreak,
    int? appsCount,
    Map<String, int>? weeklyProblems,
    DateTime? lastActiveDate,
  }) {
    return UserStats(
      uid: uid ?? this.uid,
      problemsDone: problemsDone ?? this.problemsDone,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      appsCount: appsCount ?? this.appsCount,
      weeklyProblems: weeklyProblems ?? this.weeklyProblems,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }

  // Helpers
  int get totalProblemsSolved => problemsDone.length;

  bool hasSolvedProblem(String problemName) =>
      problemsDone.contains(problemName);

  UserStats addProblemSolved(String problemName) {
    if (hasSolvedProblem(problemName)) return this;
    return copyWith(problemsDone: [...problemsDone, problemName]);
  }

  UserStats incrementAppsCount() {
    return copyWith(appsCount: appsCount + 1);
  }

  UserStats updateStreak(int newStreak, int? newLongest) {
    return copyWith(
      currentStreak: newStreak,
      longestStreak: newLongest ?? longestStreak,
      lastActiveDate: DateTime.now(),
    );
  }
}
