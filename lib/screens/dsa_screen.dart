import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/index.dart';
import '../widgets/index.dart';
import '../main.dart';

class DSAScreen extends StatelessWidget {
  const DSAScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DSA Topics')),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: gold));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with total stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data Structures & Algorithms',
                          style: GoogleFonts.syne(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${userProvider.getTotalSolvedProblems()} problems solved',
                          style: GoogleFonts.robotoMono(
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: cyan.withOpacity(0.2),
                        border: Border.all(color: cyan, width: 1.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${(userProvider.getRoadmapCompletionPercent() * 100).toStringAsFixed(1)}%',
                        style: GoogleFonts.robotoMono(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: cyan,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Difficulty filter info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _DifficultyFilter(
                      label: 'Easy',
                      color: green,
                      count: allDSATopics
                          .where((t) => t.difficulty.toLowerCase() == 'easy')
                          .length,
                    ),
                    _DifficultyFilter(
                      label: 'Medium',
                      color: cyan,
                      count: allDSATopics
                          .where((t) => t.difficulty.toLowerCase() == 'medium')
                          .length,
                    ),
                    _DifficultyFilter(
                      label: 'Hard',
                      color: purple,
                      count: allDSATopics
                          .where((t) => t.difficulty.toLowerCase() == 'hard')
                          .length,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Topics grid
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.95,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: allDSATopics.length,
                  itemBuilder: (context, index) {
                    final topic = allDSATopics[index];
                    final solved = userProvider.getTopicSolvedCount(topic.id);
                    final total = topic.problems.length;

                    // Get difficulty color
                    Color getColor(String diff) {
                      switch (diff.toLowerCase()) {
                        case 'easy':
                          return green;
                        case 'medium':
                          return cyan;
                        case 'hard':
                          return purple;
                        default:
                          return gold;
                      }
                    }

                    return TopicCard(
                      topicName: topic.name,
                      difficulty: topic.difficulty,
                      totalProblems: total,
                      solvedProblems: solved,
                      accentColor: getColor(topic.difficulty),
                      onTap: () {
                        _showTopicDetails(context, topic, userProvider);
                      },
                    );
                  },
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showTopicDetails(
    BuildContext context,
    DSATopic topic,
    UserProvider userProvider,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Consumer<UserProvider>(
        builder: (context, provider, _) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic.name,
                          style: GoogleFonts.syne(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        DifficultyBadge(difficulty: topic.difficulty),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Progress
                Text(
                  'Progress',
                  style: GoogleFonts.syne(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),

                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: provider.getTopicCompletionPercent(topic.id),
                    minHeight: 10,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getTopicColor(topic.difficulty),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                Text(
                  '${provider.getTopicSolvedCount(topic.id)} / ${topic.problems.length}',
                  style: GoogleFonts.robotoMono(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 24),

                // Problems list
                Text(
                  'Problems',
                  style: GoogleFonts.syne(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                ...List.generate(topic.problems.length, (problemIndex) {
                  final problem = topic.problems[problemIndex];
                  final isSolved =
                      provider.dsaProgress?[topic.id]?[problemIndex] ?? false;

                  return GestureDetector(
                    onTap: () async {
                      await provider.toggleProblemSolved(
                        topic.id,
                        problemIndex,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSolved
                            ? _getTopicColor(
                                topic.difficulty,
                              ).withValues(alpha: 0.15)
                            : Colors.white.withValues(alpha: 0.5),
                        border: Border.all(
                          color: isSolved
                              ? _getTopicColor(topic.difficulty)
                              : Colors.white12,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isSolved
                                  ? _getTopicColor(topic.difficulty)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSolved
                                    ? _getTopicColor(topic.difficulty)
                                    : Colors.white30,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: isSolved
                                ? Icon(
                                    Icons.check,
                                    size: 14,
                                    color: const Color(0xFF060608),
                                    weight: 800,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              problem,
                              style: GoogleFonts.robotoMono(
                                fontSize: 12,
                                color: isSolved
                                    ? _getTopicColor(topic.difficulty)
                                    : Colors.white,
                                decoration: isSolved
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTopicColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return green;
      case 'medium':
        return cyan;
      case 'hard':
        return purple;
      default:
        return gold;
    }
  }
}

class _DifficultyFilter extends StatelessWidget {
  final String label;
  final Color color;
  final int count;

  const _DifficultyFilter({
    required this.label,
    required this.color,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.syne(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              Text(
                '$count topics',
                style: GoogleFonts.robotoMono(
                  fontSize: 9,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
