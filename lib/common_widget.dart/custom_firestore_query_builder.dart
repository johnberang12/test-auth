import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/firestore.dart';

typedef CustomQuerySnapshotBuilder<T> = Widget Function(
  BuildContext context,
  FirestoreQueryBuilderSnapshot<T> snapshot,
  FirestoreQueryBuilderSnapshot<T> boostedSnapshot,
  Widget? child,
);

class CustomFirestoreQueryBuilder<Document> extends ConsumerStatefulWidget {
  /// {@macro firebase_ui.firestore_query_builder}
  const CustomFirestoreQueryBuilder({
    Key? key,
    required this.query,
    required this.builder,
    required this.boostedQuery,
    this.pageSize = 10,
    this.child,
  })  : assert(pageSize > 1, 'Cannot have a pageSize lower than 1'),
        super(key: key);

  /// The query that will be paginated.
  ///
  /// When the query changes, the pagination will restart from first page.
  final Query<Document> query;

  final Query<Document> boostedQuery;

  /// The number of items that will be fetched at a time.
  ///
  /// When it changes, the current progress will be preserved.
  final int pageSize;

  final CustomQuerySnapshotBuilder<Document> builder;

  /// A widget that will be passed to [builder] for optimizations purpose.
  ///
  /// Since this widget is not created within [builder], it won't rebuild
  /// when the query emits an update.
  final Widget? child;

  @override
  // ignore: library_private_types_in_public_api
  _CustomFirestoreQueryBuilderState<Document> createState() =>
      _CustomFirestoreQueryBuilderState<Document>();
}

