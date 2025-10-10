import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_routes/app_router.dart';
import '../../../../core/utils/toast_util.dart';
import '../providers/auth_providers.dart';

Future<void> loginUser({
  required BuildContext context,
  required WidgetRef ref,
  required String email,
  required String password,
}) async {
  FocusScope.of(context).unfocus(); // close keyboard
  try {
    await ref.read(authStateProvider.notifier).login(email, password);

    final user = ref.read(authStateProvider).value;

    if (!context.mounted) return; // Ensure widget is still mounted

    if (user != null) {
      showToast(context, "Login Successful", isSuccess: true);
      await Future.delayed(const Duration(milliseconds: 800));
      if (!context.mounted) return;
      appRouter.go('/kanban');
    }
  } on FirebaseAuthException catch (e) {
    if (!context.mounted) return;
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
    if (!context.mounted) return;
    showToast(context, "Error: ${e.toString()}", isSuccess: false);
  }
}
