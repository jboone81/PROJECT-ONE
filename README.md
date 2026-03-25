Habit Quest 🎮
A gamified habit tracking app built with Flutter.

Project Structure

lib/
|__ main.dart                      # App entry point
|__ database_helper.dart 
|__ screens/
    |__ onboarding_screen.dart     # 4-page onboarding flow
    |__ dashboard_screen.dart      # Main dashboard with stats & missions
    |__ stats_screen.dart
    |__ quest_screen.dart 
    |__ ai_screen.dart
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
The main screen of the app. Displays the user's daily habits and overall stats.

Features:

    Welcome section with the user's name
    Stats row showing Total XP, Active Habits, and Best Streak
    Today's Missions list — displays all habits with completion toggles
    Empty state UI when no habits have been created yet
    Create habit bottom sheet — allows users to add new habit missions
    Delete habit with a confirmation dialog
    Bottom navigation bar with ADD, STATS, QUEST, and AI buttons
Database interactions:

    Loads all habits and stats from SQLite on startup
    Inserts new habits into the habits table on creation
    Updates habit completion status and streak in the habits table on toggle
    Deletes habits and their history from the database on deletion
    Logs every habit completion to the habit_history table for stats tracking


Stats:

Displays the user's weekly performance data and habit breakdown.

Features:

    Current Streak, Best Streak, and Total XP summary cards
    Weekly Heatmap — shows daily habit completion rates over the last 7 days using color intensity
    XP Over Time — animated line chart showing cumulative XP gained across the week
    Habit Breakdown — per-habit progress bars showing weekly completion rates and streaks
    Loading spinner while data is being fetched from the database
Database interactions:

    Queries habit_history table for real weekly completion data
    Queries habit_history for cumulative XP per day
    Queries per-habit weekly completion rates to populate the breakdown section

AI:
An AI-powered chat interface where users can talk to their personal "AI Quest Guide".

Features:

    Chat UI with message bubbles for user and AI responses
    Animated typing indicator (bouncing dots) while waiting for a response
    Quick suggestion chips on first load (e.g. "How am I doing?", "Suggest a new habit")
    Personalized welcome message based on the user's current habits and XP
    The AI knows the user's habits, streaks, completion rates, and XP — giving personalized advice
    Powered by Google Gemini API
AI behavior:

    Acts as a motivating habit coach with light RPG/quest themed language
    Gives practical, actionable habit advice based on the user's real data
    Maintains conversation history for context across messages

Database_helper:
Not a screen, but the backbone of the app's local data persistence.

Tables:

    habits — stores all user habits (id, name, xp_reward, streak, is_completed, created_at)
    app_stats — stores global stats (total_xp, best_streak)
    habit_history — logs every habit completion event with a timestamp
Key methods:

insertHabit() — adds a new habit
getAllHabits() — loads all habits on startup
updateHabit() — saves habit changes
deleteHabit() — removes a habit and its history
insertHistoryEntry() — logs a completion event
getWeeklyCompletions() — returns real daily completion data for the heatmap
getWeeklyXP() — returns cumulative XP per day for the line chart
getHabitWeeklyRates() — returns per-habit completion rates for the breakdown
getAppStats() / updateAppStats() — reads and saves global stats


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
