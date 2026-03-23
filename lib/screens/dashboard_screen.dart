import 'package:flutter/material.dart';
import '../screens/stats_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _selectedNavIndex = 0;

  // Mock state
  int totalXP = 0;
  int activeHabits = 0;
  int bestStreak = 0;
  final List<Habit> habits = [];

  late AnimationController _entryController;
  late Animation<double> _entryAnimation;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _entryAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    );
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _entryAnimation,
          builder: (context, child) {
            return FadeTransition(
              opacity: _entryAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.03),
                  end: Offset.zero,
                ).animate(_entryAnimation),
                child: child,
              ),
            );
          },
          child: _buildDashboardContent(),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildDashboardContent() {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverToBoxAdapter(child: _buildAppBar()),
        SliverToBoxAdapter(child: _buildWelcomeSection()),
        // Stats row
        SliverToBoxAdapter(child: _buildStatsRow()),
        // Today's Missions
        SliverToBoxAdapter(child: _buildMissionsHeader()),
        // Missions content
        if (habits.isEmpty)
          SliverToBoxAdapter(child: _buildEmptyState())
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildHabitCard(habits[index]),
              childCount: habits.length,
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showDrawer(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.menu_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF6C63FF).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Text(
              'DASHBOARD',
              style: TextStyle(
                color: Color(0xFF6C63FF),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _showNotifications(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back,',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'User Name',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          _StatCard(
            label: 'TOTAL XP',
            value: totalXP.toString(),
            accentColor: const Color(0xFF6C63FF),
          ),
          const SizedBox(width: 12),
          _StatCard(
            label: 'ACTIVE HABITS',
            value: activeHabits.toString(),
            accentColor: const Color(0xFF00D4AA),
          ),
          const SizedBox(width: 12),
          _StatCard(
            label: 'BEST STREAK',
            value: bestStreak.toString(),
            accentColor: const Color(0xFFFFB347),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionsHeader() {
    final now = DateTime.now();
    final dateStr =
        '${now.month}/${now.day}/${now.year}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "TODAY'S MISSIONS",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          Text(
            dateStr,
            style: TextStyle(
              color: Colors.white.withOpacity(0.35),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_task_rounded,
                color: Color(0xFF6C63FF),
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No habits yet!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first habit mission to get started',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.45),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => _createHabit(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'CREATE HABIT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitCard(Habit habit) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: habit.isCompleted
                ? const Color(0xFF00D4AA).withOpacity(0.4)
                : Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => _toggleHabit(habit),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: habit.isCompleted
                      ? const Color(0xFF00D4AA)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: habit.isCompleted
                        ? const Color(0xFF00D4AA)
                        : Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: habit.isCompleted
                    ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 16)
                    : null,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: TextStyle(
                      color: habit.isCompleted
                          ? Colors.white.withOpacity(0.4)
                          : Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      decoration: habit.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (habit.xpReward > 0)
                    Text(
                      '+${habit.xpReward} XP',
                      style: TextStyle(
                        color: const Color(0xFF6C63FF).withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            Expanded (
              child: ListTile(
              trailing: PopupMenuButton<String>(
                icon: Icon(Icons.more_horiz),

                onSelected: (value) {
                  if (value == 'delete') {
                    _deleteHabit(habit);
                  }
                },

                itemBuilder: (context) => [
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.red),
                SizedBox(width: 8),
                Text('Delete'),
              ],
            ),
          ),
        ], 
              ),
            )),
            const SizedBox(width: 40, height: 40,),
            Text(
              habit.streak > 0 ? '🔥 ${habit.streak}' : '',
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    const items = [
      _NavItem(icon: Icons.add_circle_outline_rounded, label: 'ADD'),
      _NavItem(icon: Icons.bar_chart_rounded, label: 'STATS'),
      _NavItem(icon: Icons.explore_outlined, label: 'QUEST'),
      _NavItem(icon: Icons.smart_toy_outlined, label: 'AI'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141420),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = _selectedNavIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedNavIndex = index);
                  if (index == 0) _createHabit();
                  if (index == 1) {Navigator.push(
                    context,
                    PageRouteBuilder(
                    pageBuilder: (_, animation, __) => StatsScreen(
                      totalXP: totalXP,
                      bestStreak: bestStreak,
                      habits: habits
                      .map((h) => HabitStat(
                      name: h.name,
                      streak: h.streak,
                      isCompleted: h.isCompleted,
                      // Replace 0.0 with real weekly tracking when you
                      // add persistence (e.g. Hive / SharedPreferences)
                      weeklyCompletionRate: h.isCompleted ? 1.0 : 0.0,
                      ))
                      .toList(),
                      ),
                      transitionsBuilder: (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
                      transitionDuration: const Duration(milliseconds: 300),
                      ),
                      ).then((_) => setState(() => _selectedNavIndex = 0));}
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF6C63FF).withOpacity(0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[index].icon,
                        color: isSelected
                            ? const Color(0xFF6C63FF)
                            : Colors.white.withOpacity(0.4),
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[index].label,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF6C63FF)
                              : Colors.white.withOpacity(0.4),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  void _createHabit() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _CreateHabitSheet(
        onCreate: (name) {
          setState(() {
            habits.add(Habit(
              name: name,
              xpReward: 50,
              streak: 0,
            ));
            activeHabits = habits.length;
          });
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _toggleHabit(Habit habit) {
    setState(() {
      habit.isCompleted = !habit.isCompleted;
      if (habit.isCompleted) {
        totalXP += habit.xpReward;
        habit.streak += 1;
        if (habit.streak > bestStreak) bestStreak = habit.streak;
      } else {
        totalXP -= habit.xpReward;
        if (habit.streak > 0) habit.streak -= 1;
      }
    });
  }

  void _deleteHabit(Habit habit) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Mission?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        content: Text(
          'Are you sure want to delete "${habit.name}"? This cannot be undone.',
          style: TextStyle(color: Colors.white.withOpacity(0.6), height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'CANCEL',
              style: TextStyle(color: Colors.white.withOpacity(0.4),
              fontWeight: FontWeight.w700, letterSpacing: 1.0, )
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (habit.isCompleted) totalXP -= habit.xpReward;
                habits.remove(habit);
                activeHabits = habits.length;
                bestStreak = habits.isEmpty
                  ? 0
                  : habits.map((h) => h.streak).reduce((a,b) => a > b ? a : b);
              });
              Navigator.pop(ctx);
            },
            child: const Text(
              'DELETE',
              style: TextStyle(color: Color(0xFFFF6B6B),
              fontWeight: FontWeight.w700, letterSpacing: 1.0),
            ),
          ),
        ],
      ),
    );
  }

  void _showDrawer() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Menu coming soon!')),
    );
  }

  void _showNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No new notifications')),
    );
  }
}

// ─── Data Models ───────────────────────────────────────────────────────────────

class Habit {
  final String name;
  final int xpReward;
  int streak;
  bool isCompleted;

  Habit({
    required this.name,
    required this.xpReward,
    this.streak = 0,
    this.isCompleted = false,
  });
}

// ─── Sub-widgets ───────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color accentColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: accentColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: accentColor,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: accentColor.withOpacity(0.6),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _CreateHabitSheet extends StatefulWidget {
  final Function(String) onCreate;
  const _CreateHabitSheet({required this.onCreate});

  @override
  State<_CreateHabitSheet> createState() => _CreateHabitSheetState();
}

class _CreateHabitSheetState extends State<_CreateHabitSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New Habit Mission',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'e.g. Meditate for 10 minutes',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.07),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  widget.onCreate(_controller.text.trim());
                }
              },
              child: const Text(
                'CREATE MISSION',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
