import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban/features/auth/presentation/di/auth_notifiers/auth_form_notifiers.dart';

final authFormNotifierProvider = StateNotifierProvider<AuthFormNotifier, void>((ref) {
  return AuthFormNotifier();
});
