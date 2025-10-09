import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban/features/auth/presentation/providers/auth_providers.dart';

import '../../../routes/app_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void showToast(BuildContext context, String message, {bool isSuccess = true}) {
    final color = isSuccess ? Colors.green.shade600 : Colors.red.shade600;
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
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> register() async {
    FocusScope.of(context).unfocus(); // close keyboard
    try {
      await ref.read(authStateProvider.notifier).register(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final user = ref.read(authStateProvider).value;
      if (user != null) {
        showToast(context, "Registration Successful 🎉", isSuccess: true);
        await Future.delayed(const Duration(milliseconds: 800));
        Navigator.pop(context);
      } else {
        showToast(context, "Registration failed ❌", isSuccess: false);
      }
    } catch (e) {
      showToast(context, "Error: ${e.toString()}", isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.person_add_alt_1, size: 64, color: Colors.blue),
                const SizedBox(height: 20),
                const Text(
                  'Create Account 👤',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Register to get started with Kanban Board',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 30),

                // Name TextField
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline),
                    labelText: 'Full Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
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
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
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
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),

                // Register Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: authState.isLoading ? null : register,
                  child: authState.isLoading
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'Register',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),

                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => appRouter.go('/login'),
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
