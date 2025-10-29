import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import '../../app/di/injection.dart';
import '../controllers/auth_controller.dart';

@RoutePage()
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<AuthController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Watch((context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_add_alt_1_outlined,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Create Your Account',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      'Get started with your personal movie tracker.',
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
                        onPressed: () => controller.signUp(context),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Sign Up'),
                      ),
                    TextButton(
                      onPressed: () {
                        controller.clearState();
                        AutoRouter.of(context).pop();
                      },
                      child: const Text('Already have an account? Login'),
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