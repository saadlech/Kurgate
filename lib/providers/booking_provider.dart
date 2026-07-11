import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reservation.dart';
import '../services/supabase_service.dart';

// Re-export Reservation so existing screen imports still work
export '../models/reservation.dart';

class ReservationNotifier extends StateNotifier<List<Reservation>> {
  ReservationNotifier() : super([]) {
    _loadFromSupabase();
  }

  /// Load existing reservations from Supabase on init
  Future<void> _loadFromSupabase() async {
    try {
      print('[BookingProvider] Loading reservations...');
      final remote = await SupabaseService.fetchUserReservations();
      print('[BookingProvider] Fetched ${remote.length} reservations');
      if (remote.isNotEmpty) {
        state = remote;
      }
    } catch (e) {
      print('[BookingProvider] Error loading reservations: $e');
    }
  }

  /// Refresh from Supabase (pull-to-refresh, etc.)
  Future<void> refresh() async {
    try {
      print('[BookingProvider] Refreshing reservations...');
      final remote = await SupabaseService.fetchUserReservations();
      print('[BookingProvider] Refresh got ${remote.length} reservations');
      state = remote;
    } catch (e) {
      print('[BookingProvider] Refresh error: $e');
    }
  }

  void addBooking(Reservation r) {
    state = [...state, r];
    // Persist to Supabase in the background
    _createRemote(r);
  }

  /// Add a booking to local state only (already persisted by Edge Function)
  void addBookingLocal(Reservation r) {
    state = [...state, r];
  }

  void removeBooking(String id) {
    state = state.where((r) => r.idReservation != id).toList();
    // Actually delete from Supabase DB
    _deleteRemote(id);
  }

  void markAsPaid(String id) {
    state = [
      for (final r in state)
        if (r.idReservation == id) r.payer() else r,
    ];
    _updateStatusRemote(id, 'Payée');
  }

  /// Mark multiple reservations as paid in one shot.
  void markMultipleAsPaid(List<String> ids) {
    final idSet = ids.toSet();
    state = [
      for (final r in state)
        if (idSet.contains(r.idReservation)) r.payer() else r,
    ];
    // Sync all to Supabase in parallel
    for (final id in ids) {
      _updateStatusRemote(id, 'Payée');
    }
  }


  void cancelBooking(String id) {
    state = [
      for (final r in state)
        if (r.idReservation == id) r.annulerReservation() else r,
    ];
    _updateStatusRemote(id, 'Annulée');
  }

  void addFeedback(String id, int note, String commentaire) {
    state = [
      for (final r in state)
        if (r.idReservation == id)
          r.copyWith(note: note, commentaire: commentaire)
        else
          r,
    ];
    // Sync feedback to Supabase
    _updateFeedbackRemote(id, note, commentaire);
  }


  Future<void> clearAll() async {
    final ids = state.map((r) => r.idReservation).toList();
    state = [];
    // Delete all from DB in parallel
    await Future.wait(ids.map((id) => _deleteRemote(id)));
  }

  Reservation? getBookingById(String id) {
    final matches = state.where((r) => r.idReservation == id);
    return matches.isEmpty ? null : matches.first;
  }

  // ── Supabase persistence helpers (fire-and-forget) ──

  Future<void> _createRemote(Reservation r) async {
    try {
      await SupabaseService.createReservation(r);
    } catch (_) {
      // Local state is source of truth during session
    }
  }

  Future<void> _updateStatusRemote(String id, String statut) async {
    try {
      await SupabaseService.updateReservationStatus(id, statut);
    } catch (e) {
      print('[BookingProvider] _updateStatusRemote error: $e');
    }
  }

  Future<void> _deleteRemote(String id) async {
    try {
      await SupabaseService.deleteReservation(id);
    } catch (e) {
      print('[BookingProvider] _deleteRemote error: $e');
    }
  }

  Future<void> _updateFeedbackRemote(String id, int note, String commentaire) async {
    try {
      await SupabaseService.updateReservationFeedback(id, note, commentaire);
    } catch (e) {
      print('[BookingProvider] _updateFeedbackRemote error: $e');
    }
  }
}

final bookingProvider =
    StateNotifierProvider<ReservationNotifier, List<Reservation>>((ref) {
  return ReservationNotifier();
});
