import 'package:cinetrack/app/di/injection.dart';
import 'package:cinetrack/app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import the package

Future<void> main() async { // Make main async
  // Ensure that widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file
  await dotenv.load(fileName: ".env");

  // Setup dependency injection
  configureDependencies();

  // Run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

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