// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutterfire_ui/firestore.dart';
// import 'package:test_auth/features/auth/data/auth_repository.dart';
// import 'package:test_auth/features/chats/presentation/chat_screen_controller.dart';
// import 'package:test_auth/utils/async_value_ui.dart';

// import '../../test_collection/presentation/item_list_screen.dart';
// import '../data/chat_repository.dart';
// import '../domain/chat.dart';

// class ChatScreen extends ConsumerStatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   ConsumerState<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends ConsumerState<ChatScreen> {
//   Future<void> _logout() async {
//     final logout = await showAlertDialog(
//         context: context,
//         title: 'Are you sure you want to log out?',
//         cancelActionText: 'Cancel');

//     if (logout == true) {
//       ref.read(authRepositoryProvider).logout();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     ref.listen<AsyncValue>(chatScreenControllerProvider, (_, __) {});
//     final chatQuery = ref.watch(chatQueryProvider);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//         actions: [
//           IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
//           IconButton(
//               onPressed: () => Navigator.of(context).push(PageRouteBuilder(
//                   pageBuilder: ((context, animation, secondaryAnimation) =>
//                       const ItemListScreen()),
//                   transitionsBuilder:
//                       (context, animation, secondaryAnimation, child) {
//                     const begin = Offset(0.0, 1.0);
//                     const end = Offset.zero;
//                     const curve = Curves.ease;

//                     var tween = Tween(begin: begin, end: end)
//                         .chain(CurveTween(curve: curve));
//                     return SlideTransition(
//                         position: animation.drive(tween), child: child);
//                   })),
//               icon: const Icon(Icons.notifications_active)),
//         ],
//       ),
//       body: FirestoreQueryBuilder<Chat>(
//         query: chatQuery,
//         builder: ((context, snapshot, child) {
//           if (snapshot.isFetching) {
//             return const Center(
//               child: CircularProgressIndicator.adaptive(),
//             );
//           }
//           if (snapshot.hasError) {
//             return Center(
//               child: Text(snapshot.error.toString()),
//             );
//           }

//           final lists = snapshot.docs;
//           List<Chat> chats = [];
//           for (var i = 0; i < lists.length; i++) {
//             final chat = lists[i].data();
//             chats.add(chat);
//           }

//           return ListView.builder(
//               itemCount: chats.length,
//               itemBuilder: (context, index) {
//                 if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
//                   snapshot.fetchMore();
//                 }
//                 return ListTile(
//                   title: Text(chats[index].id),
//                   subtitle: Text(chats[index].content),
//                   isThreeLine: true,
//                 );
//               });
//         }),
//       ),
//       bottomNavigationBar: Padding(
//         padding: MediaQuery.of(context).viewInsets,
//         child: const ChatInputField(),
//       ),
//     );
//   }
// }

// class ChatInputField extends ConsumerStatefulWidget {
//   const ChatInputField({super.key});

//   @override
//   ConsumerState<ChatInputField> createState() => _ChatInputFieldState();
// }

// class _ChatInputFieldState extends ConsumerState<ChatInputField> {
//   final _chatController = TextEditingController();
//   String get content => _chatController.text;

//   Future<void> sendChat() async {
//     final chat = Chat(id: DateTime.now().toIso8601String(), content: content);
//     if (content.isNotEmpty) {
//       await ref
//           .read(chatScreenControllerProvider.notifier)
//           .setChat(chat)
//           .then((value) => _chatController.clear());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 50,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         child: Row(
//           children: [
//             Expanded(
//               flex: 8,
//               child: TextField(
//                 controller: _chatController,
//                 decoration: const InputDecoration(hintText: 'Type text here'),
//               ),
//             ),
//             Expanded(
//                 flex: 2,
//                 child: Center(
//                     child: IconButton(
//                         onPressed: () => sendChat(),
//                         icon: const Icon(Icons.send))))
//           ],
//         ),
//       ),
//     );
//   }
// }
