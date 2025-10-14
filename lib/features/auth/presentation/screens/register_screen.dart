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

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

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
              const Icon(Icons.person_add_alt_1, size: 64, color: AppColors.primary),
              const SizedBox(height: 20),
              const Text(AppStrings.createAccount, textAlign: TextAlign.center, style: AppTextStyles.heading),
              const SizedBox(height: 8),
              const Text(
                AppStrings.registerToStart,
                textAlign: TextAlign.center,
                style: AppTextStyles.subHeading,
              ),
              const SizedBox(height: 30),

              // Name TextField
              TextField(
                controller: authNotifier.nameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline),
                  labelText: AppStrings.registerName,
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Email TextField
              TextField(
                controller: authNotifier.emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  labelText: AppStrings.emailLabel,
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
                  labelText: AppStrings.passwordLabel,
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

              // Register Button
              ElevatedButton(
                style: AppButtonStyles.primary,
                onPressed: isLoading
                    ? null
                    : () async {
                  try {
                    await authNotifier.register();
                    final user = ref.read(authNotifierProvider).value;
                    if (context.mounted) showToast(context, AppStrings.registerSuccess, isSuccess: true);
                    if (user != null) appRouter.go(AppRouteNames.login);
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
                    : const Text(AppStrings.register, style: AppTextStyles.buttonText),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  ref.read(authFormNotifierProvider.notifier).clear();
                  appRouter.go(AppRouteNames.login);
                },
                child: const Text(
                  AppStrings.alreadyHaveAccount,
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
