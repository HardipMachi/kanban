import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kanban/app/app_constants/app_Strings.dart';
import 'package:kanban/features/auth/domain/entities/user_entity.dart';
import 'package:kanban/features/auth/domain/usecases/login_usecase.dart';
import 'package:kanban/features/auth/domain/usecases/register_usecase.dart';
import 'package:kanban/features/auth/domain/usecases/logout_usecase.dart';

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
    } on FirebaseAuthException {
      state = const AsyncValue.data(null);
      rethrow;
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
      final user =
      await registerUseCase.call(name.trim(), email.trim(), password.trim());
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
  }
}
