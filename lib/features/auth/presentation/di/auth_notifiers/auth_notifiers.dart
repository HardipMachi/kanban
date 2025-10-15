import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban/app/app_constants/app_Strings.dart';
import 'package:kanban/app/app_routes/app_route_names.dart';
import 'package:kanban/core/utils/toast_util.dart';
import 'package:kanban/features/auth/domain/entities/user_entity.dart';
import 'package:kanban/features/auth/domain/usecases/login_usecase.dart';
import 'package:kanban/features/auth/domain/usecases/register_usecase.dart';
import 'package:kanban/features/auth/domain/usecases/logout_usecase.dart';
import 'package:kanban/app/app_routes/app_router.dart';
import 'package:kanban/generated/s.dart';

class AuthNotifier extends StateNotifier<AsyncValue<UserEntity?>> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;

  AuthNotifier({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
  }) : super(const AsyncValue.data(null));

  // ------------------- LOGIN -------------------
  Future<void> login({required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception(AppStrings.fillDetail);
    }

    try {
      state = const AsyncValue.loading();
      final user = await loginUseCase.call(email.trim(), password.trim());
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  // ------------------- REGISTER -------------------
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception(AppStrings.fillDetail);
    }

    try {
      state = const AsyncValue.loading();
      final user = await registerUseCase.call(name.trim(), email.trim(), password.trim());
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  // ------------------- LOGOUT -------------------
  Future<void> logout() async {
    await logoutUseCase();
    state = const AsyncValue.data(null);
  }
}

extension AuthNotifierUI on AuthNotifier {

  Future<void> loginFromUI({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      if (context.mounted) {
        showToast(context, S.of(context)!.fillDetail, isSuccess: false);
      }
      return;
    }

    try {
      await login(email: email, password: password);
      final user = state.value;

      if (context.mounted) {
        showToast(context, S.of(context)!.loginSuccess, isSuccess: true);
      }

      if (user != null && context.mounted) {
        appRouter.go(AppRouteNames.kanban);
      }
    } catch (e) {
      if (context.mounted) {
        showToast(context, e.toString(), isSuccess: false);
      }
    }
  }

  Future<void> registerFromUI({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      if (context.mounted) {
        showToast(context, S.of(context)!.fillDetail, isSuccess: false);
      }
      return;
    }

    try {
      await register(name: name, email: email, password: password);
      final user = state.value;

      if (context.mounted) {
        showToast(context, S.of(context)!.registerSuccess, isSuccess: true);
      }

      if (user != null && context.mounted) {
        appRouter.go(AppRouteNames.login);
      }
    } catch (e) {
      if (context.mounted) {
        showToast(context, e.toString(), isSuccess: false);
      }
    }
  }
}
