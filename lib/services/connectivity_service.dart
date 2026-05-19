import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stream provider that emits the current connectivity status.
/// Returns `true` when the device has an active network connection
/// (WiFi, mobile data, ethernet, etc.), `false` otherwise.
final connectivityProvider = StreamProvider<bool>((ref) {
  final connectivity = Connectivity();

  // Transform the connectivity stream into a simple bool
  return connectivity.onConnectivityChanged.map((results) {
    // results is a List<ConnectivityResult>
    return results.any((r) => r != ConnectivityResult.none);
  });
});

/// One-shot check for current connectivity (used at app startup)
Future<bool> checkConnectivity() async {
  final results = await Connectivity().checkConnectivity();
  return results.any((r) => r != ConnectivityResult.none);
}
