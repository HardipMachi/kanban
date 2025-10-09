import 'package:firebase_auth/firebase_auth.dart';
import 'model/user_model.dart';

class AuthRepository {
  final _auth = FirebaseAuth.instance;

  Future<UserModel?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = credential.user;
      if (user != null) {
        return UserModel(id: user.uid, email: user.email ?? '');
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserModel?> register(String name, String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = credential.user;
      if (user != null) {
        // Optionally save name in Firestore
        return UserModel(id: user.uid, email: user.email ?? '');
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
