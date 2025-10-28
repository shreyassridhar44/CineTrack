import 'package:auto_route/auto_route.dart';
import 'package:cinetrack/presentation/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import '../../app/di/injection.dart';
import '../controllers/profile_controller.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = getIt<ProfileController>();
  final themeController = getIt<ThemeController>();

  @override
  void initState() {
    super.initState();
    controller.loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: Watch((context) {
        final user = controller.user.value;
        if (user == null) {
          return const Center(child: Text('No user data found.'));
        }
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // User Info Section
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.userName.value,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(user.email ?? 'No email available'),
                  ],
                ),
              ],
            ),
            const Divider(height: 40),

            // Settings Options
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Change Theme'),
              subtitle: const Text('Light, Dark, System Default'),
              onTap: () => _showThemeDialog(context),
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Change Password'),
              onTap: () => controller.handleChangePassword(context),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.orange),
              title: const Text('Sign Out'),
              onTap: () => _showConfirmationDialog(
                context: context,
                title: 'Sign Out',
                content: 'Are you sure you want to sign out?',
                onConfirm: () => controller.handleSignOut(context),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Delete Account'),
              onTap: () => _showConfirmationDialog(
                context: context,
                title: 'Delete Account',
                content:
                    'This action is irreversible. All your data will be permanently deleted.',
                onConfirm: () => controller.handleDeleteAccount(context),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: const Text('Light'),
                value: ThemeMode.light,
                groupValue: themeController.themeMode.value,
                onChanged: (value) {
                  if (value != null) themeController.changeTheme(value);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Dark'),
                value: ThemeMode.dark,
                groupValue: themeController.themeMode.value,
                onChanged: (value) {
                  if (value != null) themeController.changeTheme(value);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('System Default'),
                value: ThemeMode.system,
                groupValue: themeController.themeMode.value,
                onChanged: (value) {
                  if (value != null) themeController.changeTheme(value);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(title, style: const TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
          ),
        ],
      ),
    );
  }
}