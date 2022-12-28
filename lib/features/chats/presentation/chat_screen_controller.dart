// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:test_auth/features/auth/data/auth_repository.dart';
// import 'package:test_auth/features/chats/data/chat_repository.dart';

// import '../domain/chat.dart';

// class ChatScreenController extends StateNotifier<AsyncValue<void>> {
//   ChatScreenController({required this.repository, required this.authRepo})
//       : super(const AsyncData(null));
//   final ChatRepository repository;
//   final AuthRepository authRepo;

//   Future<void> setChat(Chat chat) async {
//     state = const AsyncLoading();
//     final newState = await AsyncValue.guard(() => repository.setChat(chat));
//     if (mounted) {
//       state = newState;
//     }
//   }

//   Future<void> logout() async {
//     state = const AsyncLoading();
//     final newState = await AsyncValue.guard(() => authRepo.logout());
//     if (mounted) {
//       state = newState;
//     }
//   }
// }

// final chatScreenControllerProvider =
//     StateNotifierProvider.autoDispose<ChatScreenController, AsyncValue<void>>(
//         (ref) => ChatScreenController(
//             repository: ref.watch(chatRepositoryProvider),
//             authRepo: ref.watch(authRepositoryProvider)));
