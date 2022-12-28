// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class TestItem {
  TestItem({
    required this.id,
    required this.title,
    required this.location,
    required this.boostedAt,
    required this.boosted,
    required this.geoHash,
  });
  final String id;
  final String title;
  final GeoPoint location;
  final String boostedAt;
  final bool boosted;
  final String geoHash;

  TestItem copyWith({
    String? id,
    String? title,
    GeoPoint? location,
    String? boostedAt,
    bool? boosted,
    String? geoHash,
  }) {
    return TestItem(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      boostedAt: boostedAt ?? this.boostedAt,
      boosted: boosted ?? this.boosted,
      geoHash: geoHash ?? this.geoHash,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'location': location,
      'boostedAt': boostedAt,
      'boosted': boosted,
      'geoHash': geoHash,
    };
  }

  factory TestItem.fromMap(Map<String, dynamic> map) {
    return TestItem(
      id: map['id'] as String,
      title: map['title'] as String,
      location: map['location'] as GeoPoint,
      boostedAt: map['boostedAt'] as String,
      boosted: map['boosted'] as bool,
      geoHash: map['geoHash'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TestItem.fromJson(String source) =>
      TestItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TestItem(id: $id, title: $title, location: $location, boostedAt: $boostedAt, boosted: $boosted, geoHash: $geoHash)';
  }

  @override
  bool operator ==(covariant TestItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.location == location &&
        other.boostedAt == boostedAt &&
        other.boosted == boosted &&
        other.geoHash == geoHash;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        location.hashCode ^
        boostedAt.hashCode ^
        boosted.hashCode ^
        geoHash.hashCode;
  }
}
