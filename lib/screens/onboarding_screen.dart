import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Welcome to Habit Quest',
      subtitle: 'Transform your daily routines\ninto epic missions',
      illustrationIcon: Icons.terrain_rounded,
      illustrationLabel: 'Person climbing mountain',
      accentColor: const Color(0xFF6C63FF),
      gradientColors: [const Color(0xFF1A1A3E), const Color(0xFF0F0F1A)],
    ),
    OnboardingData(
      title: 'AI Habit Buddy',
      subtitle: 'Get personalized coaching and\ndaily micro-goals tailored to you',
      illustrationIcon: Icons.smart_toy_rounded,
      illustrationLabel: 'Chat bot helper',
      accentColor: const Color(0xFF00D4AA),
      gradientColors: [const Color(0xFF0D2B26), const Color(0xFF0F0F1A)],
    ),
    OnboardingData(
      title: 'Level Up Your Life',
      subtitle: 'Earn XP, unlock badges, and\nbuild streaks as you complete habits',
      illustrationIcon: Icons.emoji_events_rounded,
      illustrationLabel: 'Level up animation',
      accentColor: const Color(0xFFFFB347),
      gradientColors: [const Color(0xFF2B1E00), const Color(0xFF0F0F1A)],
    ),
    OnboardingData(
      title: 'Track Your Progress',
      subtitle: 'Visualize patterns, celebrate\nwins, and stay motivated',
      illustrationIcon: Icons.bar_chart_rounded,
      illustrationLabel: 'Charts and graphs',
      accentColor: const Color(0xFFFF6B9D),
      gradientColors: [const Color(0xFF2B0A1A), const Color(0xFF0F0F1A)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToDashboard();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, _) => const DashboardScreen(),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              _fadeController.reset();
              _fadeController.forward();
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _OnboardingPage(
                data: _pages[index],
                fadeAnimation: _fadeAnimation,
              );
            },
          ),
          // Bottom controls overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomControls(),
          ),
          // Top skip button (only show if not last page)
          if (_currentPage < _pages.length - 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 24,
              child: TextButton(
                onPressed: _navigateToDashboard,
                child: Text(
                  'SKIP',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    final currentData = _pages[_currentPage];
    return Container(
      padding: EdgeInsets.only(
        left: 32,
        right: 32,
        top: 24,
        bottom: MediaQuery.of(context).padding.bottom + 32,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            const Color(0xFF0F0F1A).withOpacity(0.95),
            const Color(0xFF0F0F1A),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == _currentPage ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == _currentPage
                      ? currentData.accentColor
                      : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 28),
          // Navigation buttons
          Row(
            children: [
              if (_currentPage > 0)
                Expanded(
                  flex: 1,
                  child: _NavButton(
                    label: '< BACK',
                    isPrimary: false,
                    onTap: _previousPage,
                    accentColor: currentData.accentColor,
                  ),
                )
              else
                const Expanded(flex: 1, child: SizedBox()),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: _NavButton(
                  label: _currentPage == _pages.length - 1
                      ? 'GET STARTED >'
                      : 'NEXT >',
                  isPrimary: true,
                  onTap: _nextPage,
                  accentColor: currentData.accentColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  final Animation<double> fadeAnimation;

  const _OnboardingPage({
    required this.data,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: data.gradientColors,
        ),
      ),
      child: SafeArea(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                // Illustration box
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: data.accentColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.8,
                        colors: [
                          data.accentColor.withOpacity(0.12),
                          data.accentColor.withOpacity(0.03),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          data.illustrationIcon,
                          size: 80,
                          color: data.accentColor.withOpacity(0.8),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '[ILLUSTRATION: ${data.illustrationLabel}]',
                          style: TextStyle(
                            color: data.accentColor.withOpacity(0.4),
                            fontSize: 11,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Title
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        data.subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.55),
                          fontSize: 16,
                          height: 1.6,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                // Space for the bottom controls overlay
                const SizedBox(height: 140),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;
  final Color accentColor;

  const _NavButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isPrimary ? accentColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isPrimary
              ? null
              : Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isPrimary ? Colors.white : Colors.white.withOpacity(0.6),
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final IconData illustrationIcon;
  final String illustrationLabel;
  final Color accentColor;
  final List<Color> gradientColors;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.illustrationIcon,
    required this.illustrationLabel,
    required this.accentColor,
    required this.gradientColors,
  });
}
