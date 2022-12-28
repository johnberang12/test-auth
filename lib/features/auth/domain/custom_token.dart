// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CustomToken {
  final String token;
  final String uid;
  CustomToken({
    required this.token,
    required this.uid,
  });

  CustomToken copyWith({
    String? token,
    String? uid,
  }) {
    return CustomToken(
      token: token ?? this.token,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'uid': uid,
    };
  }

  factory CustomToken.fromMap(Map<String, dynamic> map) {
    return CustomToken(
      token: map['token'] as String,
      uid: map['uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomToken.fromJson(String source) =>
      CustomToken.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CustomToken(token: $token, uid: $uid)';

  @override
  bool operator ==(covariant CustomToken other) {
    if (identical(this, other)) return true;

    return other.token == token && other.uid == uid;
  }

  @override
  int get hashCode => token.hashCode ^ uid.hashCode;
}
