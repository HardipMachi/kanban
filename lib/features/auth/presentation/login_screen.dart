import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/contants/app_buttonStyles.dart';
import '../../../core/contants/app_colors.dart';
import '../../../core/contants/app_textStyles.dart';
import '../../auth/presentation/providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void showToast(BuildContext context, String message, {bool isSuccess = true}) {
    final color = isSuccess ? AppColors.success.shade600 : AppColors.error.shade600;
    final icon = isSuccess ? Icons.check_circle : Icons.error;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        content: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(message, style: AppTextStyles.toastText)),
            ],
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> login() async {
    FocusScope.of(context).unfocus();
    try {
      await ref.read(authStateProvider.notifier).login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final user = ref.read(authStateProvider).value;
      if (user != null) {
        showToast(context, "Login Successful", isSuccess: true);
        await Future.delayed(const Duration(milliseconds: 800));
        appRouter.go('/kanban');
      }
    } on FirebaseAuthException catch (e) {
      print("ye raha error ${e.code}");
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
