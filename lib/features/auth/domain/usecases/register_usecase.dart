import 'package:kanban/features/auth/domain/entities/user_entity.dart';
import 'package:kanban/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserEntity?> call(String name, String email, String password) {
    return repository.register(name, email, password);
  }
}
