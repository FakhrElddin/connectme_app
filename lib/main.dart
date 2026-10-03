import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:connectme_app/firebase_options.dart';
import 'package:connectme_app/injection.dart';
import 'package:connectme_app/presentation/screens/home_screen.dart';
import 'package:connectme_app/presentation/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  diInit();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.isLoggedIn = false});
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.backgroundColor,
);
