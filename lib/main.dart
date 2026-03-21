import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const HabitQuestApp());
}

class HabitQuestApp extends StatelessWidget {
  const HabitQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Quest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A1A2E),
          brightness: Brightness.dark,
        ),
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: const Color(0xFF0F0F1A),
      ),
      home: const OnboardingScreen(),
    );
  }
}
