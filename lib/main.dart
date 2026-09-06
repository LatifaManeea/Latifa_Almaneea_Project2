import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latifa_almaneea_project2/const/app_color.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const QuizzicalApp());
}

class QuizzicalApp extends StatelessWidget {
  const QuizzicalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        textTheme: GoogleFonts.nunitoTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}