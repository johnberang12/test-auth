import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:test_auth/features/auth/presentation/sign_in_screen_controller.dart';
import 'package:test_auth/utils/async_value_ui.dart';

import '../../test_collection/presentation/item_list_screen.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<AuthScreen> {
  final String _error = '';
  final String _userId = '';

  // Future<void> signIn() async {
  //   // await ref.read(signInScreenControllerProvider.notifier).signInUser();
  //   await Future.delayed(const Duration(milliseconds: 500));
  //   final user = ref.read(authRepositoryProvider).currentUser;
  //   if (user != null) {
  //     Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) => const ItemListScreen(),
  //     ));
  //   } else {
  //     setState(() {
  //       _error = "Failed to sign in";
  //       _userId = user?.uid ?? '';
  //     });
  //   }
  // }

  void _onSuccess() => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const ItemListScreen()));

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(signInScreenControllerProvider,
        (_, state) => state.showAlertDialogOnError(context));
    // final state = ref.watch(signInScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: SignInScreen(
        showAuthActionSwitch: true,
        auth: FirebaseAuth.instance,
        providerConfigs: const [PhoneProviderConfiguration()],
        actions: [
          AuthStateChangeAction<SignedIn>((context, _) => ref
              .read(signInScreenControllerProvider.notifier)
              .signInUser(_onSuccess))
        ],
      ),
    );
  }
}