class _CustomFirestoreQueryBuilderState<Document>
    extends ConsumerState<CustomFirestoreQueryBuilder<Document>> {
  StreamSubscription? _querySubscription;
  StreamSubscription? _boostedQuerySubscription;

  var _pageCount = 0;

  late var _snapshot = _CustomQueryBuilderSnapshot<Document>._(
    docs: [],
    error: null,
    hasData: false,
    hasError: false,
    hasMore: false,
    isFetching: false,
    isFetchingMore: false,
    stackTrace: null,
    fetchMore: _fetchNextPage,
  );
  late var _boostedSnapshot = _BoostedQueryBuilderSnapshot<Document>._(
    docs: [],
    error: null,
    hasData: false,
    hasError: false,
    hasMore: false,
    isFetching: false,
    isFetchingMore: false,
    stackTrace: null,
    // it renders the whole list of boosted snapshots so no need to fetch
    fetchMore: () {},
  );

  void _fetchNextPage() {
    if (_snapshot.isFetching ||
        !_snapshot.hasMore ||
        _snapshot.isFetchingMore) {
      return;
    }
    _pageCount++;
    _listenQuery(nextPage: true);
  }

  // void _fetchBoostedNextPage() {
  //   if (_boostedSnapshot.isFetching ||
  //       !_boostedSnapshot.hasMore ||
  //       _boostedSnapshot.isFetchingMore) {
  //     return;
  //   }
  //   _pageCount++;
  //   _listenQuery(nextPage: true);
  // }

  @override
  void initState() {
    super.initState();
    _listenQuery();
  }

  @override
  void didUpdateWidget(CustomFirestoreQueryBuilder<Document> oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('disUpdateWidget...');
    if (oldWidget.query != widget.query) {
      _pageCount = 0;
      _listenQuery();
    } else if (oldWidget.pageSize != widget.pageSize) {
      // The page size changes, so we re-fetch items, making sure we're
      // preserving the current progress.
      final previousItemCount = (oldWidget.pageSize + 1) * _pageCount;
      _pageCount = (previousItemCount / widget.pageSize).ceil();
      _listenQuery();
    }
  }

  void _listenQuery({bool nextPage = false}) {
    print('listening query...');
    _querySubscription?.cancel();
    _boostedQuerySubscription?.cancel();

    if (nextPage) {
      _boostedSnapshot = _boostedSnapshot.copyWith(isFetchingMore: true);

      _snapshot = _snapshot.copyWith(isFetchingMore: true);
    } else {
      _boostedSnapshot = _boostedSnapshot.copyWith(isFetching: true);

      _snapshot = _snapshot.copyWith(isFetching: true);
    }

    // Delaying the setState so that fetchNextpage can be used within a child's
    // "build" – most commonly ListView's itemBuilder
    Future.microtask(() => setState(() {}));

    final expectedDocsCount = (_pageCount + 1) * widget.pageSize

        /// The "+1" is used to voluntarily fetch one extra item,
        /// used to determine whether there is a next page or not.
        /// This extra item will not be rendered.
        +
        1;

    print('expectedDocCount: $expectedDocsCount');
//* listen to the boostedProducts

    final boosted = widget.boostedQuery.snapshots();

    _boostedQuerySubscription = boosted.listen(
      (event) {
        print('boosted event: ${event.size}');
        setState(() {
          if (nextPage) {
            _boostedSnapshot = _boostedSnapshot.copyWith(isFetchingMore: false);
          } else {
            _boostedSnapshot = _boostedSnapshot.copyWith(isFetching: false);
          }

          _boostedSnapshot = _boostedSnapshot.copyWith(
            hasData: true,
            docs: event.docs,
            error: null,
            hasMore: event.size >= expectedDocsCount,
            stackTrace: null,
            hasError: false,
          );
        });
        print('size: ${event.size}');
        print('boosted docs: ${_boostedSnapshot.docs.length}');

        print('boostedHas more: ${_boostedSnapshot.hasMore}');
      },
      onError: (Object error, StackTrace stackTrace) {
        setState(() {
          if (nextPage) {
            _boostedSnapshot = _boostedSnapshot.copyWith(isFetchingMore: false);
          } else {
            _boostedSnapshot = _boostedSnapshot.copyWith(isFetching: false);
          }

          _boostedSnapshot = _boostedSnapshot.copyWith(
            error: error,
            stackTrace: stackTrace,
            hasError: true,
            hasMore: false,
          );
        });
      },
    );

    //* listen to the nonBoosted products

    final query = widget.query.limit(expectedDocsCount).snapshots();

    _querySubscription = query.listen(
      (event) {
        setState(() {
          if (nextPage) {
            _snapshot = _snapshot.copyWith(isFetchingMore: false);
          } else {
            _snapshot = _snapshot.copyWith(isFetching: false);
          }

          List<QueryDocumentSnapshot<Document>> getDocs() {
            if (event.size < expectedDocsCount) {
              return event.docs;
            } else {
              return event.docs.take(expectedDocsCount - 1).toList();
            }
          }

          _snapshot = _snapshot.copyWith(
            hasData: true,
            docs: getDocs(),
            // event.size < expectedDocsCount
            //     ? event.docs
            //     : event.docs.take(expectedDocsCount - 1).toList(),
            error: null,
            hasMore: event.size == expectedDocsCount,
            stackTrace: null,
            hasError: false,
          );

          print('snap has more: ${_snapshot.hasMore}');
        });
      },
      onError: (Object error, StackTrace stackTrace) {
        setState(() {
          if (nextPage) {
            _snapshot = _snapshot.copyWith(isFetchingMore: false);
          } else {
            _snapshot = _snapshot.copyWith(isFetching: false);
          }

          _snapshot = _snapshot.copyWith(
            error: error,
            stackTrace: stackTrace,
            hasError: true,
            hasMore: false,
          );
        });
      },
    );
  }

  @override
  void dispose() {
    _querySubscription?.cancel();
    _boostedQuerySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _snapshot, _boostedSnapshot, widget.child);
  }
}

