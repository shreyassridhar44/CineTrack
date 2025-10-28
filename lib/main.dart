import 'package:cinetrack/app/di/injection.dart';
import 'package:cinetrack/app/router/app_router.dart';
import 'package:cinetrack/presentation/controllers/theme_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:signals/signals_flutter.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await configureDependencies();
  await getIt.allReady();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = getIt<AppRouter>();
  final _themeController = getIt<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final currentThemeMode = _themeController.themeMode.watch(context);

    return MaterialApp.router(
      title: 'CineTrack',
      debugShowCheckedModeBanner: false,

      // --- Light Theme Configuration ---
      theme: ThemeData.light(useMaterial3: true).copyWith(
        appBarTheme: const AppBarTheme(
          // For Light Mode: White background, black text and icons
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          shadowColor: Colors.black26,
        ),
      ),

      // --- Dark Theme Configuration ---
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        appBarTheme: const AppBarTheme(
          // For Dark Mode: Dark background, white text and icons
          backgroundColor: Color(0xFF121212),
          foregroundColor: Colors.white,
        ),
      ),
      
      themeMode: currentThemeMode,
      routerConfig: _appRouter.config(),
    );
  }
}