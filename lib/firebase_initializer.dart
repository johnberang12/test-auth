import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

class FirebaseInitilizer {
  FirebaseInitilizer();
  Future<void> _init() async {
    await Firebase.initializeApp(
        options: TestAuthFirebaseOptions.currentPlatform);
  }
}

final firebaseInitializerProvider =
    Provider<FirebaseInitilizer>((ref) => FirebaseInitilizer());
final firebaseInitializerFutureProvider =
    FutureProvider.autoDispose<void>((ref) {
  ref.keepAlive();
  final repo = ref.watch(firebaseInitializerProvider);
  return repo._init();
});
