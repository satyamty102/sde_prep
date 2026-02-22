import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// An animated stat card that displays a metric with label and icon
/// Used on home screen dashboard (Problems Solved, Streak, Roadmap %, Apps Sent)
class StatCard extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Create animation controller (duration: 600ms)
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Create scale animation (starts at 0.8, goes to 1.0)
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    // Auto-play animation when widget loads
    _animationController.forward();
  }

  @override
  void didUpdateWidget(StatCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Replay animation if value changes
    if (oldWidget.value != widget.value) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E), // Card background
          border: Border.all(color: widget.color.withOpacity(0.3), width: 1.5),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon at top
            Icon(widget.icon, color: widget.color, size: 32),
            const SizedBox(height: 12),

            // Large number/value
            Text(
              widget.value,
              style: GoogleFonts.robotoMono(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: widget.color,
              ),
            ),
            const SizedBox(height: 8),

            // Label at bottom
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: GoogleFonts.syne(
                fontSize: 12,
                color: Colors.white54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
