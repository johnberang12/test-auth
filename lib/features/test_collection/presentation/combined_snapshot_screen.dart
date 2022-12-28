import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_auth/utils/coombined_qeury.dart';

import 'boost_item_screen.dart';

typedef CombinedSnapshotBuilder<T> = Widget Function(
  BuildContext context,
  Stream<List<DocumentSnapshot<T>>> snapshot,
  Widget? child,
);

class CombinedSnapshotScreen extends ConsumerStatefulWidget {
  const CombinedSnapshotScreen({super.key});

  @override
  ConsumerState<CombinedSnapshotScreen> createState() =>
      _CombinedSnapshotState();
}

class _CombinedSnapshotState extends ConsumerState<CombinedSnapshotScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final combinedValue = ref.watch(combinedQueryStreamProvider);
    final combineSnap = ref.watch(combinedQueryStreamProvider).value;
    final querySnap = ref.watch(chatQueryStream).value;
    print('queryLength: ${querySnap?.docs.length}');
    print('combineList: ${combineSnap?.length}');
    return Scaffold(
      appBar: AppBar(title: const Text('Combined snapshot')),
      body: combinedValue.when(
          data: (data) {
            print('data: ${data.length}');
            return ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  final item = data[index].data();

                  return item != null
                      ? ListTile(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      BoostItemScreen(item: item)))),
                          title: Text(item.title),
                          subtitle: Text.rich(TextSpan(children: [
                            TextSpan(
                                text: 'boosted: ${item.boosted.toString()}'),
                            const TextSpan(text: '\n'),
                            TextSpan(text: item.boosted ? item.boostedAt : '')
                          ])),
                          isThreeLine: true,
                        )
                      : const SizedBox();
                }));
          },
          error: ((error, stackTrace) => Center(
                child: Text(error.toString()),
              )),
          loading: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              )),
    );
  }
}
