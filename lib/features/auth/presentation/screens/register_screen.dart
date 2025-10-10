import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/contants/app_buttonStyles.dart';
import '../../../../app/contants/app_colors.dart';
import '../../../../app/contants/app_textStyles.dart';
import '../../../../app/routes/app_router.dart';
import '../../../../core/utils/toast_util.dart';
import '../providers/auth_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> register() async {
    FocusScope.of(context).unfocus(); // close keyboard
    try {
      await ref.read(authStateProvider.notifier).register(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final user = ref.read(authStateProvider).value;

      if (!mounted) return; // Check if widget is still mounted

      if (user != null) {
        showToast(context, "Registration Successful", isSuccess: true);
        await Future.delayed(const Duration(milliseconds: 800));
        if (!mounted) return; // Check again before navigation
        appRouter.go('/login');
      } else {
        showToast(context, "Registration failed", isSuccess: false);
      }
    } catch (e) {
      if (!mounted) return; // Avoid calling showToast if widget removed
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
              const Icon(Icons.person_add_alt_1, size: 64, color: AppColors.primary),
              const SizedBox(height: 20),
              const Text('Create Account', textAlign: TextAlign.center, style: AppTextStyles.heading),
              const SizedBox(height: 8),
              const Text('Register to get started with Kanban Board', textAlign: TextAlign.center, style: AppTextStyles.subHeading),
              const SizedBox(height: 30),

              // Name TextField
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline),
                  labelText: 'Full Name',
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),

              // Email TextField
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

              // Password TextField
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
                onPressed: authState.isLoading ? null : register,
                child: authState.isLoading
                    ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Register', style: AppTextStyles.buttonText),
              ),

              const SizedBox(height: 12),
              TextButton(
                onPressed: () => appRouter.go('/login'),
                child: const Text("Already have an account? Login", style: TextStyle(color: AppColors.primary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
