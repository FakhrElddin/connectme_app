import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:connectme_app/firebase_options.dart';
import 'package:connectme_app/presentation/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: const LoginScreen(),
    );
  }
}

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.backgroundColor,
);
