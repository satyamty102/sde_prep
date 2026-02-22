import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'difficulty_badge.dart';

/// A grid card for a DSA topic showing problems count, solved count, and difficulty
/// Used in DSA topics screen (grid layout)
class TopicCard extends StatelessWidget {
  final String topicName;
  final String difficulty;
  final int totalProblems;
  final int solvedProblems;
  final VoidCallback onTap;
  final Color? accentColor;

  const TopicCard({
    super.key,
    required this.topicName,
    required this.difficulty,
    required this.totalProblems,
    required this.solvedProblems,
    required this.onTap,
    this.accentColor,
  });

  /// Calculate completion percentage (0.0 to 1.0)
  double get _completionPercent =>
      totalProblems == 0 ? 0 : solvedProblems / totalProblems;

  /// Get accent color based on difficulty
  Color get _difficultyColor {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return const Color(0xFF50E090); // Green
      case 'medium':
        return const Color(0xFF60D0F0); // Cyan
      case 'hard':
        return const Color(0xFFA060F0); // Purple
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? _difficultyColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E),
          border: Border.all(color: color.withOpacity(0.2), width: 1.5),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top: Topic name + difficulty
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          topicName,
                          style: GoogleFonts.syne(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      DifficultyBadge(difficulty: difficulty),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Progress bar and count
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: _completionPercent,
                          minHeight: 8,
                          backgroundColor: Colors.white12,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Solved count
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$solvedProblems / $totalProblems',
                            style: GoogleFonts.robotoMono(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          Text(
                            '${(_completionPercent * 100).toStringAsFixed(0)}%',
                            style: GoogleFonts.robotoMono(
                              fontSize: 12,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Hover/click feedback with overlay
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(16),
                hoverColor: color.withOpacity(0.05),
                highlightColor: color.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
