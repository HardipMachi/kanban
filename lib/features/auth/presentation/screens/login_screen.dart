import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_constants/app_buttonStyles.dart';
import '../../../../app/app_constants/app_colors.dart';
import '../../../../app/app_constants/app_textStyles.dart';
import '../../../../app/app_routes/app_router.dart';
import '../auth_utils/login_util.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: AppColors.primary),
              const SizedBox(height: 20),
              const Text('Welcome', textAlign: TextAlign.center, style: AppTextStyles.heading),
              const SizedBox(height: 8),
              const Text('Login to continue to Kanban Board', textAlign: TextAlign.center, style: AppTextStyles.subHeading),
              const SizedBox(height: 30),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  labelText: 'Email',
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  labelText: 'Password',
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                style: AppButtonStyles.primary,
                onPressed: authState.isLoading ? null :  () => loginUser(
                  context: context,
                  ref: ref,
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                ),
                child: authState.isLoading
                    ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Login', style: AppTextStyles.buttonText),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => appRouter.go('/register'),
                child: const Text("Don't have an account? Register", style: TextStyle(color: AppColors.primary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
