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
    // We use the same AuthController instance
    final controller = getIt<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Watch((context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              if (controller.isLoading.value)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  // The main difference: calls signUp
                  onPressed: () => controller.signUp(context),
                  child: const Text('Sign Up'),
                ),
              TextButton(
                onPressed: () {
                  controller.clearState();
                  // Navigates back to the login screen
                  AutoRouter.of(context).pop();
                },
                child: const Text('Already have an account? Login'),
              ),
            ],
          );
        }),
      ),
    );
  }
}