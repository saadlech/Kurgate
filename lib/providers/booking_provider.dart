import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BookingType { hotel, vehicule, experience, restaurant }

class Booking {
  final String id;
  final BookingType type;
  final String name;
  final String subtitle;
  final String imageUrl;
  final int totalPrice;
  final DateTime createdAt;
  final Map<String, String> details;

  const Booking({
    required this.id,
    required this.type,
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    required this.totalPrice,
    required this.createdAt,
    required this.details,
  });

  String get typeLabel {
    switch (type) {
      case BookingType.hotel:
        return 'Hôtel';
      case BookingType.vehicule:
        return 'Véhicule';
      case BookingType.experience:
        return 'Expérience';
      case BookingType.restaurant:
        return 'Restaurant';
    }
  }

  String get typeIcon {
    switch (type) {
      case BookingType.hotel:
        return 'hotel';
      case BookingType.vehicule:
        return 'car';
      case BookingType.experience:
        return 'explore';
      case BookingType.restaurant:
        return 'restaurant';
    }
  }
}

class BookingNotifier extends StateNotifier<List<Booking>> {
  BookingNotifier() : super([]);

  void addBooking(Booking booking) {
    state = [booking, ...state];
  }

  void removeBooking(String id) {
    state = state.where((b) => b.id != id).toList();
  }

  void clearAll() {
    state = [];
  }
}

final bookingProvider =
    StateNotifierProvider<BookingNotifier, List<Booking>>((ref) {
  return BookingNotifier();
});
