import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/destination.dart';
import '../models/hotel.dart';
import '../models/restaurant.dart';
import '../models/experience.dart';
import '../models/boutique_artisanale.dart';
import '../models/vehicule.dart';
import '../models/reservation.dart';
import '../models/avis.dart';

/// Centralized Supabase data service for all catalog & user data operations.
class SupabaseService {
  static final _client = Supabase.instance.client;

  // ──────────── CATALOG (read-only) ────────────

  /// Fetch all destinations
  static Future<List<Destination>> fetchDestinations() async {
    final data = await _client.from('destinations').select().order('nom');
    return data.map((m) => Destination.fromMap(m)).toList();
  }

  /// Fetch hotels for a destination
  static Future<List<Hotel>> fetchHotels(String destinationId) async {
    final data = await _client
        .from('hotels')
        .select()
        .eq('destination_id', destinationId)
        .order('rating', ascending: false);
    return data.map((m) => Hotel.fromMap(m)).toList();
  }

  /// Fetch restaurants for a destination
  static Future<List<Restaurant>> fetchRestaurants(String destinationId) async {
    final data = await _client
        .from('restaurants')
        .select()
        .eq('destination_id', destinationId)
        .order('rating', ascending: false);
    return data.map((m) => Restaurant.fromMap(m)).toList();
  }

  /// Fetch experiences for a destination
  static Future<List<Experience>> fetchExperiences(String destinationId) async {
    final data = await _client
        .from('experiences')
        .select()
        .eq('destination_id', destinationId)
        .order('rating', ascending: false);
    return data.map((m) => Experience.fromMap(m)).toList();
  }

  /// Fetch all boutiques (global, not destination-specific)
  static Future<List<BoutiqueArtisanale>> fetchBoutiques(String destinationId) async {
    final data = await _client
        .from('boutiques_artisanales')
        .select('*, produits_boutique(*)')
        .order('rating', ascending: false);
    return data.map((m) => BoutiqueArtisanale.fromMap(m)).toList();
  }

  /// Fetch all vehicules (global, not destination-specific)
  static Future<List<Vehicule>> fetchVehicules(String destinationId) async {
    final data = await _client
        .from('vehicules')
        .select()
        .order('rating', ascending: false);
    return data.map((m) => Vehicule.fromMap(m)).toList();
  }

  /// Fetch a single hotel by ID
  static Future<Hotel?> fetchHotelById(String id) async {
    final data = await _client
        .from('hotels')
        .select()
        .eq('id', id)
        .maybeSingle();
    return data != null ? Hotel.fromMap(data) : null;
  }

  /// Fetch a single restaurant by ID
  static Future<Restaurant?> fetchRestaurantById(String id) async {
    final data = await _client
        .from('restaurants')
        .select()
        .eq('id', id)
        .maybeSingle();
    return data != null ? Restaurant.fromMap(data) : null;
  }

  /// Fetch a single experience by ID
  static Future<Experience?> fetchExperienceById(String id) async {
    final data = await _client
        .from('experiences')
        .select()
        .eq('id', id)
        .maybeSingle();
    return data != null ? Experience.fromMap(data) : null;
  }

  /// Fetch a single boutique by ID (with nested products)
  static Future<BoutiqueArtisanale?> fetchBoutiqueById(String id) async {
    final data = await _client
        .from('boutiques_artisanales')
        .select('*, produits_boutique(*)')
        .eq('id', id)
        .maybeSingle();
    return data != null ? BoutiqueArtisanale.fromMap(data) : null;
  }

  /// Fetch products for a specific boutique
  static Future<List<Produit>> fetchProduitsForBoutique(String boutiqueId) async {
    final data = await _client
        .from('produits_boutique')
        .select()
        .eq('boutique_id', boutiqueId)
        .order('nom');
    return data.map((m) => Produit.fromMap(m)).toList();
  }

  /// Fetch a single vehicule by ID
  static Future<Vehicule?> fetchVehiculeById(String id) async {
    final data = await _client
        .from('vehicules')
        .select()
        .eq('id', id)
        .maybeSingle();
    return data != null ? Vehicule.fromMap(data) : null;
  }

  // ──────────── RESERVATIONS ────────────

  /// Create a reservation
  static Future<void> createReservation(Reservation reservation) async {
    final map = reservation.toMap();
    map['user_id'] = _client.auth.currentUser?.id;
    await _client.from('reservations').insert(map);
  }

