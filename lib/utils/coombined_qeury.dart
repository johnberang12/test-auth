import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rxdart/streams.dart';
import 'package:test_auth/services/firestore_services/test_app_firestore_service.dart';
import '../features/test_collection/domain/test_item.dart';
import '../services/firestore_services/test_app_path.dart';

class FirebaseRepository<T> {
  FirebaseRepository({required this.service});
  final FirestoreService service;

  Stream<QuerySnapshot<TestItem>> chatQuery() => service
      .collectionQuery<TestItem>(
        path: TestAppPath.testItems(),
        fromMap: ((snapshot, options) => TestItem.fromMap(snapshot.data()!)),
        toMap: ((p0, options) => p0.toMap()),
        // queryBuilder: (query) =>
        //     query!.where('boosted', isEqualTo: true).orderBy('boostedAt'),
      )
      .snapshots();

  Stream<QuerySnapshot<TestItem>> chatQueryTwo() => service
      .collectionQuery<TestItem>(
        path: TestAppPath.testItems(),
        fromMap: ((snapshot, options) => TestItem.fromMap(snapshot.data()!)),
        toMap: ((p0, options) => p0.toMap()),
        // queryBuilder: (query) {
        //   return query!.where('boosted', isEqualTo: false).orderBy('id');
        // },
      )
      .snapshots();

  Stream<List<DocumentSnapshot<TestItem>>> combinedStream() =>
      CombineLatestStream.combine2<QuerySnapshot<TestItem>,
              QuerySnapshot<TestItem>, List<DocumentSnapshot<TestItem>>>(
          chatQuery(), chatQueryTwo(), (a, b) => [...a.docs, ...b.docs]);
}

final firebaseRepoProvider = Provider<FirebaseRepository>((ref) =>
    FirebaseRepository(service: ref.watch(firestoreTestAppServiceProvider)));

final combinedQueryStreamProvider =
    StreamProvider.autoDispose<List<DocumentSnapshot<TestItem>>>((ref) {
  final repo = ref.watch(firebaseRepoProvider);
  return repo.combinedStream();
});

final chatQueryStream =
    StreamProvider.autoDispose<QuerySnapshot<TestItem>>((ref) {
  final repo = ref.watch(firebaseRepoProvider);
  return repo.chatQuery();
});
