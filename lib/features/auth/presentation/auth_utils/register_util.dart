import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_routes/app_router.dart';
import '../../../../core/utils/toast_util.dart';
import '../providers/auth_providers.dart';

Future<void> registerUser({
  required BuildContext context,
  required WidgetRef ref,
  required String name,
  required String email,
  required String password,
}) async {
  FocusScope.of(context).unfocus(); // close keyboard
  try {
    await ref.read(authStateProvider.notifier).register(name, email, password);

    final user = ref.read(authStateProvider).value;

    if (!context.mounted) return; // Check if widget is still mounted

    if (user != null) {
      showToast(context, "Registration Successful", isSuccess: true);
      await Future.delayed(const Duration(milliseconds: 800));
      if (!context.mounted) return; // Check again before navigation
      appRouter.go('/login');
    } else {
      showToast(context, "Registration failed", isSuccess: false);
    }
  } catch (e) {
    if (!context.mounted) return; // Avoid calling showToast if widget removed
    showToast(context, "Error: ${e.toString()}", isSuccess: false);
  }
}
