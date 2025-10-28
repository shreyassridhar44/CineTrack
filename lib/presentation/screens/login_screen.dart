import 'package:auto_route/auto_route.dart';
import 'package:cinetrack/app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import '../../app/di/injection.dart';
import '../controllers/auth_controller.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<AuthController>();

    return Scaffold(
      // The AppBar is removed.
      body: SafeArea( // Use SafeArea to avoid UI overlapping with system notches.
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView( // Prevents overflow on smaller screens
              child: Watch((context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --- New UI Section ---
                    Icon(
                      Icons.movie_filter_outlined,
                      size: 80,
                      // This color will adapt to the current theme.
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome to CineTrack',
                      // This text style will adapt to the current theme.
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      'Log in to continue to your watchlist.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 40),

                    // --- Existing Form Fields ---
                    TextField(
                      onChanged: (value) => controller.email.value = value,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onChanged: (value) => controller.password.value = value,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    if (controller.errorMessage.value != null)
                      Text(
                        controller.errorMessage.value!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 20),
                    if (controller.isLoading.value)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: () => controller.signIn(context),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Login'),
                      ),
                    TextButton(
                      onPressed: () {
                        controller.clearState();
                        AutoRouter.of(context).push(SignUpRoute());
                      },
                      child: const Text('Don\'t have an account? Sign Up'),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}