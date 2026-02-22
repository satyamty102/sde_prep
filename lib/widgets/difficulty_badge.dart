import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A badge that displays difficulty level (Easy/Medium/Hard) with color-coded styling
/// Used in DSA topic cards
class DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const DifficultyBadge({super.key, required this.difficulty});

  /// Get color based on difficulty level
  Color _getColor() {
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
    final color = _getColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        difficulty,
        style: GoogleFonts.syne(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
