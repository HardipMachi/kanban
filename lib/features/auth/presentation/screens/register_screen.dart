import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban/app/app_constants/app_buttonStyles.dart';
import 'package:kanban/app/app_constants/app_colors.dart';
import 'package:kanban/app/app_constants/app_textStyles.dart';
import 'package:kanban/app/app_routes/app_route_names.dart';
import 'package:kanban/app/app_routes/app_router.dart';
import 'package:kanban/core/utils/toast_util.dart';
import 'package:kanban/features/auth/presentation/di/auth_providers/auth-providers.dart';
import 'package:kanban/features/auth/presentation/shared_widgets/custom_text_field.dart';
import 'package:kanban/generated/s.dart';
import '../di/auth_providers/auth_controller_providers.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final authState = ref.watch(authNotifierProvider);

    final nameController = ref.watch(nameControllerProvider);
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
              const Icon(Icons.person_add_alt_1,
                  size: 64, color: AppColors.primary),
              const SizedBox(height: 20),
              Text(S.of(context)!.createAccount,
                  textAlign: TextAlign.center, style: AppTextStyles.heading),
              const SizedBox(height: 8),
              Text(
                S.of(context)!.registerToStart,
                textAlign: TextAlign.center,
                style: AppTextStyles.subHeading,
              ),
              const SizedBox(height: 30),

              // ------------------- Name -------------------
              CustomTextField(
                controller: nameController,
                label: S.of(context)!.registerName,
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

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

              // ------------------- Register Button -------------------
              ElevatedButton(
                style: AppButtonStyles.primary,
                onPressed: isLoading
                    ? null
                    : () async {
                  if (nameController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    showToast(context, S.of(context)!.fillDetail,
                        isSuccess: false);
                    return;
                  }

                  try {
                    await authNotifier.register(
                      name: nameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    final user = ref.read(authNotifierProvider).value;

                    if (context.mounted) {
                      showToast(context, S.of(context)!.registerSuccess,
                          isSuccess: true);
                    }

                    if (user != null) {
                      appRouter.go(AppRouteNames.login);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showToast(context, e.toString(), isSuccess: false);
                    }
                  }
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
                    : Text(S.of(context)!.register,
                    style: AppTextStyles.buttonText),
              ),

              const SizedBox(height: 12),

              // ------------------- Login Prompt -------------------
              TextButton(
                onPressed: () {
                  appRouter.go(AppRouteNames.login);
                },
                child: Text(
                  S.of(context)!.alreadyHaveAccount,
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
