import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BookingType { hotel, vehicule, experience, restaurant }
enum BookingStatus { pending, paid, cancelled }

class Booking {
  final String id;
  final String itemId;  // source item ID (hotel_001, resto_001, etc.)
  final BookingType type;
  final String name;
  final String subtitle;
  final String imageUrl;
  final int totalPrice;
  final DateTime createdAt;
  final Map<String, String> details;
  final BookingStatus status;
  final int? rating;        // 1-5 stars
  final String? feedback;   // user comment

  const Booking({
    required this.id,
    required this.itemId,
    required this.type,
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    required this.totalPrice,
    required this.createdAt,
    required this.details,
    this.status = BookingStatus.pending,
    this.rating,
    this.feedback,
  });

  Booking copyWith({
    BookingStatus? status,
    int? rating,
    String? feedback,
  }) =>
      Booking(
        id: id,
        itemId: itemId,
        type: type,
        name: name,
        subtitle: subtitle,
        imageUrl: imageUrl,
        totalPrice: totalPrice,
        createdAt: createdAt,
        details: details,
        status: status ?? this.status,
        rating: rating ?? this.rating,
        feedback: feedback ?? this.feedback,
      );

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

  String get statusLabel {
    switch (status) {
      case BookingStatus.pending:
        return 'En attente';
      case BookingStatus.paid:
        return 'Payé';
      case BookingStatus.cancelled:
        return 'Annulé';
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

  void markAsPaid(String id) {
    state = state
        .map((b) => b.id == id ? b.copyWith(status: BookingStatus.paid) : b)
        .toList();
  }

  void cancelBooking(String id) {
    state = state
        .map((b) => b.id == id ? b.copyWith(status: BookingStatus.cancelled) : b)
        .toList();
  }

  void addFeedback(String id, int rating, String comment) {
    state = state
        .map((b) => b.id == id ? b.copyWith(rating: rating, feedback: comment) : b)
        .toList();
  }

  Booking? getBookingById(String id) {
    final matches = state.where((b) => b.id == id);
    return matches.isNotEmpty ? matches.first : null;
  }

  void clearAll() {
    state = [];
  }
}

final bookingProvider =
    StateNotifierProvider<BookingNotifier, List<Booking>>((ref) {
  return BookingNotifier();
});
