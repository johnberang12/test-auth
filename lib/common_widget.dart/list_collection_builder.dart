import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/connectivity_service.dart';
import 'custom_firestore_query_builder.dart';

typedef ItemWidgetBuilder<T> = Widget Function(T item, int index);

class ListCollectionBuilder<T> extends ConsumerWidget {
  const ListCollectionBuilder({
    super.key,
    required this.query,
    required this.boostedQuery,
    required this.itemBuilder,
    this.loading,
    this.sort,
    this.separator = const Divider(
      height: 0.5,
      thickness: .7,
    ),
    this.emptyWidget,
    this.reverseListView = false,
    this.reverseItems = false,
    this.listController,
    this.padding,
    this.withRefresh = false,
    this.pageSize = 10,
    this.lastItem,
    this.sortTwo,
    this.reverseItemsTwo = false,
    // this.onRefresh,
  });

  // final AsyncValue<List<Product>> listValue;
  final Query<T> query;
  final Query<T> boostedQuery;
  final ItemWidgetBuilder<T> itemBuilder;
  final Widget? loading;
  final Widget separator;
  final Widget? emptyWidget;
  final bool reverseItems;
  final bool reverseItemsTwo;
  final bool reverseListView;
  final ScrollController? listController;
  // final int Function(DocumentSnapshot<T>, DocumentSnapshot<T>)? sort;
  final int Function(QueryDocumentSnapshot<T>, QueryDocumentSnapshot<T>)? sort;
  final int Function(QueryDocumentSnapshot<T>, QueryDocumentSnapshot<T>)?
      sortTwo;
  final EdgeInsetsGeometry? padding;
  final bool withRefresh;
  final int pageSize;
  final Widget? lastItem;

  // final Future<void> Function(FirestoreQueryBuilderSnapshot<T>) onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connection = ref.watch(connectivityServiceProvider);
    return CustomFirestoreQueryBuilder<T>(
      pageSize: pageSize,
      query: query,
      boostedQuery: boostedQuery,
      builder: (context, snapshot, boostedSnapshot, ___) {
        var totalSnapshot = <QueryDocumentSnapshot<T>>[];
        var snapTwo = reverseItemsTwo
            ? boostedSnapshot.docs.reversed.toList()
            : boostedSnapshot.docs;
        print('snapTwoList: ${snapTwo.length}');
        if (sortTwo != null) {
          snapTwo.sort(sortTwo);
          totalSnapshot.addAll(snapTwo);
        } else {
          totalSnapshot.addAll(snapTwo);
        }

        var snap =
            reverseItems ? snapshot.docs.reversed.toList() : snapshot.docs;
        print('snapList: ${snap.length}');
        if (sort != null) {
          snap.sort(sort);
          totalSnapshot.addAll(snap);
        } else {
          totalSnapshot.addAll(snap);
        }

        // final itemList = <T>[].reversed.toList();
        // for (var i = 0; i < snapshot.docs.length; i++) {
        //   final item = snapshot.docs[i].data();
        //   itemList.add(item);
        // }
        if (snapshot.isFetching || boostedSnapshot.isFetching) {
          return loading ?? const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        }
        if (boostedSnapshot.hasError) {
          print(snapshot.error.toString());
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(boostedSnapshot.error.toString()),
            ),
          );
        }
        if (totalSnapshot.isEmpty) {
          return emptyWidget ??
              const Center(
                  child: Text(
                'No item found',
              ));
        }

        print('totalSnapshot: ${totalSnapshot.length}');
        return ListView.separated(
          padding: padding ?? const EdgeInsets.all(0),
          physics: const BouncingScrollPhysics(),
          primary: false,
          shrinkWrap: true,
          controller: listController,
          reverse: reverseListView,
          itemCount: totalSnapshot.length + 1,
          separatorBuilder: (_, __) => separator,
          itemBuilder: ((context, index) {
            // if (boostedSnapshot.hasMore &&
            //     (index + 1) == (boostedSnapshot.docs.length)) {
            //   // Tell FirestoreQueryBuilder to try to obtain more items.
            //   // It is safe to call this function from within the build method.
            //   if (connection) {
            //     print('fetching snapshot/....');
            //     boostedSnapshot.fetchMore();
            //   }
            // }
            // print('index  + 1: ${index + 1}');
            // print('snapshot length: ${snapshot.docs.length}');
            if (snapshot.hasMore && index + 1 == totalSnapshot.length) {
              // Tell FirestoreQueryBuilder to try to obtain more items.
              // It is safe to call this function from within the build method.
              if (connection) {
                print('fetching snapshot/....');
                snapshot.fetchMore();
              }
            }

            final list = totalSnapshot;

            if ((index == totalSnapshot.length)) {
              return lastItem ?? const SizedBox();
            }

            final item = list[index].data();
            return itemBuilder(item, index);
          }),
        );
      },
    );
  }
}
