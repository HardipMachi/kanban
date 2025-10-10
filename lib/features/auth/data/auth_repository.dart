import 'package:firebase_auth/firebase_auth.dart';
import 'model/user_model.dart';

class AuthRepository {
  final _auth = FirebaseAuth.instance;

  Future<UserModel?> login(String email, String password) async {
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
    } on FirebaseAuthException catch (e) {
      // ✅ rethrow exact Firebase error so UI can handle it properly
      rethrow;
    } catch (e) {
      // Catch unexpected errors
      throw Exception('Unexpected error: $e');
    }
  }

  Future<UserModel?> register(String name, String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        // You can store the name in Firestore later
        return UserModel(id: user.uid, email: user.email ?? '');
      }
      return null;
    } on FirebaseAuthException catch (e) {
      rethrow; // ✅ keep FirebaseAuthException for UI
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
