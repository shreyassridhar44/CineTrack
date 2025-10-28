import 'package:auto_route/auto_route.dart';
import 'package:cinetrack/app/router/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:signals/signals.dart';
import '../../data/services/auth_service.dart';

@injectable
class ProfileController {
  final AuthService _authService;
  late final Computed<String> userName;

  ProfileController(this._authService) {
    userName = computed(() {
      final email = user.value?.email ?? 'No email';
      return email.split('@').first;
    });
  }

  final user = signal<User?>(null);

  void loadUserData() {
    //... (this method is unchanged)
    user.value = _authService.getCurrentUser();
  }

  // --- New Method to Handle Password Change ---
  Future<void> handleChangePassword(BuildContext context) async {
    try {
      await _authService.changePassword();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset link sent to your email.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send email: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> handleSignOut(BuildContext context) async {
    //... (this method is unchanged)
    await _authService.signOut();
    if (context.mounted) {
      AutoRouter.of(context).replaceAll([const LoginRoute()]);
    }
  }

  Future<void> handleDeleteAccount(BuildContext context) async {
    //... (this method is unchanged)
    try {
      await _authService.deleteAccount();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted successfully.')),
        );
        AutoRouter.of(context).replaceAll([const LoginRoute()]);
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'An error occurred.')),
        );
      }
    }
  }
}