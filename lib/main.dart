import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:watchmans_gazette/screens/landing_page.dart';
import 'package:watchmans_gazette/firebase_options.dart';
import 'package:watchmans_gazette/theme/app_color.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Watchman\'s Gazette',
      home: const LandingPage(),

      theme: ThemeData(
        fontFamily: 'Metropolis',

        colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            tertiary: AppColors.tertiary,
            error: AppColors.error,
        ),

        cardColor: AppColors.tertiary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
