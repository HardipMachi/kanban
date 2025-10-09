import '../data/model/user_model.dart';

abstract class AuthRepositoryInterface {
  Future<UserModel> register(String email, String password, String name);
  Future<UserModel> login(String email, String password);
  Future<void> logout();
}
