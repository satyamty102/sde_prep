class DailyTask {
  final int id;
  final String title;
  final String description;
  final int durationMinutes;
  bool isCompleted;

  DailyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    this.isCompleted = false,
  });

  // Firestore serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
    };
  }

  factory DailyTask.fromJson(Map<String, dynamic> json) {
    return DailyTask(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      durationMinutes: json['durationMinutes'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  DailyTask copyWith({
    int? id,
    String? title,
    String? description,
    int? durationMinutes,
    bool? isCompleted,
  }) {
    return DailyTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// Predefined daily tasks
final List<DailyTask> dailyTasks = [
  DailyTask(
    id: 0,
    title: 'Review yesterday\'s problem',
    description: 'Revisit and revise one problem from yesterday',
    durationMinutes: 15,
  ),
  DailyTask(
    id: 1,
    title: 'Solve 1 LeetCode problem',
    description: 'Solve a problem timed (45 minutes limit)',
    durationMinutes: 45,
  ),
  DailyTask(
    id: 2,
    title: 'Study 1 pattern deeply',
    description: 'Deep dive into one DSA pattern',
    durationMinutes: 30,
  ),
  DailyTask(
    id: 3,
    title: 'Watch 1 NeetCode video',
    description: 'Watch and take notes on a NeetCode explanation',
    durationMinutes: 15,
  ),
  DailyTask(
    id: 4,
    title: 'Send 2-3 job applications',
    description: 'Apply to companies and track submissions',
    durationMinutes: 20,
  ),
  DailyTask(
    id: 5,
    title: 'Log progress in journal',
    description: 'Write brief notes on today\'s learnings',
    durationMinutes: 5,
  ),
];
