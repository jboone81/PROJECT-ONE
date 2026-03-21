Habit Quest 🎮
A gamified habit tracking app built with Flutter.

Project Structure

lib/
├── main.dart                      # App entry point
└── screens/
    ├── onboarding_screen.dart     # 4-page onboarding flow
    └── dashboard_screen.dart      # Main dashboard with stats & missions

Screens
Onboarding (4 screens):

 1. Welcome to Habit Quest — intro with mountain illustration
 2. AI Habit Buddy — personalized coaching pitch
 3. Level Up Your Life — XP & badges explanation
 4. Track Your Progress — charts & motivation

Each screen has:

 * Animated illustration placeholder
 * BACK / NEXT navigation
 * SKIP button (top right)
 * Page indicator dots that animate to the current accent color

Dashboard:

 * Welcome header with username
 * 3 stat cards: Total XP · Active Habits · Best Streak
 * Today's Missions section with date
 * Empty state with CREATE HABIT CTA
 * Bottom nav: ADD · STATS · QUEST · AI

Functionality:

 * Tapping ADD (or CREATE HABIT) opens a bottom sheet to add a new habit
 * Tapping the circle on a habit toggles completion, awarding XP and incrementing streak
 * Stats update live as habits are completed

Setup:
 - flutter pub get
 - flutter run

Customization:

 - Colors are defined inline — look for Color(0xFF6C63FF) etc. to remap the palette
 - Illustration placeholders use Flutter icons — swap with your own SVG/Lottie assets
 - OnboardingData list in onboarding_screen.dart controls all onboarding content
