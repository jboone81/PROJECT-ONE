import 'package:flutter/material.dart';
import 'dart:math' as math;

// ─── Pass your real habits list in from DashboardScreen ───────────────────────
class StatsScreen extends StatefulWidget {
  final List<HabitStat> habits;
  final int totalXP;
  final int bestStreak;

  const StatsScreen({
    super.key,
    required this.habits,
    required this.totalXP,
    required this.bestStreak,
  });

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _entryAnimation;

  // Generate mock weekly data for demo — replace with real data from your store
  late final List<DayRecord> _weekRecords;
  late final List<XpPoint> _xpHistory;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _entryAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    );
    _entryController.forward();
    _weekRecords = _buildWeekRecords();
    _xpHistory = _buildXpHistory();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  // ─── Mock data builders (swap with real persistence) ─────────────────────

  List<DayRecord> _buildWeekRecords() {
    final rng = math.Random(42);
    final today = DateTime.now();
    return List.generate(7, (i) {
      final date = today.subtract(Duration(days: 6 - i));
      final total = widget.habits.isEmpty ? 3 : widget.habits.length;
      final completed = i == 6
          ? widget.habits.where((h) => h.isCompleted).length
          : rng.nextInt(total + 1);
      return DayRecord(
        date: date,
        completed: completed,
        total: total == 0 ? 3 : total,
      );
    });
  }

  List<XpPoint> _buildXpHistory() {
    final rng = math.Random(7);
    int running = math.max(0, widget.totalXP - rng.nextInt(300) - 100);
    final today = DateTime.now();
    return List.generate(7, (i) {
      final date = today.subtract(Duration(days: 6 - i));
      if (i == 6) return XpPoint(date: date, xp: widget.totalXP);
      running += rng.nextInt(60);
      return XpPoint(date: date, xp: running);
    });
  }

  // ─── Computed stats ───────────────────────────────────────────────────────

  int get _currentStreak {
    int streak = 0;
    for (int i = _weekRecords.length - 1; i >= 0; i--) {
      if (_weekRecords[i].completionRate >= 0.5) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  double get _weekCompletionRate {
    if (_weekRecords.isEmpty) return 0;
    return _weekRecords.map((r) => r.completionRate).reduce((a, b) => a + b) /
        _weekRecords.length;
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
              SliverToBoxAdapter(child: _buildStreakCards()),
              SliverToBoxAdapter(child: _buildHeatmapSection()),
              SliverToBoxAdapter(child: _buildXpChartSection()),
              SliverToBoxAdapter(child: _buildHabitBreakdown()),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          if (Navigator.canPop(context))
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 16),
              ),
            ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF00D4AA).withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: const Color(0xFF00D4AA).withOpacity(0.3), width: 1),
            ),
            child: const Text(
              'STATS',
              style: TextStyle(
                color: Color(0xFF00D4AA),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const Spacer(),
          Text(
            'This Week',
            style: TextStyle(
              color: Colors.white.withOpacity(0.35),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Streak + XP summary cards ────────────────────────────────────────────

  Widget _buildStreakCards() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Row(
        children: [
          _SummaryCard(
            label: 'CURRENT STREAK',
            value: '${_currentStreak}d',
            icon: Icons.local_fire_department_rounded,
            accentColor: const Color(0xFFFFB347),
          ),
          const SizedBox(width: 12),
          _SummaryCard(
            label: 'BEST STREAK',
            value: '${widget.bestStreak}d',
            icon: Icons.emoji_events_rounded,
            accentColor: const Color(0xFF6C63FF),
          ),
          const SizedBox(width: 12),
          _SummaryCard(
            label: 'TOTAL XP',
            value: widget.totalXP.toString(),
            icon: Icons.bolt_rounded,
            accentColor: const Color(0xFF00D4AA),
          ),
        ],
      ),
    );
  }

  // ─── Weekly Heatmap ───────────────────────────────────────────────────────

  Widget _buildHeatmapSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: 'Weekly Heatmap',
            subtitle:
                '${(_weekCompletionRate * 100).toStringAsFixed(0)}% avg completion',
          ),
          const SizedBox(height: 16),
          _WeekHeatmap(records: _weekRecords),
          const SizedBox(height: 12),
          _buildHeatmapLegend(),
        ],
      ),
    );
  }

  Widget _buildHeatmapLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Less',
            style: TextStyle(
                color: Colors.white.withOpacity(0.3), fontSize: 11)),
        const SizedBox(width: 6),
        ...List.generate(5, (i) {
          return Container(
            width: 14,
            height: 14,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: _heatColor(i / 4),
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
        const SizedBox(width: 6),
        Text('More',
            style: TextStyle(
                color: Colors.white.withOpacity(0.3), fontSize: 11)),
      ],
    );
  }

  Color _heatColor(double rate) {
    if (rate == 0) return Colors.white.withOpacity(0.06);
    final colors = [
      const Color(0xFF1A3A2E),
      const Color(0xFF0D6E4E),
      const Color(0xFF00A876),
      const Color(0xFF00D4AA),
    ];
    final idx = ((rate * (colors.length - 1)).clamp(0, colors.length - 1))
        .floor();
    return colors[idx];
  }

  // ─── XP Line Chart ────────────────────────────────────────────────────────

  Widget _buildXpChartSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: 'XP Over Time',
            subtitle: '+${_xpHistory.last.xp - _xpHistory.first.xp} XP this week',
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: _XpLineChart(
              points: _xpHistory,
              accentColor: const Color(0xFF6C63FF),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Per-habit breakdown ──────────────────────────────────────────────────

  Widget _buildHabitBreakdown() {
    if (widget.habits.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: 'Habit Breakdown', subtitle: 'This week'),
          const SizedBox(height: 16),
          ...widget.habits.map((h) => _HabitBreakdownRow(habit: h)),
        ],
      ),
    );
  }
}

