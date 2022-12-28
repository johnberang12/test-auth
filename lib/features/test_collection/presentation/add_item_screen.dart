import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:georange/georange.dart';
import 'package:test_auth/features/test_collection/domain/test_item.dart';
import 'package:test_auth/features/test_collection/presentation/add_item_screen_controller.dart';

String idFromCurrentDate() => DateTime.now().toIso8601String();

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key});

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final _itemController = TextEditingController();
  final _latController = TextEditingController();
  final _longController = TextEditingController();
  String get itemTitle => _itemController.text;
  String get lat => _latController.text;
  String get long => _longController.text;

  Future<void> saveItem() async {
    const latitude = 16.502005;
    const longitude = 120.473372;
    const location = GeoPoint(latitude, longitude);
    final geo = GeoRange();

    final geoHash = geo.encode(latitude, longitude);
    final testItem = TestItem(
        id: idFromCurrentDate(),
        title: itemTitle,
        location: location,
        boostedAt: idFromCurrentDate(),
        geoHash: geoHash,
        boosted: false);
    await ref.read(addItemScreenControllerProvider.notifier).sendItem(testItem);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addItemScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add item'),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                  shrinkWrap: true,
                  reverse: true,
                  children: [
                    TextField(
                      controller: _itemController,
                      decoration: const InputDecoration(label: Text('Title')),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: _latController,
                      decoration: const InputDecoration(label: Text('Lat')),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: _longController,
                      decoration: const InputDecoration(label: Text('Long')),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ElevatedButton(
                        onPressed: () => saveItem(),
                        child: const Text('Save item')),
                  ].reversed.toList()),
            ),
    );
  }
}
