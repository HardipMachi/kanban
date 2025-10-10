import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_constants/app_buttonStyles.dart';
import '../../../../app/app_constants/app_colors.dart';
import '../../../../app/app_constants/app_textStyles.dart';
import '../../../../app/app_routes/app_router.dart';
import '../../../../core/utils/toast_util.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    FocusScope.of(context).unfocus();
    try {
      await ref.read(authStateProvider.notifier).login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      final user = ref.read(authStateProvider).value;
      if (!mounted) return; // Ensure widget still exists
      if (user != null) {
        showToast(context, "Login Successful", isSuccess: true);
        await Future.delayed(const Duration(milliseconds: 800));
        if (!mounted) return;
        appRouter.go('/kanban');
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return; // In case user left screen early
      if (e.code == 'user-not-found') {
        showToast(context, "No user found with this email", isSuccess: false);
      } else if (e.code == 'wrong-password') {
        showToast(context, "Incorrect password", isSuccess: false);
      } else if (e.code == 'invalid-email') {
        showToast(context, "Invalid email format", isSuccess: false);
      } else {
        showToast(context, "Login failed: ${e.message}", isSuccess: false);
      }
    } catch (e) {
      if (!mounted) return;
      showToast(context, "Error: ${e.toString()}", isSuccess: false);
    }
  }


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
                onPressed: authState.isLoading ? null : login,
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
