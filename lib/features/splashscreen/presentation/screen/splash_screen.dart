import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../auth/presentation/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late Box appBox;

  @override
  void initState() {
    super.initState();
    appBox = Hive.box('appBox');
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {

    bool isFirstTime = appBox.get('isFirstTime', defaultValue: true);

    await Future.delayed(const Duration(seconds: 2));

    if (isFirstTime) {
      // save false
      await appBox.put('isFirstTime', false);

      _goTo(const LoginScreen());
    } else {
      _goTo(const HomeScreen());
    }
  }

  void _goTo(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.note_alt, size: 80, color: Colors.white),
              SizedBox(height: 20),
              Text(
                "Notes App",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}