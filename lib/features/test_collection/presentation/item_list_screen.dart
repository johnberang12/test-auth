import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_auth/common_widget.dart/list_collection_builder.dart';
import 'package:test_auth/features/admin_pannel/presentation/admin_panel_screen.dart';
import 'package:test_auth/features/test_collection/data/test_item_repository.dart';
import 'package:test_auth/features/test_collection/presentation/add_item_screen_controller.dart';
import 'package:test_auth/features/test_collection/presentation/boost_item_screen.dart';

import '../domain/test_item.dart';
import 'add_item_screen.dart';

class ItemListScreen extends ConsumerStatefulWidget {
  const ItemListScreen({super.key});

  @override
  ConsumerState<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends ConsumerState<ItemListScreen> {
  final int pageSize = 10;
  bool secondCollectionLoaded = false;

  Future<QuerySnapshot> loadNextPage() async {
    final boostedQuery = ref.read(boostedTestItemQueryProvider);
    final mainQuery = ref.read(testItemQueryProvider);
    Query<TestItem> query = boostedQuery.limit(pageSize);
    if (secondCollectionLoaded) {
      query = mainQuery.limit(pageSize);
    }

    final snapshots = await query.get();
    if (snapshots.docs.isEmpty && !secondCollectionLoaded) {
      secondCollectionLoaded = true;
    }

    return snapshots;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final testItemQuery = ref.watch(testItemQueryProvider);
    final boostedItemQuery = ref.watch(boostedTestItemQueryProvider);
    ref.listen<AsyncValue>(
        addItemScreenControllerProvider, ((previous, next) {}));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items list'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddItemScreen(),
                  )),
              child: const Text(
                'Add item',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: ListCollectionBuilder<TestItem>(
          pageSize: 10,
          query: testItemQuery,
          boostedQuery: boostedItemQuery,
          sort: (p0, p1) => p0.id.compareTo(p1.id),
          sortTwo: (p0, p1) =>
              p1.data().boostedAt.compareTo(p0.data().boostedAt),
          itemBuilder: (item, index) => ProviderScope(
                overrides: [itemProvider.overrideWithValue(item)],
                child: const TestItemListTile(),
              )),
      bottomNavigationBar: ElevatedButton(
        child: const Text('Admin panel'),
        onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AdminPanelScreen())),
      ),
    );
  }
}

class TestItemListTile extends ConsumerWidget {
  const TestItemListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(itemProvider);
    return ListTile(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: ((context) => BoostItemScreen(item: item)))),
      title: Text(item.title),
      subtitle: Text.rich(TextSpan(children: [
        TextSpan(text: 'boosted: ${item.boosted.toString()}'),
        const TextSpan(text: '\n'),
        TextSpan(text: item.boosted ? item.boostedAt : '')
      ])),
      isThreeLine: true,
    );
  }
}

final itemProvider = Provider<TestItem>((ref) => throw UnimplementedError());
