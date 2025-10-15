import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban/app/app_constants/app_buttonStyles.dart';
import 'package:kanban/app/app_constants/app_colors.dart';
import 'package:kanban/app/app_constants/app_textStyles.dart';
import 'package:kanban/app/app_routes/app_route_names.dart';
import 'package:kanban/app/app_routes/app_router.dart';
import 'package:kanban/features/auth/presentation/components/custom_text_field.dart';
import 'package:kanban/features/auth/presentation/di/auth_notifiers/auth_notifiers.dart';
import 'package:kanban/features/auth/presentation/di/auth_providers/auth-providers.dart';
import 'package:kanban/generated/s.dart';
import '../di/auth_providers/auth_controller_providers.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final authState = ref.watch(authNotifierProvider);

    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);

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
              Text(
                S.of(context)!.welcome,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading,
              ),
              const SizedBox(height: 8),
              Text(
                S.of(context)!.loginSubHeading,
                textAlign: TextAlign.center,
                style: AppTextStyles.subHeading,
              ),
              const SizedBox(height: 30),

              // ------------------- Email -------------------
              CustomTextField(
                controller: emailController,
                label: S.of(context)!.emailLabel,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // ------------------- Password -------------------
              CustomTextField(
                controller: passwordController,
                label: S.of(context)!.passwordLabel,
                prefixIcon: Icons.lock_outline,
                obscureText: true,
              ),
              const SizedBox(height: 24),

              // ------------------- Login Button -------------------
              ElevatedButton(
                style: AppButtonStyles.primary,
                onPressed: isLoading
                    ? null
                    : () async {
                  await authNotifier.loginFromUI(
                    email: emailController.text,
                    password: passwordController.text,
                    context: context,
                  );
                },
                child: isLoading
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  S.of(context)!.loginButton,
                  style: AppTextStyles.buttonText,
                ),
              ),

              const SizedBox(height: 12),

              // ------------------- Register Prompt -------------------
              TextButton(
                onPressed: () {
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
