import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NetworkBloc extends Cubit<bool> {
  final Connectivity _connectivity;
  late StreamSubscription _subscription;

  NetworkBloc({required Connectivity connectivity})
    : _connectivity = connectivity,
      super(true) {
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      emit(result != ConnectivityResult.none);
    });
    _init();
  }

  Future<void> _init() async {
    final result = await _connectivity.checkConnectivity();
    emit(result != ConnectivityResult.none);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
