import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals/signals.dart';

// Use @singleton instead of @lazySingleton to ensure it's created at startup.
@singleton
class ThemeController {
  late final SharedPreferences _prefs;

  // --- State Signal ---
  final themeMode = signal(ThemeMode.system);

  // --- Initialization ---
  // Use a special injectable feature for async initialization.
  @factoryMethod
  static Future<ThemeController> create() async {
    final controller = ThemeController();
    await controller._init();
    return controller;
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadTheme();
  }

  // --- Logic ---
  void _loadTheme() {
    final savedTheme = _prefs.getString('themeMode') ?? 'system';
    switch (savedTheme) {
      case 'light':
        themeMode.value = ThemeMode.light;
        break;
      case 'dark':
        themeMode.value = ThemeMode.dark;
        break;
      default:
        themeMode.value = ThemeMode.system;
        break;
    }
  }

  Future<void> changeTheme(ThemeMode mode) async {
    themeMode.value = mode;
    await _prefs.setString('themeMode', mode.name);
  }
}