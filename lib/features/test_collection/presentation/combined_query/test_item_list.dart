// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/firestore.dart';

typedef FirestoreQueryBuilderSnapshotBuilder<T> = Widget Function(
  BuildContext context,
  FirestoreQueryBuilderSnapshot<T> snapshot,
  Widget? child,
);

class TestItemList<T> extends ConsumerStatefulWidget {
  const TestItemList({
    super.key,
    required this.nonBoosted,
    required this.boosted,
  });
  final Query nonBoosted;
  final Query boosted;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestItemListState();
}

class _TestItemListState extends ConsumerState<TestItemList> {
  bool isFetching = false;
  final int boostedPageSize = 10;
  final int nonBoostedPageSize = 10;
  DocumentSnapshot? boostedLastDocument;
  DocumentSnapshot? nonBoostedLastDocument;

  List<DocumentSnapshot<Object?>> boosted = [];
  List<DocumentSnapshot<Object?>> nonBoosted = [];

  bool hasMoreBoosted = true;
  bool hasMoreNonBoosted = true;

  StreamSubscription? _boostedQuerySubscription;
  StreamSubscription? _nonBoostedQuerySubsciption;

  @override
  void initState() {
    _listenQuery();
    super.initState();
  }

  @override
  void dispose() {
    _boostedQuerySubscription?.cancel();
    _nonBoostedQuerySubsciption?.cancel();
    super.dispose();
  }

  Future<void> loadMore() async {
    if (hasMoreBoosted) {
      QuerySnapshot snapshot = await widget.boosted
          .startAfter([boostedLastDocument])
          .limit(boostedPageSize)
          .get();
      setState(() {
        boosted.addAll(snapshot.docs);
        boostedLastDocument = snapshot.docs.last;
        hasMoreBoosted = snapshot.docs.length == boostedPageSize;
      });
    } else {
      QuerySnapshot snapshot = await widget.nonBoosted
          .startAfter([nonBoostedLastDocument])
          .limit(nonBoostedPageSize)
          .get();
      setState(() {
        nonBoosted.addAll(snapshot.docs);
        nonBoostedLastDocument = snapshot.docs.last;
        hasMoreNonBoosted = snapshot.docs.length == boostedPageSize;
      });
    }
  }

  void _listenQuery() async {
    final boostedQuery = widget.boosted.limit(boostedPageSize);
    _boostedQuerySubscription = boostedQuery.snapshots().listen((event) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
