import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A roadmap phase card with expandable accordion behavior
/// Shows phase title, week overview, and toggles task list
class PhaseCard extends StatefulWidget {
  final int phaseNumber;
  final String title;
  final String subtitle; // e.g., "Weeks 1-4"
  final Color accentColor;
  final List<String> weeks; // List of week titles
  final List<List<String>> weekTasks; // Tasks for each week
  final double completionPercent;

  const PhaseCard({
    super.key,
    required this.phaseNumber,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.weeks,
    required this.weekTasks,
    this.completionPercent = 0,
  });

  @override
  State<PhaseCard> createState() => _PhaseCardState();
}

class _PhaseCardState extends State<PhaseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _expandController.forward() : _expandController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        border: Border.all(
          color: widget.accentColor.withOpacity(0.2),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header (always visible, tappable)
          GestureDetector(
            onTap: _toggle,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Phase badge
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: widget.accentColor.withOpacity(0.2),
                      border: Border.all(color: widget.accentColor, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'P${widget.phaseNumber}',
                        style: GoogleFonts.syne(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: widget.accentColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Phase title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.syne(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.subtitle,
                          style: GoogleFonts.robotoMono(
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Progress bar (vertical display)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${(widget.completionPercent * 100).toStringAsFixed(0)}%',
                        style: GoogleFonts.robotoMono(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: widget.accentColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Mini progress bar
                      SizedBox(
                        width: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: widget.completionPercent,
                            minHeight: 6,
                            backgroundColor: Colors.white12,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              widget.accentColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Expand/collapse icon
                  const SizedBox(width: 12),
                  RotationTransition(
                    turns: Tween(
                      begin: 0.0,
                      end: 0.5,
                    ).animate(_expandController),
                    child: Icon(
                      Icons.expand_more,
                      color: widget.accentColor,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          SizeTransition(
            sizeFactor: _expandController,
            child: Container(
              color: widget.accentColor.withOpacity(0.05),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.white12),
                  const SizedBox(height: 12),

                  // Week list
                  ...List.generate(
                    widget.weeks.length,
                    (index) => _buildWeekItem(
                      context,
                      widget.weeks[index],
                      widget.weekTasks[index],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekItem(
    BuildContext context,
    String weekTitle,
    List<String> tasks,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          weekTitle,
          style: GoogleFonts.syne(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        ...tasks.map(
          (task) => Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Row(
              children: [
                Text(
                  '•',
                  style: TextStyle(color: widget.accentColor, fontSize: 16),
                ),
                const SizedBox(width: 8),
                Text(
                  task,
                  style: GoogleFonts.robotoMono(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
