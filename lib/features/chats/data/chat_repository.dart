// ignore_for_file: public_member_api_docs, sort_constructors_first


// class ChatRepository {
//   ChatRepository({
//     required this.service,
//   });
//   final FirestoreService service;

//   Future<void> setChat(Chat chat) async {
//     await service.setData(path: TestAuthPath.chat(chat.id), data: chat.toMap());
//   }

//   Future<List<Chat>> getChats() => service.getCollections(
//       path: TestAuthPath.chats(),
//       builder: ((data, documentId) => Chat.fromMap(data)));

//   Query<Chat> chatQuery() => service.collectionQuery<Chat>(
//       path: TestAuthPath.chats(),
//       fromMap: ((snapshot, options) => Chat.fromMap(snapshot.data()!)),
//       toMap: ((p0, options) => p0.toMap()));
// }

// final chatRepositoryProvider = Provider<ChatRepository>((ref) =>
//     ChatRepository(service: ref.watch(firestoreTestAuthServiceProvider)));

// final chatsFutureProvider = FutureProvider.autoDispose<List<Chat>>((ref) async {
//   final repo = ref.watch(chatRepositoryProvider);
//   return await repo.getChats();
// });

// final chatQueryProvider = StateProvider.autoDispose<Query<Chat>>((ref) {
//   final repo = ref.watch(chatRepositoryProvider);
//   return repo.chatQuery();
// });
