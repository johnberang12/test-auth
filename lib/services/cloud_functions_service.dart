// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/domain/custom_token.dart';

class CloudFunctionsService {
  CloudFunctionsService({
    required this.ref,
  });
  final Ref ref;

  HttpsCallable _getCallable(String functionName) =>
      FirebaseFunctions.instanceFor(app: Firebase.app('test-auth'))
          .httpsCallable(functionName);

  Future<CustomToken?> createCustomToken({String? userId}) async {
    print('calling cloud functions...');
    final callable = _getCallable('createCustomToken');
    print('callable: $callable');

    try {
      final result = await callable.call({"uid": userId});
      final token = result.data['token'];
      final uid = result.data['uid'];
      print('token: $token');
      print('uid: $uid');
      final customToken = CustomToken(token: token, uid: uid);
      return customToken;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

final cloudFunctionsServiceProvider =
    Provider<CloudFunctionsService>((ref) => CloudFunctionsService(ref: ref));
