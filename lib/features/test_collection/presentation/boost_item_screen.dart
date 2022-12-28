import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_auth/features/test_collection/presentation/add_item_screen_controller.dart';

import '../domain/test_item.dart';

class BoostItemScreen extends ConsumerWidget {
  const BoostItemScreen({super.key, required this.item});
  final TestItem item;

  Future<void> boostItem(BuildContext context, WidgetRef ref) async {
    ref
        .read(addItemScreenControllerProvider.notifier)
        .boostItem(item.id, () => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Boost item')),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(item.title),
          const SizedBox(
            height: 64,
          ),
          ElevatedButton(
            onPressed: item.boosted ? null : () => boostItem(context, ref),
            child: const Text('BoostItem'),
          ),
        ],
      )),
    );
  }
}
