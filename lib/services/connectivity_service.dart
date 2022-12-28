import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService extends StateNotifier<bool> {
  ConnectivityService({bool value = false}) : super(value) {
    _initConnection();
  }
  bool get connection => state;
  // Connectivity connectivity = Connectivity();

  ConnectivityResult? connectionMedium;
  final StreamController<bool> _connectionChangeController =
      StreamController.broadcast();
  late StreamSubscription _subscription;

  _initConnection() {
    _subscription = Connectivity().onConnectivityChanged.listen((event) async {
      await Future.delayed(const Duration(seconds: 1));
      // checkInternetConnection();
      final result = await InternetConnectionChecker().hasConnection;
      state = result;

      if (state == true) {
        Fluttertoast.showToast(
            msg: 'Connected', toastLength: Toast.LENGTH_LONG);
      } else {
        Fluttertoast.showToast(
            msg: 'Lost connection', toastLength: Toast.LENGTH_LONG);
      }
      // print('connection is $state');
    });
  }

  Future<bool> checkInternetConnection() async {
    // bool previousConnection = hasConnection;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        state = true;
      } else {
        state = false;
      }
    } on SocketException catch (_) {
      state = false;
    }
    // if (previousConnection != hasConnection) {
    //   _connectionChangeController.add(hasConnection);
    // }
    return state;
  }

  @override
  void dispose() {
    _connectionChangeController.close();
    _subscription.cancel();
    super.dispose();
  }
}

final connectivityServiceProvider =
    StateNotifierProvider<ConnectivityService, bool>(
        (ref) => ConnectivityService());

final mockConnectionProvider = StateNotifierProvider<ConnectivityService, bool>(
    (ref) => ConnectivityService(value: true));
final mockNoConnectionProvider =
    StateNotifierProvider<ConnectivityService, bool>(
        (ref) => ConnectivityService(value: false));
