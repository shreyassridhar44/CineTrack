import 'package:auto_route/auto_route.dart';
import 'package:cinetrack/app/router/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:signals/signals.dart';
import '../../core/logger.dart'; 
import '../../data/services/auth_service.dart';

@injectable
class AuthController {
  final AuthService _authService;
  AuthController(this._authService);

  final email = signal('');
  final password = signal('');
  final isLoading = signal(false);
  final errorMessage = signal<String?>(null);

  Future<void> signIn(BuildContext context) async {
    isLoading.value = true;
    errorMessage.value = null;
    final userEmail = email.value.trim();
    log.i("Attempting to sign in user: $userEmail"); // Info log
    try {
      await _authService.signInWithEmailAndPassword(
        email: userEmail,
        password: password.value.trim(),
      );
      log.d("Sign in successful for: $userEmail"); // Debug log
      if (context.mounted) {
        AutoRouter.of(context).replaceAll([const HomeRoute()]);
      }
    } on FirebaseAuthException catch (e) {
      log.w("Sign in failed for $userEmail", error: e); // Warning log
      errorMessage.value = e.message ?? "An unknown error occurred.";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(BuildContext context) async {
    isLoading.value = true;
    errorMessage.value = null;
    final userEmail = email.value.trim();
    log.i("Attempting to sign up new user: $userEmail"); // Info log
    try {
      await _authService.signUpWithEmailAndPassword(
        email: userEmail,
        password: password.value.trim(),
      );
      log.d("Sign up successful for: $userEmail"); // Debug log
      if (context.mounted) {
        AutoRouter.of(context).replaceAll([const HomeRoute()]);
      }
    } on FirebaseAuthException catch (e) {
      log.w("Sign up failed for $userEmail", error: e); // Warning log
      errorMessage.value = e.message ?? "An unknown error occurred.";
    } finally {
      isLoading.value = false;
    }
  }

  void clearState() {
    email.value = '';
    password.value = '';
    errorMessage.value = null;
  }
}