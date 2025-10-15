import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kanban/app/app_constants/app_Strings.dart';
import 'package:kanban/features/auth/domain/entities/user_entity.dart';
import 'package:kanban/features/auth/domain/usecases/login_usecase.dart';
import 'package:kanban/features/auth/domain/usecases/logout_usecase.dart';
import 'package:kanban/features/auth/domain/usecases/register_usecase.dart';

class AuthNotifier extends StateNotifier<AsyncValue<UserEntity?>> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;

  // TextControllers for login/register forms
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthNotifier({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
  }) : super(const AsyncValue.data(null));

  // ------------------- Form Validation -------------------
  bool validate({bool isRegister = false}) {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (isRegister && name.isEmpty) return false;
    if (email.isEmpty || password.isEmpty) return false;
    return true;
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ------------------- LOGIN -------------------
  Future<void> login() async {
    if (!validate()) throw Exception(AppStrings.fillDetail);
    try {
      state = const AsyncValue.loading();
      final user = await loginUseCase.call(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      state = AsyncValue.data(user);
    } on FirebaseAuthException {
      state = const AsyncValue.data(null);
      rethrow;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  // ------------------- REGISTER -------------------
  Future<void> register() async {
    if (!validate(isRegister: true)) throw Exception(AppStrings.fillDetail);
    try {
      state = const AsyncValue.loading();
      final user = await registerUseCase.call(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      state = AsyncValue.data(user);
    } on FirebaseAuthException {
      state = const AsyncValue.data(null);
      rethrow;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  // ------------------- LOGOUT -------------------

  Future<void> logout() async {
    await logoutUseCase();
    state = const AsyncValue.data(null);
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }
}
