import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';
import '../../data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository());

// StateNotifier provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>(
      (ref) => AuthNotifier(ref),
);

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref ref;
  AuthNotifier(this.ref) : super(const AsyncValue.data(null));

  // LOGIN
  Future<void> login(String email, String password) async {
    try {
      state = const AsyncValue.loading();
      final user = await ref.read(authRepositoryProvider).login(email, password);
      state = AsyncValue.data(user);
    } on FirebaseAuthException catch (e) {
      // Rethrow FirebaseAuthException so UI can handle specific messages
      state = const AsyncValue.data(null); // reset state
      rethrow;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow; // optional: rethrow other exceptions for UI handling
    }
  }

  // REGISTER
  Future<void> register(String name, String email, String password) async {
    try {
      state = const AsyncValue.loading();
      final user = await ref.read(authRepositoryProvider).register(name, email, password);
      state = AsyncValue.data(user);
    } on FirebaseAuthException catch (e) {
      state = const AsyncValue.data(null);
      rethrow;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(null);
  }
}
