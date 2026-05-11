import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reservation.dart';

// Re-export Reservation so existing screen imports still work
export '../models/reservation.dart';

class ReservationNotifier extends StateNotifier<List<Reservation>> {
  ReservationNotifier() : super([]);

  void addBooking(Reservation r) {
    state = [...state, r];
  }

  void removeBooking(String id) {
    state = state.where((r) => r.idReservation != id).toList();
  }

  void markAsPaid(String id) {
    state = [
      for (final r in state)
        if (r.idReservation == id) r.payer() else r,
    ];
  }

  void cancelBooking(String id) {
    state = [
      for (final r in state)
        if (r.idReservation == id) r.annulerReservation() else r,
    ];
  }

  void addFeedback(String id, int note, String commentaire) {
    state = [
      for (final r in state)
        if (r.idReservation == id)
          r.copyWith(note: note, commentaire: commentaire)
        else
          r,
    ];
  }

  void clearAll() {
    state = [];
  }

  Reservation? getBookingById(String id) {
    final matches = state.where((r) => r.idReservation == id);
    return matches.isEmpty ? null : matches.first;
  }
}

final bookingProvider =
    StateNotifierProvider<ReservationNotifier, List<Reservation>>((ref) {
  return ReservationNotifier();
});
