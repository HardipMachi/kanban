import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban/features/auth/data/di/data_module.dart';
import '../../data/repository_impl/auth_repository_impl.dart';
import '../repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
      (ref) => AuthRepositoryImpl(ref.read(firebaseAuthProvider)),
);
