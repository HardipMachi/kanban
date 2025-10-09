import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban/features/auth/presentation/providers/auth_providers.dart';
import '../../../routes/app_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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

  Future<void> login() async {
    FocusScope.of(context).unfocus(); // Close keyboard
    try {
      await ref.read(authStateProvider.notifier).login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final user = ref.read(authStateProvider).value;
      if (user != null) {
        showToast(context, "Login Successful 🎉", isSuccess: true);
        await Future.delayed(const Duration(milliseconds: 800));
        appRouter.go('/kanban');
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      if (e.code == 'user-not-found') {
        showToast(context, "No user found with this email ❌", isSuccess: false);
      } else if (e.code == 'wrong-password') {
        showToast(context, "Incorrect password ❌", isSuccess: false);
      } else if (e.code == 'invalid-email') {
        showToast(context, "Invalid email format ❌", isSuccess: false);
      } else {
        showToast(context, "Login failed: ${e.message}", isSuccess: false);
      }
    } catch (e) {
      // Any other errors
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
                const Icon(Icons.lock_outline, size: 64, color: Colors.blue),
                const SizedBox(height: 20),
                const Text(
                  'Welcome 👋',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Login to continue to Kanban Board',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 30),

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

                // Login Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: authState.isLoading ? null : login,
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
                    'Login',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),

                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => appRouter.go('/register'),
                  child: const Text(
                    "Don't have an account? Register",
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
