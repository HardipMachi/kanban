import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban/app/app_constants/app_Strings.dart';
import 'package:kanban/app/app_constants/app_buttonStyles.dart';
import 'package:kanban/app/app_constants/app_colors.dart';
import 'package:kanban/app/app_constants/app_textStyles.dart';
import 'package:kanban/app/app_routes/app_route_names.dart';
import 'package:kanban/app/app_routes/app_router.dart';
import 'package:kanban/core/utils/toast_util.dart';
import 'package:kanban/features/auth/presentation/di/auth_providers/auth-providers.dart';
import 'package:kanban/features/auth/presentation/di/auth_providers/auth_form_providers.dart';
import 'package:kanban/generated/s.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final authState = ref.watch(authNotifierProvider);

    final isLoading = authState.when(
      data: (_) => false,
      loading: () => true,
      error: (_, __) => false,
    );

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
              Text(S.of(context)!.welcome, textAlign: TextAlign.center, style: AppTextStyles.heading),
              const SizedBox(height: 8),
              const Text(
                AppStrings.loginSubHeading,
                textAlign: TextAlign.center,
                style: AppTextStyles.subHeading,
              ),
              const SizedBox(height: 30),

              // Email TextField
              TextField(
                controller: authNotifier.emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  labelText: S.of(context)!.emailLabel,
                  filled: true,
                  fillColor: AppColors.white,
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
                controller: authNotifier.passwordController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  labelText: S.of(context)!.passwordLabel,
                  filled: true,
                  fillColor: AppColors.white,
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
                style: AppButtonStyles.primary,
                onPressed: isLoading
                    ? null
                    : () async {
                  try {
                    await authNotifier.login();
                    final user = ref.read(authNotifierProvider).value;
                    if (context.mounted) showToast(context, S.of(context)!.loginSuccess, isSuccess: true);
                    if (user != null) {
                      appRouter.go(AppRouteNames.kanban);
                    }
                  } catch (e) {
                    if (context.mounted) showToast(context, e.toString(), isSuccess: false);
                  }
                },
                child: isLoading
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : Text(S.of(context)!.loginButton, style: AppTextStyles.buttonText),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  ref.read(authFormNotifierProvider.notifier).clear();
                  appRouter.go(AppRouteNames.register);
                },
                child: Text(
                  S.of(context)!.registerPrompt,
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
