import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A task row with checkbox, title, description, and duration
/// Used in daily tracker screen
class TaskRow extends StatelessWidget {
  final String title;
  final String description;
  final int durationMinutes;
  final bool isCompleted;
  final VoidCallback onTap;
  final Color? accentColor;

  const TaskRow({
    super.key,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.isCompleted,
    required this.onTap,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? const Color(0xFF60D0F0); // Default cyan

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        border: Border.all(
          color: isCompleted ? color.withOpacity(0.5) : Colors.white12,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated checkbox
            AnimatedScale(
              scale: isCompleted ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isCompleted ? color : Colors.transparent,
                  border: Border.all(
                    color: isCompleted ? color : Colors.white30,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: isCompleted
                    ? Icon(
                        Icons.check,
                        color: const Color(0xFF060608),
                        size: 16,
                        weight: 800,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 12),

            // Task info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: GoogleFonts.syne(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isCompleted
                          ? color.withOpacity(0.6)
                          : Colors.white,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Description
                  Text(
                    description,
                    style: GoogleFonts.robotoMono(
                      fontSize: 11,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Duration badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${durationMinutes}m',
                style: GoogleFonts.robotoMono(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
