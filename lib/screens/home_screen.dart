import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/index.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  void _nextQuote() {
    _currentQuoteIndex = (_currentQuoteIndex + 1) % quotes.length;
    _quoteController.animateToPage(
      _currentQuoteIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SDE Prep'), elevation: 0),
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
                // ==================== STATS ROW ====================
                Text(
                  'Your Progress',
                  style: GoogleFonts.syne(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  childAspectRatio: 1.0,
                  children: [
                    StatCard(
                      label: 'Problems Solved',
                      value: userProvider.totalProblemsSolved.toString(),
                      icon: Icons.code,
                      color: gold,
                    ),
                    StatCard(
                      label: 'Current Streak 🔥',
                      value: userProvider.currentStreak.toString(),
                      icon: Icons.local_fire_department,
                      color: const Color(0xFFF0A060),
                    ),
                    StatCard(
                      label: 'Roadmap',
                      value:
                          '${(userProvider.getRoadmapCompletionPercent() * 100).toStringAsFixed(0)}%',
                      icon: Icons.map,
                      color: cyan,
                    ),
                    StatCard(
                      label: 'Apps Sent',
                      value:
                          userProvider.userStats?.appsCount.toString() ?? '0',
                      icon: Icons.mail,
                      color: green,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ==================== MOTIVATIONAL QUOTE ====================
                Text(
                  'Daily Motivation',
                  style: GoogleFonts.syne(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [purple.withOpacity(0.2), cyan.withOpacity(0.2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: purple.withOpacity(0.3),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      // Quote carousel
                      PageView.builder(
                        controller: _quoteController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: quotes.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.format_quote,
                                  color: purple.withOpacity(0.5),
                                  size: 28,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  quotes[index],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.syne(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // Next button
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: FloatingActionButton.small(
                          onPressed: _nextQuote,
                          backgroundColor: purple,
                          child: const Icon(
                            Icons.refresh,
                            color: Color(0xFF060608),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ==================== TODAY'S CHECKLIST ====================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today's Checklist",
                      style: GoogleFonts.syne(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${(userProvider.getDailyCompletionPercent() * 100).toStringAsFixed(0)}%',
                      style: GoogleFonts.robotoMono(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: userProvider.getDailyCompletionPercent(),
                    minHeight: 8,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(green),
                  ),
                ),
                const SizedBox(height: 16),

                // Daily tasks list
                if (userProvider.dailyTasks != null)
                  ...userProvider.dailyTasks!.map(
                    (task) => TaskRow(
                      title: task.title,
                      description: task.description,
                      durationMinutes: task.durationMinutes,
                      isCompleted: task.isCompleted,
                      accentColor: green,
                      onTap: () async {
                        await userProvider.toggleDailyTask(task.id);
                      },
                    ),
                  ),

                const SizedBox(height: 24),

                // Streak bonus message
                if (userProvider.areAllTasksCompleted())
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: green.withOpacity(0.15),
                      border: Border.all(color: green, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.celebration, color: green, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'All tasks done! Keep your streak alive! 🔥',
                            style: GoogleFonts.syne(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
