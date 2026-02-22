import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/index.dart';
import '../main.dart';

class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interview Roadmap')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your 24-Week Journey',
              style: GoogleFonts.syne(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              'Expand each phase to see weekly topics and tasks',
              style: GoogleFonts.robotoMono(
                fontSize: 12,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 24),

            // ==================== PHASE 1: FOUNDATION ====================
            PhaseCard(
              phaseNumber: 1,
              title: 'Foundation',
              subtitle: 'Weeks 1–4',
              accentColor: green,
              completionPercent: 0.5,
              weeks: [
                'Week 1: Arrays',
                'Week 2: Strings',
                'Week 3: Stack & Queues',
                'Week 4: Binary Search',
              ],
              weekTasks: [
                [
                  'Arrays: Two Sum, Best Time to Buy Stock',
                  'Complete 5+ Array problems',
                ],
                [
                  'Strings: Valid Palindrome, Anagrams',
                  'Pattern: Sliding Window intro',
                ],
                [
                  'Stack: Valid Parentheses, Min Stack',
                  'Queue: Basics, BFS prep',
                ],
                ['Binary Search: Basic, Rotated Array', 'Apply to 3+ problems'],
              ],
            ),

            // ==================== PHASE 2: CORE DSA ====================
            PhaseCard(
              phaseNumber: 2,
              title: 'Core DSA',
              subtitle: 'Weeks 5–10',
              accentColor: cyan,
              completionPercent: 0.0,
              weeks: [
                'Week 5-6: Linked Lists',
                'Week 7-8: Trees',
                'Week 9: Graphs',
                'Week 10: Dynamic Programming',
              ],
              weekTasks: [
                [
                  'Linked Lists: Reverse, Merge, Detect Cycle',
                  'LRU Cache pattern',
                ],
                ['Trees: Invert, Max Depth, Traversals', 'BST fundamentals'],
                ['Graphs: Islands, Clone Graph, BFS/DFS', 'Topological sort'],
                [
                  'DP: Climbing Stairs, House Robber',
                  'Bottom-up approach practice',
                ],
              ],
            ),

            // ==================== PHASE 3: INTERVIEW MODE ====================
            PhaseCard(
              phaseNumber: 3,
              title: 'Interview Mode',
              subtitle: 'Weeks 11–16',
              accentColor: purple,
              completionPercent: 0.0,
              weeks: [
                'Week 11-12: Mock Interviews',
                'Week 13-14: System Design',
                'Week 15-16: Behavioral Prep',
              ],
              weekTasks: [
                [
                  '2x Mock interviews (timed)',
                  'Review video, identify weak areas',
                ],
                ['System Design: URL Shortener, Cache', 'Scalability basics'],
                [
                  'STAR method for behavioral',
                  'Practice: Tell me about yourself',
                ],
              ],
            ),

            // ==================== PHASE 4: OFFER SEASON ====================
            PhaseCard(
              phaseNumber: 4,
              title: 'Offer Season',
              subtitle: 'Weeks 17–24',
              accentColor: gold,
              completionPercent: 0.0,
              weeks: [
                'Week 17-20: Strategic Applications',
                'Week 21-22: Negotiations',
                'Week 23-24: Final Polish',
              ],
              weekTasks: [
                [
                  '50+ applications (tracked in Jobs tab)',
                  'Customize cover letters',
                ],
                [
                  'Negotiation tactics & frameworks',
                  'Salary research per company',
                ],
                [
                  'Re-solve 10 favorite problems',
                  'Confidence building final week',
                ],
              ],
            ),

            const SizedBox(height: 32),

            // Tips section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF13131C),
                border: Border.all(color: gold.withOpacity(0.3), width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: gold, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Pro Tips',
                        style: GoogleFonts.syne(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: gold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '• Don\'t rush phases — master fundamentals first\n'
                    '• Spend 60% on coding, 40% on system design\n'
                    '• Mock interviews starting Week 11 are crucial\n'
                    '• Track every application (never forget what you sent)',
                    style: GoogleFonts.robotoMono(
                      fontSize: 11,
                      color: Colors.white70,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
