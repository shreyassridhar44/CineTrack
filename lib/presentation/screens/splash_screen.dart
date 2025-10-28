import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:cinetrack/app/router/app_router.dart';
import 'package:flutter/material.dart';
import '../../app/di/injection.dart';
import '../../data/services/auth_service.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Use a StreamSubscription to listen to auth changes
  late final StreamSubscription _authSubscription;

  @override
  void initState() {
    super.initState();
    final authService = getIt<AuthService>();

    // Listen to the auth state stream
    _authSubscription = authService.authStateChanges.listen((user) {
      // Allow a small delay for the app to settle
      Future.delayed(const Duration(seconds: 1), () {
        if (user != null) {
          // User is logged in
          AutoRouter.of(context).replaceAll([const HomeRoute()]);
        } else {
          // User is not logged in
          AutoRouter.of(context).replaceAll([const LoginRoute()]);
        }
      });
    });
  }

  @override
  void dispose() {
    // Important: Cancel the subscription to avoid memory leaks
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}