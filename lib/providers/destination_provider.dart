import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/destination.dart';

// Selected destination — defaults to Marrakech
final selectedDestinationProvider = StateProvider<Destination>((ref) {
  return Destination.cities.first; // Marrakech
});

// All destinations
final destinationsProvider = Provider<List<Destination>>((ref) {
  return Destination.cities;
});
