import 'package:flutter/material.dart';

class QuestScreen extends StatefulWidget {
  final int userXP;
  final int bestStreak;

  const QuestScreen({
    Key? key,
    required this.userXP,
    required this.bestStreak,
  }) : super(key: key);

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> with TickerProviderStateMixin {
  late List<Milestone> milestones;
  late List<Badge> earnedBadges;
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
    _initializeMilestones();
    _calculateEarnedBadges();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  void _initializeMilestones() {
    milestones = [
      // XP Milestones
      Milestone(
        id: 'xp_100',
        title: 'First Steps',
        description: 'Earn 100 XP',
        targetValue: 100,
        currentValue: widget.userXP,
        type: MilestoneType.xp,
        badge: Badge(
          name: '100 XP Badge',
          icon: Icons.flash_on,
          color: const Color(0xFFFFB947),
          challenge: 'Complete 3 activities in one day!',
        ),
      ),
      Milestone(
        id: 'xp_500',
        title: 'Rising Star',
        description: 'Earn 500 XP',
        targetValue: 500,
        currentValue: widget.userXP,
        type: MilestoneType.xp,
        badge: Badge(
          name: '500 XP Badge',
          icon: Icons.star,
          color: const Color(0xFF4ECDC4),
          challenge: 'Maintain a 7-day streak!',
        ),
      ),
      Milestone(
        id: 'xp_1000',
        title: 'XP Master',
        description: 'Earn 1,000 XP',
        targetValue: 1000,
        currentValue: widget.userXP,
        type: MilestoneType.xp,
        badge: Badge(
          name: '1,000 XP Badge',
          icon: Icons.grade,
          color: const Color(0xFF9C27B0),
          challenge: 'Achieve a 14-day streak!',
        ),
      ),
      Milestone(
        id: 'xp_5000',
        title: 'Legend',
        description: 'Earn 5,000 XP',
        targetValue: 5000,
        currentValue: widget.userXP,
        type: MilestoneType.xp,
        badge: Badge(
          name: '5,000 XP Badge',
          icon: Icons.workspace_premium,
          color: const Color(0xFFFF6B6B),
          challenge: 'Guide a friend to 500 XP!',
        ),
      ),
      // Streak Milestones
      Milestone(
        id: 'streak_7',
        title: 'Week Warrior',
        description: 'Achieve a 7-day streak',
        targetValue: 7,
        currentValue: widget.bestStreak,
        type: MilestoneType.streak,
        badge: Badge(
          name: '7-Day Streak Badge',
          icon: Icons.local_fire_department,
          color: const Color(0xFFFF9800),
          challenge: 'Continue your streak to 14 days!',
        ),
      ),
      Milestone(
        id: 'streak_14',
        title: 'Biweekly Beast',
        description: 'Achieve a 14-day streak',
        targetValue: 14,
        currentValue: widget.bestStreak,
        type: MilestoneType.streak,
        badge: Badge(
          name: '14-Day Streak Badge',
          icon: Icons.whatshot,
          color: const Color(0xFFFF5722),
          challenge: 'Reach a 30-day streak!',
        ),
      ),
      Milestone(
        id: 'streak_30',
        title: 'Consistency Champion',
        description: 'Achieve a 30-day streak',
        targetValue: 30,
        currentValue: widget.bestStreak,
        type: MilestoneType.streak,
        badge: Badge(
          name: '30-Day Streak Badge',
          icon: Icons.emoji_events,
          color: const Color(0xFFFFD700),
          challenge: 'Aim for 50 days of perfection!',
        ),
      ),
      Milestone(
        id: 'streak_50',
        title: 'Unstoppable',
        description: 'Achieve a 50-day streak',
        targetValue: 50,
        currentValue: widget.bestStreak,
        type: MilestoneType.streak,
        badge: Badge(
          name: '50-Day Streak Badge',
          icon: Icons.star_rate,
          color: const Color(0xFF00D4AA),
          challenge: 'Inspire others to build their streaks!',
        ),
      ),
    ];
  }

  void _calculateEarnedBadges() {
    earnedBadges = milestones
        .where((milestone) => milestone.isCompleted)
        .map((milestone) => milestone.badge)
        .toList();
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF0F0F1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '⚔️ Quests & Milestones',
                style: TextStyle(
                  color: Color(0xFF00D4AA),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFF00D4AA),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard(
                icon: Icons.flash_on,
                label: 'Total XP',
                value: widget.userXP.toString(),
                color: const Color(0xFF00D4AA),
              ),
              _buildStatCard(
                icon: Icons.local_fire_department,
                label: 'Best Streak',
                value: '${widget.bestStreak} days',
                color: const Color(0xFFFF6B6B),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Center(
            child: Text(
              'Badges Earned: ${earnedBadges.length}/${milestones.length}',
              style: const TextStyle(
                color: Color(0xFF00D4AA),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarnedBadgesSection() {
    if (earnedBadges.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⭐ Earned Badges',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00D4AA),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: earnedBadges.length,
              itemBuilder: (context, index) {
                final badge = earnedBadges[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: _buildBadgeDisplay(badge),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestonesSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎯 Quest Milestones',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00D4AA),
            ),
          ),
          const SizedBox(height: 15),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: milestones.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _buildMilestoneCard(milestones[index]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        child: FadeTransition(
          opacity: _entryAnimation,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildEarnedBadgesSection()),
              SliverToBoxAdapter(child: _buildMilestonesSection()),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1),
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF999999),
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeDisplay(Badge badge) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: badge.color.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: badge.color, width: 2),
          ),
          child: Icon(
            badge.icon,
            color: badge.color,
            size: 32,
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: Text(
            badge.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMilestoneCard(Milestone milestone) {
    final isCompleted = milestone.isCompleted;
    final progress = (milestone.currentValue / milestone.targetValue)
        .clamp(0.0, 1.0);

    return GestureDetector(
      onTap: isCompleted
          ? () => _showCompletionDialog(milestone)
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCompleted
                ? milestone.badge.color
                : const Color(0xFF333333),
            width: isCompleted ? 2 : 1,
          ),
          color: isCompleted
              ? milestone.badge.color.withOpacity(0.08)
              : const Color(0xFF1A1A2E),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isCompleted)
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: milestone.badge.color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      milestone.badge.icon,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        milestone.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isCompleted
                              ? milestone.badge.color
                              : Colors.white,
                        ),
                      ),
                      Text(
                        milestone.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  const Text(
                    '✓',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF00D4AA),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: const Color(0xFF333333),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isCompleted
                      ? const Color(0xFF00D4AA)
                      : milestone.badge.color,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${milestone.currentValue} / ${milestone.targetValue}',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF999999),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCompletionDialog(Milestone milestone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: milestone.badge.color.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: milestone.badge.color, width: 2),
              ),
              child: Icon(
                milestone.badge.icon,
                color: milestone.badge.color,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Badge Unlocked!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00D4AA),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              milestone.badge.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF00D4AA).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF00D4AA), width: 1),
              ),
              child: Column(
                children: [
                  const Text(
                    '💪 Your Next Challenge:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00D4AA),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    milestone.badge.challenge,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Keep up the amazing work! 🚀',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Dismiss',
              style: TextStyle(color: Color(0xFF00D4AA)),
            ),
          ),
        ],
      ),
    );
  }
}

class Milestone {
  final String id;
  final String title;
  final String description;
  final int targetValue;
  final int currentValue;
  final MilestoneType type;
  final Badge badge;

  Milestone({
    required this.id,
    required this.title,
    required this.description,
    required this.targetValue,
    required this.currentValue,
    required this.type,
    required this.badge,
  });

  bool get isCompleted => currentValue >= targetValue;
}

class Badge {
  final String name;
  final IconData icon;
  final Color color;
  final String challenge;

  Badge({
    required this.name,
    required this.icon,
    required this.color,
    required this.challenge,
  });
}

enum MilestoneType {
  xp,
  streak,
}
