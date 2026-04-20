import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_flow/core/constants/app_colors.dart';
import 'package:note_flow/core/constants/app_strings.dart';
import 'package:note_flow/core/theme/theme_provider.dart';
import 'package:note_flow/features/auth/presentation/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile card
          if (user != null)
            _SettingsCard(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                  child: user.photoUrl == null
                      ? Text(
                          user.displayName[0].toUpperCase(),
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 20),
                        )
                      : null,
                ),
                title: Text(user.displayName, style: theme.textTheme.titleMedium),
                subtitle: Text(user.email, style: theme.textTheme.bodyMedium),
              ),
            ).animate().fadeIn().slideY(begin: 0.2),
          const SizedBox(height: 20),
          Text('Appearance', style: theme.textTheme.labelMedium?.copyWith(letterSpacing: 1.1, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          _SettingsCard(
            child: SwitchListTile(
              secondary: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: AppColors.primary),
              title: Text(isDark ? AppStrings.darkMode : AppStrings.lightMode),
              subtitle: const Text('Toggle theme'),
              value: isDark,
              activeColor: AppColors.primary,
              onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
            ),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
          const SizedBox(height: 20),
          Text('Account', style: theme.textTheme.labelMedium?.copyWith(letterSpacing: 1.1, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          _SettingsCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.cloud_sync_outlined, color: AppColors.accent),
                  title: const Text(AppStrings.syncStatus),
                  subtitle: const Text(AppStrings.synced, style: TextStyle(color: AppColors.accent)),
                  trailing: const Icon(Icons.check_circle_outline, color: AppColors.accent),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: Colors.red),
                  title: const Text(AppStrings.signOut, style: TextStyle(color: Colors.red)),
                  onTap: () => _confirmSignOut(context, ref),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
          const SizedBox(height: 24),
          Center(
            child: Text('NoteFlow v1.0.0',
                style: theme.textTheme.labelMedium?.copyWith(fontSize: 12)),
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }

  void _confirmSignOut(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('You will be redirected to the login screen.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authProvider.notifier).signOut();
            },
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;
  const _SettingsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: child,
      ),
    );
  }
}
