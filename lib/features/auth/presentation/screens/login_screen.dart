import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:note_flow/core/constants/app_colors.dart';
import 'package:note_flow/core/constants/app_strings.dart';
import 'package:note_flow/core/utils/validators.dart';
import 'package:note_flow/features/auth/presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(authProvider.notifier);
    final success = await notifier.signIn(
      _emailController.text,
      _passwordController.text,
    );
    if (!success && mounted) {
      final error = ref.read(authProvider).asError?.error.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? AppStrings.authError), backgroundColor: Colors.red[700]),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    final notifier = ref.read(authProvider.notifier);
    await notifier.signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Logo + title
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.notes_rounded, color: Colors.white, size: 38),
                      ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                      const SizedBox(height: 20),
                      Text(
                        AppStrings.appName,
                        style: theme.textTheme.displayLarge?.copyWith(
                          background: Paint()..shader = const LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                          ).createShader(const Rect.fromLTWH(0, 0, 200, 40)),
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.tagline,
                        style: theme.textTheme.bodyMedium,
                      ).animate().fadeIn(delay: 350.ms),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Welcome back',
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 24),
                ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.2, end: 0),
                const SizedBox(height: 6),
                Text(
                  'Sign in to access your notes',
                  style: theme.textTheme.bodyMedium,
                ).animate().fadeIn(delay: 450.ms),
                const SizedBox(height: 32),
                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.email,
                  decoration: const InputDecoration(
                    hintText: 'Email address',
                    prefixIcon: Icon(Icons.mail_outline_rounded, size: 20),
                  ),
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 16),
                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  validator: Validators.password,
                  onFieldSubmitted: (_) => _signIn(),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ).animate().fadeIn(delay: 550.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _showForgotPassword(context),
                    child: Text(AppStrings.forgotPassword,
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 24),
                // Sign in button
                ElevatedButton(
                  onPressed: isLoading ? null : _signIn,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(AppStrings.signIn),
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 20),
                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('or', style: theme.textTheme.bodyMedium),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ).animate().fadeIn(delay: 650.ms),
                const SizedBox(height: 20),
                // Google button
                OutlinedButton.icon(
                  onPressed: isLoading ? null : _signInWithGoogle,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    side: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
                  ),
                  icon: _GoogleIcon(),
                  label: const Text(AppStrings.continueWithGoogle),
                ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 32),
                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppStrings.dontHaveAccount, style: theme.textTheme.bodyMedium),
                    TextButton(
                      onPressed: () => context.pushNamed('register'),
                      child: Text(AppStrings.signUp,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                  ],
                ).animate().fadeIn(delay: 750.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showForgotPassword(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Password'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'Enter your email'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: Size.zero, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref.read(authProvider.notifier).sendPasswordReset(controller.text);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(success
                      ? 'Password reset email sent!'
                      : 'Failed to send email. Check address.'),
                ));
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.g_mobiledata_rounded, size: 28, color: Colors.red);
  }
}
