import 'package:firebase_auth/firebase_auth.dart';
import 'package:kanban/app/app_constants/app_Strings.dart';
import 'package:kanban/features/auth/data/model/user_model.dart';
import 'package:kanban/features/auth/domain/entities/user_entity.dart';
import 'package:kanban/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  AuthRepositoryImpl(this._auth);

  @override
  Future<UserEntity?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        return UserModel(id: user.uid, email: user.email ?? '');
      }
      return null;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('${AppStrings.unexpectedError} $e');
    }
  }

  @override
  Future<UserEntity?> register(String name, String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        return UserModel(id: user.uid, email: user.email ?? '', name: name);
      }
      return null;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('${AppStrings.unexpectedError} $e');
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }
}
