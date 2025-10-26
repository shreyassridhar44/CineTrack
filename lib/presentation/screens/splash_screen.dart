import 'package:auto_route/auto_route.dart';
// Change this line:
// import 'package:cinetrack/app/router/app_router.gr.dart';
// To this line:
import '../../app/router/app_router.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() {
    // Wait for 2 seconds then navigate to the HomeScreen
    Future.delayed(const Duration(seconds: 2), () {
      // Use 'replace' so the user can't go back to the splash screen
      AutoRouter.of(context).replace(const HomeRoute());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        // You could put a Lottie animation or a logo here later
        child: CircularProgressIndicator(),
      ),
    );
  }
}