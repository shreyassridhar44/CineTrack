import 'package:auto_route/auto_route.dart';
import 'package:cinetrack/app/router/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:signals/signals.dart';
import '../../data/services/auth_service.dart';

@injectable
class AuthController {
  final AuthService _authService;
  AuthController(this._authService);

  // --- State Signals ---
  final email = signal('');
  final password = signal('');
  final isLoading = signal(false);
  final errorMessage = signal<String?>(null);

  // --- Logic ---
  Future<void> signIn(BuildContext context) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await _authService.signInWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value.trim(),
      );
      // On success, navigate to home and clear all previous routes
      AutoRouter.of(context).replaceAll([const HomeRoute()]);
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? "An unknown error occurred.";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(BuildContext context) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await _authService.signUpWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value.trim(),
      );
      // On success, navigate to home and clear all previous routes
      AutoRouter.of(context).replaceAll([const HomeRoute()]);
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? "An unknown error occurred.";
    } finally {
      isLoading.value = false;
    }
  }

  // Method to clear state when switching screens
  void clearState() {
    email.value = '';
    password.value = '';
    errorMessage.value = null;
  }
}