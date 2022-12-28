// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  AuthRepository({
    required this.authInstance,
  });

  final FirebaseAuth authInstance;
  User? get currentUser => authInstance.currentUser;
  Stream<User?> authStateChanges() => authInstance.authStateChanges();

  Future<void> signInUser(void Function() onSuccess) async {
    print('Success. Signing in user...');
    onSuccess();
  }

  Future<void> logout() async {
    try {
      await authInstance.signOut();
    } catch (e) {
      throw e.toString();
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
    (ref) => AuthRepository(authInstance: FirebaseAuth.instance));

final authStateChangesProvider = StreamProvider.autoDispose<User?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  ref.keepAlive();
  return repo.authStateChanges();
});
