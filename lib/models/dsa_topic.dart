class DSATopic {
  final String id;
  final String name;
  final String difficulty; // Easy, Medium, Hard
  final List<String> problems;
  final List<bool> problemsSolved; // parallel list tracking which are done

  DSATopic({
    required this.id,
    required this.name,
    required this.difficulty,
    required this.problems,
    List<bool>? problemsSolved,
  }) : problemsSolved = problemsSolved ?? List.filled(problems.length, false);

  // Firestore serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'difficulty': difficulty,
      'problems': problems,
      'problemsSolved': problemsSolved,
    };
  }

  factory DSATopic.fromJson(Map<String, dynamic> json) {
    return DSATopic(
      id: json['id'] as String,
      name: json['name'] as String,
      difficulty: json['difficulty'] as String,
      problems: List<String>.from(json['problems'] as List),
      problemsSolved: List<bool>.from(json['problemsSolved'] as List? ?? []),
    );
  }

  int get solvedCount => problemsSolved.where((p) => p).length;
  int get totalCount => problems.length;
  double get percentComplete => totalCount == 0 ? 0 : solvedCount / totalCount;

  // Copy with method for updating
  DSATopic copyWith({
    String? id,
    String? name,
    String? difficulty,
    List<String>? problems,
    List<bool>? problemsSolved,
  }) {
    return DSATopic(
      id: id ?? this.id,
      name: name ?? this.name,
      difficulty: difficulty ?? this.difficulty,
      problems: problems ?? this.problems,
      problemsSolved: problemsSolved ?? this.problemsSolved,
    );
  }
}

// Predefined DSA topics with LeetCode problems
final List<DSATopic> allDSATopics = [
  DSATopic(
    id: 'arrays',
    name: 'Arrays',
    difficulty: 'Easy',
    problems: [
      'Two Sum',
      'Best Time to Buy Stock',
      'Contains Duplicate',
      'Product of Array Except Self',
      'Maximum Subarray',
    ],
  ),
  DSATopic(
    id: 'two_pointers',
    name: 'Two Pointers',
    difficulty: 'Easy',
    problems: [
      'Valid Palindrome',
      'Two Sum II',
      'Three Sum',
      'Container With Most Water',
      'Trapping Rain Water',
    ],
  ),
  DSATopic(
    id: 'sliding_window',
    name: 'Sliding Window',
    difficulty: 'Medium',
    problems: [
      'Longest Substring No Repeat',
      'Min Window Substring',
      'Permutation in String',
      'Fruit Into Baskets',
    ],
  ),
  DSATopic(
    id: 'hashmap',
    name: 'HashMap',
    difficulty: 'Easy',
    problems: [
      'Valid Anagram',
      'Group Anagrams',
      'Top K Frequent Elements',
      'Longest Consecutive Sequence',
    ],
  ),
  DSATopic(
    id: 'stack',
    name: 'Stack',
    difficulty: 'Easy',
    problems: [
      'Valid Parentheses',
      'Min Stack',
      'Daily Temperatures',
      'Largest Rectangle Histogram',
    ],
  ),
  DSATopic(
    id: 'binary_search',
    name: 'Binary Search',
    difficulty: 'Medium',
    problems: [
      'Binary Search',
      'Search in Rotated Array',
      'Find Min in Rotated Array',
      'Koko Eating Bananas',
    ],
  ),
  DSATopic(
    id: 'linked_list',
    name: 'Linked List',
    difficulty: 'Medium',
    problems: [
      'Reverse Linked List',
      'Merge Two Sorted Lists',
      'Detect Cycle',
      'LRU Cache',
      'Reorder List',
    ],
  ),
  DSATopic(
    id: 'trees',
    name: 'Trees',
    difficulty: 'Medium',
    problems: [
      'Invert Binary Tree',
      'Max Depth',
      'Diameter',
      'Level Order Traversal',
      'Lowest Common Ancestor',
    ],
  ),
  DSATopic(
    id: 'graphs',
    name: 'Graphs',
    difficulty: 'Medium',
    problems: [
      'Number of Islands',
      'Clone Graph',
      'Course Schedule',
      'Pacific Atlantic Water Flow',
    ],
  ),
  DSATopic(
    id: 'dynamic_programming',
    name: 'Dynamic Programming',
    difficulty: 'Hard',
    problems: [
      'Climbing Stairs',
      'House Robber',
      'Coin Change',
      'Longest Common Subsequence',
      'Word Break',
    ],
  ),
  DSATopic(
    id: 'heap',
    name: 'Heap',
    difficulty: 'Medium',
    problems: [
      'Kth Largest Element',
      'K Closest Points',
      'Task Scheduler',
      'Find Median from Stream',
    ],
  ),
  DSATopic(
    id: 'backtracking',
    name: 'Backtracking',
    difficulty: 'Hard',
    problems: [
      'Subsets',
      'Combination Sum',
      'Permutations',
      'Word Search',
      'N-Queens',
    ],
  ),
];
