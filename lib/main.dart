// lib/main.dart

import 'package:cinetrack/app/di/injection.dart';
import 'package:cinetrack/app/router/app_router.dart';
import 'package:flutter/material.dart';

void main() {
  // Setup dependency injection
  configureDependencies();
  // Run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Get the AppRouter instance from our DI container
  final _appRouter = getIt<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CineTrack',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1B1B1B),
      ),
      routerConfig: _appRouter.config(),
    );
  }
}