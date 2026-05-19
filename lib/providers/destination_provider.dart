import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/destination.dart';
import '../services/supabase_service.dart';

// Selected destination — defaults to Marrakech
final selectedDestinationProvider = StateProvider<Destination>((ref) {
  return Destination.cities.first; // Marrakech
});

// All destinations — fetched from Supabase with static fallback
final destinationsProvider = FutureProvider<List<Destination>>((ref) async {
  try {
    final remote = await SupabaseService.fetchDestinations();
    if (remote.isNotEmpty) return remote;
  } catch (_) {
    // Supabase unavailable — fall back to static list
  }
  return Destination.cities;
});
