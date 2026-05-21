import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/hotel.dart';
import '../models/restaurant.dart';
import '../models/experience.dart';
import '../models/boutique_artisanale.dart';
import '../models/vehicule.dart';
import '../services/supabase_service.dart';

/// Hotels for a given destination ID
final hotelsProvider = FutureProvider.family<List<Hotel>, String>((ref, destinationId) async {
  return SupabaseService.fetchHotels(destinationId);
});

/// Restaurants for a given destination ID
final restaurantsProvider = FutureProvider.family<List<Restaurant>, String>((ref, destinationId) async {
  return SupabaseService.fetchRestaurants(destinationId);
});

/// Experiences for a given destination ID
final experiencesProvider = FutureProvider.family<List<Experience>, String>((ref, destinationId) async {
  return SupabaseService.fetchExperiences(destinationId);
});

/// Boutiques for a given destination ID
final boutiquesProvider = FutureProvider.family<List<BoutiqueArtisanale>, String>((ref, destinationId) async {
  return SupabaseService.fetchBoutiques(destinationId);
});

/// Vehicules for a given destination ID
final vehiculesProvider = FutureProvider.family<List<Vehicule>, String>((ref, destinationId) async {
  return SupabaseService.fetchVehicules(destinationId);
});

/// Single hotel by ID
final hotelByIdProvider = FutureProvider.family<Hotel?, String>((ref, id) async {
  return SupabaseService.fetchHotelById(id);
});

/// Single restaurant by ID
final restaurantByIdProvider = FutureProvider.family<Restaurant?, String>((ref, id) async {
  return SupabaseService.fetchRestaurantById(id);
});

/// Single experience by ID
final experienceByIdProvider = FutureProvider.family<Experience?, String>((ref, id) async {
  return SupabaseService.fetchExperienceById(id);
});

/// Single boutique by ID
final boutiqueByIdProvider = FutureProvider.family<BoutiqueArtisanale?, String>((ref, id) async {
  return SupabaseService.fetchBoutiqueById(id);
});

/// Products for a given boutique ID
final produitsProvider = FutureProvider.family<List<Produit>, String>((ref, boutiqueId) async {
  return SupabaseService.fetchProduitsForBoutique(boutiqueId);
});

/// Single vehicule by ID
final vehiculeByIdProvider = FutureProvider.family<Vehicule?, String>((ref, id) async {
  return SupabaseService.fetchVehiculeById(id);
});
