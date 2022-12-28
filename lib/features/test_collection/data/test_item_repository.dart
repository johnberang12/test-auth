// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/firestore_services/test_app_path.dart';
import '../../../services/firestore_services/test_app_firestore_service.dart';
import '../domain/test_item.dart';

class TestItemRepository {
  TestItemRepository({
    required this.service,
  });
  final FirestoreService service;

  Future<void> setTestItem(TestItem testItem) => service.setData(
      path: TestAppPath.testItem(testItem.id), data: testItem.toMap());

  Future<void> updateItem(String itemId, Map<String, dynamic> data) =>
      service.updateDoc(path: TestAppPath.testItem(itemId), data: data);

  Query<TestItem> testItemQuery() {
    const radius = 25;
    const maxDistance = radius / 111.12;
    const lat = 16.324515;
    const long = 120.613850;
    const geoUpper = GeoPoint(lat + maxDistance, long + maxDistance);
    const geoLower = GeoPoint(lat - maxDistance, long - maxDistance);
    // final range = GeoRange().geohashRange(lat, long, distance: radius);

    return service
        .collectionQuery<TestItem>(
            path: TestAppPath.testItems(),
            fromMap: ((snapshot, options) =>
                TestItem.fromMap(snapshot.data() ?? {})),
            toMap: (item, options) => item.toMap())
        .where('boosted', isEqualTo: false)
        .where('location', isGreaterThanOrEqualTo: geoLower)
        .where('location', isLessThanOrEqualTo: geoUpper)
        .orderBy('location', descending: true)
        .orderBy('id', descending: false);
  }

  Query<TestItem> boostedTestItemQuery() {
    const radius = 25;
    const maxDistance = radius / 111.12;
    const lat = 16.41639;
    const long = 120.59306;
    const geoUpper = GeoPoint(lat + maxDistance, long + maxDistance);
    const geoLower = GeoPoint(lat - maxDistance, long - maxDistance);
    final boostedQuery = service
        .collectionQuery<TestItem>(
          path: TestAppPath.testItems(),
          fromMap: ((snapshot, options) =>
              TestItem.fromMap(snapshot.data() ?? {})),
          toMap: (p0, options) => p0.toMap(),
        )
        .where('boosted', isEqualTo: true)
        .where('location', isGreaterThanOrEqualTo: geoLower)
        .where('location', isLessThanOrEqualTo: geoUpper)
        .orderBy('location', descending: true)
        .orderBy('boostedAt', descending: true);

    return boostedQuery;
  }
}

final testItemRepositoryProvider = Provider<TestItemRepository>((ref) =>
    TestItemRepository(service: ref.watch(firestoreTestAppServiceProvider)));

final testItemQueryProvider = StateProvider.autoDispose<Query<TestItem>>((ref) {
  final repo = ref.watch(testItemRepositoryProvider);
  return repo.testItemQuery();
});

final boostedTestItemQueryProvider =
    StateProvider.autoDispose<Query<TestItem>>((ref) {
  final repo = ref.watch(testItemRepositoryProvider);
  return repo.boostedTestItemQuery();
});
