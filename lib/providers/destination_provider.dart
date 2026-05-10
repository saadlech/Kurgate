import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/destination.dart';

// Selected destination
final selectedDestinationProvider = StateProvider<Destination?>((ref) => null);

// All destinations
final destinationsProvider = Provider<List<Destination>>((ref) {
  return Destination.cities;
});
