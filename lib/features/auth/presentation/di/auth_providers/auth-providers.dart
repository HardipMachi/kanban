import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban/features/auth/domain/di/domain_module.dart';
import 'package:kanban/features/auth/domain/entities/user_entity.dart';
import 'package:kanban/features/auth/domain/usecases/login_usecase.dart';
import 'package:kanban/features/auth/domain/usecases/logout_usecase.dart';
import 'package:kanban/features/auth/domain/usecases/register_usecase.dart';
import '../auth_notifiers/auth_notifiers.dart';

// ---------------- UseCases ----------------
final loginUseCaseProvider = Provider<LoginUseCase>(
      (ref) => LoginUseCase(ref.read(authRepositoryProvider)),
);

final registerUseCaseProvider = Provider<RegisterUseCase>(
      (ref) => RegisterUseCase(ref.read(authRepositoryProvider)),
);

final logoutUseCaseProvider = Provider<LogoutUseCase>(
      (ref) => LogoutUseCase(ref.read(authRepositoryProvider)),
);

// ---------------- Notifier ----------------
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserEntity?>>(
      (ref) => AuthNotifier(
    loginUseCase: ref.read(loginUseCaseProvider),
    registerUseCase: ref.read(registerUseCaseProvider),
    logoutUseCase: ref.read(logoutUseCaseProvider),
  ),
);