class _CustomQueryBuilderSnapshot<Document>
    implements FirestoreQueryBuilderSnapshot<Document> {
  _CustomQueryBuilderSnapshot._({
    required this.docs,
    required this.error,
    required this.hasData,
    required this.hasError,
    required this.isFetching,
    required this.isFetchingMore,
    required this.stackTrace,
    required this.hasMore,
    required VoidCallback fetchMore,
  }) : _fetchNextPage = fetchMore;

  @override
  final List<QueryDocumentSnapshot<Document>> docs;

  @override
  final Object? error;

  @override
  final bool hasData;

  @override
  final bool hasError;

  @override
  final bool hasMore;

  @override
  final bool isFetching;

  @override
  final bool isFetchingMore;

  @override
  final StackTrace? stackTrace;

  final VoidCallback _fetchNextPage;

  @override
  void fetchMore() => _fetchNextPage();

  _CustomQueryBuilderSnapshot<Document> copyWith({
    Object? docs = const _CustomSentinel(),
    Object? error = const _CustomSentinel(),
    Object? hasData = const _CustomSentinel(),
    Object? hasError = const _CustomSentinel(),
    Object? hasMore = const _CustomSentinel(),
    Object? isFetching = const _CustomSentinel(),
    Object? isFetchingMore = const _CustomSentinel(),
    Object? stackTrace = const _CustomSentinel(),
  }) {
    T valueAs<T>(Object? maybeNewValue, T previousValue) {
      if (maybeNewValue == const _CustomSentinel()) {
        return previousValue;
      }
      return maybeNewValue as T;
    }

    return _CustomQueryBuilderSnapshot._(
      docs: valueAs(docs, this.docs),
      error: valueAs(error, this.error),
      hasData: valueAs(hasData, this.hasData),
      hasMore: valueAs(hasMore, this.hasMore),
      hasError: valueAs(hasError, this.hasError),
      isFetching: valueAs(isFetching, this.isFetching),
      isFetchingMore: valueAs(isFetchingMore, this.isFetchingMore),
      stackTrace: valueAs(stackTrace, this.stackTrace),
      fetchMore: fetchMore,
    );
  }
}

class _CustomSentinel {
  const _CustomSentinel();
}

class _BoostedQueryBuilderSnapshot<Document>
    implements FirestoreQueryBuilderSnapshot<Document> {
  _BoostedQueryBuilderSnapshot._({
    required this.docs,
    required this.error,
    required this.hasData,
    required this.hasError,
    required this.isFetching,
    required this.isFetchingMore,
    required this.stackTrace,
    required this.hasMore,
    required VoidCallback fetchMore,
  }) : _fetchNextPage = fetchMore;

  @override
  final List<QueryDocumentSnapshot<Document>> docs;

  @override
  final Object? error;

  @override
  final bool hasData;

  @override
  final bool hasError;

  @override
  final bool hasMore;

  @override
  final bool isFetching;

  @override
  final bool isFetchingMore;

  @override
  final StackTrace? stackTrace;

  final VoidCallback _fetchNextPage;

  @override
  void fetchMore() => _fetchNextPage();

  _BoostedQueryBuilderSnapshot<Document> copyWith({
    Object? docs = const _CustomSentinel(),
    Object? error = const _CustomSentinel(),
    Object? hasData = const _CustomSentinel(),
    Object? hasError = const _CustomSentinel(),
    Object? hasMore = const _CustomSentinel(),
    Object? isFetching = const _CustomSentinel(),
    Object? isFetchingMore = const _CustomSentinel(),
    Object? stackTrace = const _CustomSentinel(),
  }) {
    T valueAs<T>(Object? maybeNewValue, T previousValue) {
      if (maybeNewValue == const _CustomSentinel()) {
        return previousValue;
      }
      return maybeNewValue as T;
    }

    return _BoostedQueryBuilderSnapshot._(
      docs: valueAs(docs, this.docs),
      error: valueAs(error, this.error),
      hasData: valueAs(hasData, this.hasData),
      hasMore: valueAs(hasMore, this.hasMore),
      hasError: valueAs(hasError, this.hasError),
      isFetching: valueAs(isFetching, this.isFetching),
      isFetchingMore: valueAs(isFetchingMore, this.isFetchingMore),
      stackTrace: valueAs(stackTrace, this.stackTrace),
      fetchMore: fetchMore,
    );
  }
}

// final boostedIsLoadedProvider = StateProvider.autoDispose<bool>((ref) => false);
