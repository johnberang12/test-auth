// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//* unit test done
class FirestoreService {
  FirestoreService({
    required this.firestore,
  });
  final FirebaseFirestore firestore;

  ///this is a general purpose method to get a document from firestore

  /// used to add and edit data in database
  Future<void> setData(
      {required String path, required Map<String, dynamic> data}) async {
    await firestore.enablePersistence();
    final reference = firestore.doc(path);
    await reference.set(data);
  }

  Future<void> mergeData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = firestore.doc(path);
    await reference.set(
      data,
      SetOptions(merge: true),
    );
  }

  Future<void> deleteData({required String path}) async {
    final reference = firestore.doc(path);
    await reference.delete();
  }

  Future<void> updateDoc(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = firestore.doc(path);

    await reference.update(data);
  }

  Future<void> setDataIfExist({
    required String path,
    required VoidCallback ifExist,
    required VoidCallback ifNotExist,
  }) async {
    await firestore.doc(path).get().then((doc) async {
      if (doc.exists) {
        ifExist();
      } else {
        ifNotExist();
      }
    });
  }

  Future<bool> checkDocumentIfExist(String path) async {
    final reference = firestore.doc(path);
    return await reference.get().then((doc) {
      if (doc.exists) {
        return true;
      } else {
        return false;
      }
    });
  }

  Stream<T> getLastDocumentItem<T>(
      {required String path,
      required String orderBy,
      required T Function(Map<String, dynamic> data, String documentId)
          builder}) {
    final reference = firestore.collection(path);
    final snapshots =
        reference.orderBy(orderBy, descending: true).limit(1).snapshots();
    return snapshots.map((snapshot) =>
        builder(snapshot.docs.first.data(), snapshot.docs.first.id));
  }

  Query<T> collectionQuery<T>({
    required String path,
    required T Function(DocumentSnapshot<Map<String, dynamic>> snapshot,
            SnapshotOptions? options)
        fromMap,
    required Map<String, Object?> Function(T, SetOptions? options) toMap,
    Query<T> Function(Query<T>? query)? queryBuilder,
  }) {
    Query<T> query = firestore
        .collection(path)
        .withConverter<T>(fromFirestore: fromMap, toFirestore: toMap);
    if (queryBuilder != null) {
      return query = queryBuilder(query);
    } else {
      return query;
    }
  }

  Stream<List<T>> collectionStream<T>(
      {required String path,
      required T Function(Map<String, dynamic> data, String documentId) builder,
      Query Function(Query? query)? queryBuilder,
      int Function(T lhs, T rhs)? sort}) {
    Query query = firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) =>
              builder(snapshot.data() as Map<String, dynamic>, snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Future<List<T>> getCollections<T>(
      {required String path,
      required T Function(Map<String, dynamic> data, String documentId) builder,
      Query Function(Query? query)? queryBuilder,
      int Function(T lhs, T rhs)? sort}) {
    Query query = firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.get();
    return snapshots.then((snapshot) {
      final result = snapshot.docs
          .map((snapshot) =>
              builder(snapshot.data() as Map<String, dynamic>, snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Future<T> getDocument<T>(
      {required String path,
      required T Function(Map<String, dynamic> data, String documentId)
          builder}) async {
    final reference = firestore.doc(path);
    final snapshot = reference.get();
    return snapshot.then((snapshot) =>
        builder(snapshot.data() as Map<String, dynamic>, snapshot.id));
  }

  Stream<T> documentStream<T>(
      {required String path,
      required T Function(Map<String, dynamic>? data, String documentId)
          builder}) {
    final reference = firestore.doc(path);

    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }
}

final firestoreTestAppServiceProvider = Provider<FirestoreService>(
    (ref) => FirestoreService(firestore: FirebaseFirestore.instance));
