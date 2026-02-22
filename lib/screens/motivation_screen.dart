import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

class MotivationScreen extends StatefulWidget {
  const MotivationScreen({super.key});

  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  late PageController _quoteController;
  int _currentQuoteIndex = 0;

  final List<String> quotes = [
    "The best time to start was yesterday. The second best time is right now.",
    "You don't have to be great to start, but you have to start to be great.",
    "Every problem you struggle through is one less problem that can beat you.",
    "The engineer who gets the offer prepared most consistently, not most brilliantly.",
    "Confusion is the feeling of your brain rewiring itself. Lean into it.",
    "Stop comparing your chapter 1 to someone else's chapter 20.",
    "One accepted solution per day keeps unemployment away.",
    "You're not behind. You're exactly where you need to be.",
    "An hour of focused practice beats 5 hours of distracted studying.",
    "The gap between where you are and where you want to be is called practice.",
  ];

  @override
  void initState() {
    super.initState();
    _quoteController = PageController();
  }

  @override
  void dispose() {
    _quoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Motivation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================== HARD TRUTH BANNER ====================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFA060F0).withOpacity(0.15),
                border: Border.all(color: purple, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: purple,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Today\'s Hard Truth',
                        style: GoogleFonts.syne(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Most people spend 80% of their interview prep time on theory and 20% mock interviewing. Do the opposite. The gap between your coding and your communication skills is where offers are lost.',
                    style: GoogleFonts.robotoMono(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.8),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ==================== DAILY QUOTE CAROUSEL ====================
            Text(
              'Quote of the Day',
              style: GoogleFonts.syne(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 220,
              child: PageView.builder(
                controller: _quoteController,
                onPageChanged: (index) {
                  setState(() => _currentQuoteIndex = index);
                },
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [gold.withOpacity(0.2), cyan.withOpacity(0.2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: gold.withOpacity(0.3),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.format_quote,
                          color: gold.withOpacity(0.5),
                          size: 36,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          quotes[index],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.syne(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                            height: 1.7,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${index + 1}/${quotes.length}',
                          style: GoogleFonts.robotoMono(
                            fontSize: 11,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // ==================== TIPS SECTION ====================
            Text(
              'Winning Tips',
              style: GoogleFonts.syne(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            ...List.generate(_motivationTips.length, (index) {
              final tip = _motivationTips[index];
              return _TipCard(
                icon: tip['icon'] as IconData,
                title: tip['title'] as String,
                description: tip['description'] as String,
                color: tip['color'] as Color,
                index: index,
              );
            }),

            const SizedBox(height: 32),

            // ==================== ENCOURAGEMENT ====================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: green.withOpacity(0.1),
                border: Border.all(color: green, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Remember',
                    style: GoogleFonts.syne(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Every engineer at Google, Microsoft, Meta, Amazon once sat where you are. They all felt imposter syndrome. They all struggled. The only difference? They kept going.\n\n'
                    'You\'re not competing against them. You\'re competing against your past self.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoMono(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.8),
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: const Color(0xFFF0A060),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'You\'ve got this!',
                        style: GoogleFonts.syne(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFF0A060),
                        ),
                      ),
                    ],
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

class _TipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final int index;

  const _TipCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Icon(icon, color: color, size: 24)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.syne(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.robotoMono(
                    fontSize: 11,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> _motivationTips = [
  {
    'icon': Icons.schedule,
    'title': 'Consistency > Intensity',
    'description':
        '1 hour every single day beats 10 hours once a week. Your daily tasks exist for this reason.',
    'color': const Color(0xFF60D0F0), // Cyan
  },
  {
    'icon': Icons.people,
    'title': 'Mock Interviews Win Offers',
    'description':
        'In Week 11, switch from LeetCode grinding to mock interviews. That\'s where the real practice is.',
    'color': const Color(0xFFF0C060), // Gold
  },
  {
    'icon': Icons.lightbulb,
    'title': 'Read Others\' Solutions',
    'description':
        'Don\'t just solve problems. Study optimal solutions. Speed doesn\'t matter if your approach is suboptimal.',
    'color': const Color(0xFF50E090), // Green
  },
  {
    'icon': Icons.chat,
    'title': 'Explain Out Loud',
    'description':
        'Rubber duck debugging works. Explain your approach before coding. Your interviewer will love it.',
    'color': const Color(0xFFA060F0), // Purple
  },
  {
    'icon': Icons.trending_up,
    'title': 'Track Applications',
    'description':
        'Jobs tab isn\'t just a counter. It\'s proof of your offer probability. 100 apps = multiple offers.',
    'color': const Color(0xFFF0A060), // Orange
  },
  {
    'icon': Icons.favorite,
    'title': 'Rest is Training',
    'description':
        'Your brain consolidates learning during sleep. Don\'t skip sleep to study. Sleep IS studying.',
    'color': const Color(0xFF60D0F0), // Cyan
  },
];