  /// Fetch current user's reservations via Edge Function (bypasses RLS)
  static Future<List<Reservation>> fetchUserReservations() async {
    final userId = _client.auth.currentUser?.id;
    print('[SupabaseService] fetchUserReservations userId=$userId');
    if (userId == null) return [];

    try {
      final uri = Uri.parse(
        'https://aurxykjqywoaiezwkvff.supabase.co/functions/v1/ai-agent',
      );
      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'apikey': 'sb_publishable_VwBR1xse_Z2Zgs4b0kjYhA_w54eXJP8',
        },
        body: jsonEncode({
          'question': '__get_bookings',
          'userId': userId,
        }),
      );

      if (res.statusCode != 200) {
        print('[SupabaseService] Edge Function error: ${res.statusCode}');
        return [];
      }

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final list = (data['reservations'] as List<dynamic>?) ?? [];
      print('[SupabaseService] Got ${list.length} reservations from Edge Function');
      return list
          .map((m) => Reservation.fromMap(m as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('[SupabaseService] fetchUserReservations error: $e');
      return [];
    }
  }

  /// Update reservation status via Edge Function (bypasses RLS)
  static Future<void> updateReservationStatus(String id, String statut) async {
    try {
      final uri = Uri.parse(
        'https://aurxykjqywoaiezwkvff.supabase.co/functions/v1/ai-agent',
      );
      await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'apikey': 'sb_publishable_VwBR1xse_Z2Zgs4b0kjYhA_w54eXJP8',
        },
        body: jsonEncode({
          'question': '__update_booking',
          'bookingId': id,
          'statut': statut,
        }),
      );
    } catch (e) {
      print('[SupabaseService] updateReservationStatus error: $e');
    }
  }

  /// Delete reservation from DB via Edge Function (bypasses RLS)
  static Future<void> deleteReservation(String id) async {
    try {
      final uri = Uri.parse(
        'https://aurxykjqywoaiezwkvff.supabase.co/functions/v1/ai-agent',
      );
      await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'apikey': 'sb_publishable_VwBR1xse_Z2Zgs4b0kjYhA_w54eXJP8',
        },
        body: jsonEncode({
          'question': '__delete_booking',
          'bookingId': id,
        }),
      );
    } catch (e) {
      print('[SupabaseService] deleteReservation error: $e');
    }
  }

  /// Update reservation feedback (note + commentaire)
  static Future<void> updateReservationFeedback(String id, int note, String commentaire) async {
    try {
      final uri = Uri.parse(
        'https://aurxykjqywoaiezwkvff.supabase.co/functions/v1/ai-agent',
      );
      await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'apikey': 'sb_publishable_VwBR1xse_Z2Zgs4b0kjYhA_w54eXJP8',
        },
        body: jsonEncode({
          'question': '__update_booking',
          'bookingId': id,
          'statut': 'Terminée',
          'note': note,
          'commentaire': commentaire,
        }),
      );
    } catch (e) {
      print('[SupabaseService] updateReservationFeedback error: $e');
    }
  }

  // ──────────── COMMANDES (Cart Orders) ────────────

  /// Create a commande from cart checkout
  static Future<void> createCommande(Map<String, dynamic> commande) async {
    commande['user_id'] = _client.auth.currentUser?.id;
    await _client.from('commandes').insert(commande);
  }

  /// Fetch current user's commandes
  static Future<List<Map<String, dynamic>>> fetchUserCommandes() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];
    final data = await _client
        .from('commandes')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  /// Delete a single commande by ID
  static Future<void> deleteCommande(String id) async {
    await _client.from('commandes').delete().eq('id', id);
  }

  /// Delete all commandes for the current user
  static Future<void> deleteAllCommandes() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;
    await _client.from('commandes').delete().eq('user_id', userId);
  }

  // ──────────── AVIS (Reviews) ────────────

  /// Fetch reviews for an item
  static Future<List<Avis>> fetchAvisForItem(String itemId) async {
    final data = await _client
        .from('avis')
        .select()
        .eq('item_id', itemId)
        .order('date_publication', ascending: false);
    return data.map((m) => Avis.fromMap(m)).toList();
  }

  /// Create a review
  static Future<void> createAvis(Avis avis) async {
    await _client.from('avis').insert(avis.toMap());
  }

  // ──────────── SEMANTIC SEARCH (stub) ────────────
  // item_embeddings table was dropped; this returns empty to keep UI working.
  static Future<List<Map<String, dynamic>>> semanticSearch({
    required String query,
    String? destinationId,
    String? itemType,
    int limit = 10,
  }) async {
    return [];
  }
}