// ─── Weekly Heatmap Widget ────────────────────────────────────────────────────

class _WeekHeatmap extends StatelessWidget {
  final List<DayRecord> records;
  const _WeekHeatmap({required this.records});

  Color _heatColor(double rate) {
    if (rate == 0) return Colors.white.withOpacity(0.06);
    if (rate < 0.25) return const Color(0xFF1A3A2E);
    if (rate < 0.5) return const Color(0xFF0D6E4E);
    if (rate < 0.75) return const Color(0xFF00A876);
    return const Color(0xFF00D4AA);
  }

  @override
  Widget build(BuildContext context) {
    const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
      child: Column(
        children: [
          // Day labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dayLabels
                .map((d) => SizedBox(
                      width: 36,
                      child: Text(
                        d,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.35),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
          // Heatmap cells
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(records.length, (i) {
              final rec = records[i];
              final isToday = i == records.length - 1;
              return Tooltip(
                message:
                    '${rec.completed}/${rec.total} completed',
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300 + i * 60),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _heatColor(rec.completionRate),
                    borderRadius: BorderRadius.circular(8),
                    border: isToday
                        ? Border.all(
                            color: const Color(0xFF00D4AA), width: 1.5)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${rec.completed}',
                      style: TextStyle(
                        color: rec.completionRate > 0.4
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          // Date row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: records
                .map((r) => SizedBox(
                      width: 36,
                      child: Text(
                        '${r.date.day}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.2),
                          fontSize: 10,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ─── XP Line Chart ────────────────────────────────────────────────────────────

class _XpLineChart extends StatefulWidget {
  final List<XpPoint> points;
  final Color accentColor;
  const _XpLineChart({required this.points, required this.accentColor});

  @override
  State<_XpLineChart> createState() => _XpLineChartState();
}

class _XpLineChartState extends State<_XpLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawController;
  late Animation<double> _drawAnimation;

  @override
  void initState() {
    super.initState();
    _drawController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _drawAnimation = CurvedAnimation(
      parent: _drawController,
      curve: Curves.easeInOutCubic,
    );
    _drawController.forward();
  }

  @override
  void dispose() {
    _drawController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
      child: AnimatedBuilder(
        animation: _drawAnimation,
        builder: (context, _) {
          return CustomPaint(
            painter: _LinePainter(
              points: widget.points,
              progress: _drawAnimation.value,
              accentColor: widget.accentColor,
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<XpPoint> points;
  final double progress;
  final Color accentColor;

  _LinePainter({
    required this.points,
    required this.progress,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    const padLeft = 40.0;
    const padRight = 16.0;
    const padTop = 12.0;
    const padBottom = 28.0;

    final drawW = size.width - padLeft - padRight;
    final drawH = size.height - padTop - padBottom;

    final minXp = points.map((p) => p.xp).reduce(math.min).toDouble();
    final maxXp = points.map((p) => p.xp).reduce(math.max).toDouble();
    final range = (maxXp - minXp).clamp(1, double.infinity);

    Offset toOffset(int i) {
      final x = padLeft + (i / (points.length - 1)) * drawW;
      final y = padTop + drawH - ((points[i].xp - minXp) / range) * drawH;
      return Offset(x, y);
    }

    // Grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..strokeWidth = 1;
    for (int i = 0; i <= 3; i++) {
      final y = padTop + (drawH / 3) * i;
      canvas.drawLine(Offset(padLeft, y), Offset(size.width - padRight, y),
          gridPaint);
    }

    // Y-axis labels
    final labelStyle = TextStyle(
      color: Colors.white.withOpacity(0.3),
      fontSize: 10,
    );
    for (int i = 0; i <= 3; i++) {
      final y = padTop + (drawH / 3) * i;
      final val = maxXp - (range / 3) * i;
      final tp = TextPainter(
        text: TextSpan(text: val.toInt().toString(), style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    // Build path up to progress
    final totalPoints = points.length;
    final visibleCount =
        ((totalPoints - 1) * progress).floor() + 1;

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < visibleCount && i < totalPoints; i++) {
      final o = toOffset(i);
      if (i == 0) {
        path.moveTo(o.dx, o.dy);
        fillPath.moveTo(padLeft, padTop + drawH);
        fillPath.lineTo(o.dx, o.dy);
      } else {
        // Smooth curve
        final prev = toOffset(i - 1);
        final cpX = (prev.dx + o.dx) / 2;
        path.cubicTo(cpX, prev.dy, cpX, o.dy, o.dx, o.dy);
        fillPath.cubicTo(cpX, prev.dy, cpX, o.dy, o.dx, o.dy);
      }
    }

    // Fill gradient
    fillPath.lineTo(toOffset(visibleCount - 1).dx, padTop + drawH);
    fillPath.close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          accentColor.withOpacity(0.25),
          accentColor.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, padTop, size.width, drawH));
    canvas.drawPath(fillPath, fillPaint);

    // Line
    final linePaint = Paint()
      ..color = accentColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);

    // Dots + day labels
    const dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    for (int i = 0; i < visibleCount && i < totalPoints; i++) {
      final o = toOffset(i);
      final isLast = i == totalPoints - 1;

      // Dot
      canvas.drawCircle(
          o,
          isLast ? 5 : 3.5,
          Paint()..color = accentColor);
      canvas.drawCircle(
          o,
          isLast ? 3 : 2,
          Paint()..color = const Color(0xFF0F0F1A));

      // Day label
      final tp = TextPainter(
        text: TextSpan(
          text: dayLabels[i % dayLabels.length],
          style: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas,
          Offset(o.dx - tp.width / 2, padTop + drawH + 8));
    }
  }

  @override
  bool shouldRepaint(_LinePainter old) =>
      old.progress != progress || old.points != points;
}

// ─── Habit Breakdown Row ──────────────────────────────────────────────────────

class _HabitBreakdownRow extends StatelessWidget {
  final HabitStat habit;
  const _HabitBreakdownRow({required this.habit});

  @override
  Widget build(BuildContext context) {
    final rate = habit.weeklyCompletionRate;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: Colors.white.withOpacity(0.07), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: rate,
                    minHeight: 6,
                    backgroundColor: Colors.white.withOpacity(0.08),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      rate >= 0.75
                          ? const Color(0xFF00D4AA)
                          : rate >= 0.4
                              ? const Color(0xFFFFB347)
                              : const Color(0xFFFF6B6B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(rate * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '🔥 ${habit.streak}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Reusable sub-widgets ─────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionTitle({required this.title, this.subtitle = ''});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(width: 10),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.35),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ]
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border:
              Border.all(color: accentColor.withOpacity(0.2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: accentColor, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: accentColor,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: accentColor.withOpacity(0.55),
                fontSize: 8.5,
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

// ─── Data models ──────────────────────────────────────────────────────────────

class DayRecord {
  final DateTime date;
  final int completed;
  final int total;

  DayRecord({
    required this.date,
    required this.completed,
    required this.total,
  });

  double get completionRate =>
      total == 0 ? 0 : (completed / total).clamp(0.0, 1.0);
}

class XpPoint {
  final DateTime date;
  final int xp;
  XpPoint({required this.date, required this.xp});
}

class HabitStat {
  final String name;
  final int streak;
  final bool isCompleted;
  final double weeklyCompletionRate;

  HabitStat({
    required this.name,
    required this.streak,
    required this.isCompleted,
    this.weeklyCompletionRate = 0.0,
  });
}
