import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/index.dart';
import '../main.dart';

class DailyTrackerScreen extends StatelessWidget {
  const DailyTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Tracker')),
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
                // ==================== DATE & STREAK ====================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today\'s Progress',
                          style: GoogleFonts.syne(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateTime.now().toString().split(' ')[0],
                          style: GoogleFonts.robotoMono(
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                    // Streak display
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0A060).withOpacity(0.2),
                        border: Border.all(
                          color: const Color(0xFFF0A060),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text('🔥', style: GoogleFonts.syne(fontSize: 28)),
                          const SizedBox(height: 4),
                          Text(
                            userProvider.currentStreak.toString(),
                            style: GoogleFonts.robotoMono(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFF0A060),
                            ),
                          ),
                          Text(
                            'day streak',
                            style: GoogleFonts.syne(
                              fontSize: 9,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ==================== PROGRESS BAR ====================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daily Completion',
                          style: GoogleFonts.syne(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: userProvider.getDailyCompletionPercent(),
                        minHeight: 12,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation<Color>(green),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ==================== TASKS LIST ====================
                Text(
                  'Today\'s Tasks',
                  style: GoogleFonts.syne(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                if (userProvider.dailyTasks != null)
                  ...userProvider.dailyTasks!.asMap().entries.map((entry) {
                    final index = entry.key;
                    final task = entry.value;

                    return TaskRow(
                      title: task.title,
                      description: task.description,
                      durationMinutes: task.durationMinutes,
                      isCompleted: task.isCompleted,
                      accentColor: green,
                      onTap: () async {
                        await userProvider.toggleDailyTask(task.id);
                      },
                    );
                  }),

                const SizedBox(height: 32),

                // ==================== STATS CARDS ====================
                Text(
                  'Your Stats',
                  style: GoogleFonts.syne(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    _StatBox(
                      label: 'Total Solved',
                      value: userProvider.totalProblemsSolved.toString(),
                      icon: Icons.code,
                      color: gold,
                    ),
                    _StatBox(
                      label: 'Longest Streak',
                      value: userProvider.longestStreak.toString(),
                      icon: Icons.emoji_events,
                      color: const Color(0xFFF0A060),
                    ),
                    _StatBox(
                      label: 'Jobs Applied',
                      value:
                          userProvider.userStats?.appsCount.toString() ?? '0',
                      icon: Icons.mail,
                      color: cyan,
                    ),
                    _StatBox(
                      label: 'Roadmap Done',
                      value:
                          '${(userProvider.getRoadmapCompletionPercent() * 100).toStringAsFixed(0)}%',
                      icon: Icons.map,
                      color: purple,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ==================== MOTIVATIONAL SECTION ====================
                if (userProvider.areAllTasksCompleted())
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [green.withOpacity(0.2), cyan.withOpacity(0.2)],
                      ),
                      border: Border.all(color: green, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.celebration, color: green, size: 32),
                            const SizedBox(width: 8),
                            Icon(Icons.celebration, color: gold, size: 32),
                            const SizedBox(width: 8),
                            Icon(Icons.celebration, color: green, size: 32),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'All Done! 🎉',
                          style: GoogleFonts.syne(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You\'ve completed all tasks today. Rest up — you\'re building an unstoppable habit!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.robotoMono(
                            fontSize: 12,
                            color: Colors.white70,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Current Streak: ${userProvider.currentStreak} days 🔥',
                          style: GoogleFonts.syne(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFF0A060),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      border: Border.all(color: Colors.white12, width: 1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.trending_up, color: cyan, size: 32),
                        const SizedBox(height: 12),
                        Text(
                          'Keep Going! 💪',
                          style: GoogleFonts.syne(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: cyan,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Complete ${(userProvider.dailyTasks?.where((t) => !t.isCompleted).length ?? 0)} more tasks to finish today.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.robotoMono(
                            fontSize: 11,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.robotoMono(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.syne(fontSize: 10, color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}
