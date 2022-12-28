import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_auth/features/auth/data/auth_repository.dart';
import 'package:test_auth/features/test_collection/presentation/combined_snapshot_screen.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateChange = ref.watch(authStateChangesProvider);

    return authStateChange.when(
        data: (user) {
          print('user is: $user');
          return const CombinedSnapshotScreen();
          // : const AuthScreen();
        },
        error: ((error, stackTrace) => Center(
              child: Text(error.toString()),
            )),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()));
  }
}
