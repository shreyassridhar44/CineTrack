import 'package:auto_route/auto_route.dart';
import 'package:cinetrack/app/router/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import this
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../app/di/injection.dart';
import '../../data/services/auth_service.dart';

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
    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    final authService = getIt<AuthService>();

    // This will wait for BOTH of the following to complete:
    // 1. A timer of at least 2 seconds.
    // 2. The first result from the authentication state stream.
    final results = await Future.wait([
      Future.delayed(const Duration(seconds: 2)),
      authService.authStateChanges.first, // Gets the initial auth state
    ]);

    // After both are done, get the user object from the results.
    final user = results[1] as User?;

    // Check if the widget is still mounted before navigating.
    if (!mounted) return;

    if (user != null) {
      // User is logged in
      AutoRouter.of(context).replaceAll([const HomeRoute()]);
    } else {
      // User is not logged in
      AutoRouter.of(context).replaceAll([const LoginRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/animations/movie_loader.json', 
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}