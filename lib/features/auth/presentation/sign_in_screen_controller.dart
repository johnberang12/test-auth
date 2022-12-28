import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';

class SignInScreenController extends StateNotifier<AsyncValue<void>> {
  SignInScreenController({required this.repository})
      : super(const AsyncData(null));
  final AuthRepository repository;
  Future<void> signInUser(void Function() onSuccess) async {
    state = const AsyncLoading();
    final newState =
        await AsyncValue.guard(() => repository.signInUser(onSuccess));
    if (mounted) {
      state = newState;
    }
  }
}

final signInScreenControllerProvider = StateNotifierProvider
    .autoDispose<SignInScreenController, AsyncValue<void>>((ref) =>
        SignInScreenController(repository: ref.watch(authRepositoryProvider)));
