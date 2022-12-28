// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:georange/georange.dart';

import 'package:test_auth/features/test_collection/data/test_item_repository.dart';
import 'package:test_auth/features/test_collection/presentation/add_item_screen.dart';

import '../domain/test_item.dart';

class AddItemScreenController extends StateNotifier<AsyncValue<void>> {
  AddItemScreenController({
    required this.repository,
  }) : super(const AsyncData(null));
  final TestItemRepository repository;

  Future<void> updateHash() async {
    state = const AsyncLoading();
    final items = await repository.testItemQuery().get().then((value) {
      final docs = value.docs;
      final List<TestItem> items = [];
      for (var i = 0; i < docs.length; i++) {
        final doc = docs[i].data();
        items.add(doc);
      }
      return items;
    });
    final newState = await AsyncValue.guard(() => update(items));
    if (mounted) {
      state = newState;
    }
  }

  Future<void> update(List<TestItem> items) async {
    for (var i = 0; i < items.length; i++) {
      final lat = items[i].location.latitude;
      final long = items[i].location.longitude;
      final geo = GeoRange();
      print('updating...');
      final geoHash = geo.encode(lat, long);
      await repository.updateItem(items[i].id, {'geoHash': geoHash});
    }
  }

  Future<void> sendItem(TestItem testItem) async {
    state = const AsyncLoading();
    final newState =
        await AsyncValue.guard(() => repository.setTestItem(testItem));
    if (mounted) {
      state = newState;
    }
  }

  Future<void> boostItem(String itemId, void Function() onSuccess) async {
    state = const AsyncLoading();
    final newState = await AsyncValue.guard(() => repository.updateItem(
        itemId, {'boosted': true, 'boostedAt': idFromCurrentDate()}));
    if (mounted) {
      state = newState;
      if (state.hasError == false) {
        onSuccess();
      }
    }
  }
}

final addItemScreenControllerProvider =
    StateNotifierProvider<AddItemScreenController, AsyncValue<void>>((ref) =>
        AddItemScreenController(
            repository: ref.watch(testItemRepositoryProvider)));
