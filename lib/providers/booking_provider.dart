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
      final remote = await SupabaseService.fetchUserReservations();
      if (remote.isNotEmpty) {
        state = remote;
      }
    } catch (_) {
      // Silently fail — local state will still work
    }
  }

  /// Refresh from Supabase (pull-to-refresh, etc.)
  Future<void> refresh() async {
    try {
      final remote = await SupabaseService.fetchUserReservations();
      state = remote;
    } catch (_) {
      // keep current local state
    }
  }

  void addBooking(Reservation r) {
    state = [...state, r];
    // Persist to Supabase in the background
    _createRemote(r);
  }

  void removeBooking(String id) {
    state = state.where((r) => r.idReservation != id).toList();
    // Optionally delete from Supabase
    _updateStatusRemote(id, 'Supprimée');
  }

  void markAsPaid(String id) {
    state = [
      for (final r in state)
        if (r.idReservation == id) r.payer() else r,
    ];
    _updateStatusRemote(id, 'Payée');
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


  void clearAll() {
    state = [];
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
    } catch (_) {
      // Local state is source of truth during session
    }
  }

  Future<void> _updateFeedbackRemote(String id, int note, String commentaire) async {
    try {
      await SupabaseService.updateReservationFeedback(id, note, commentaire);
    } catch (_) {
      // Local state is source of truth during session
    }
  }
}

final bookingProvider =
    StateNotifierProvider<ReservationNotifier, List<Reservation>>((ref) {
  return ReservationNotifier();
});
