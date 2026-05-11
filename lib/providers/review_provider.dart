import 'package:flutter_riverpod/flutter_riverpod.dart';

class Review {
  final String id;
  final String itemId;       // hotel_1, resto_1, etc.
  final String userId;
  final String userName;
  final int rating;           // 1-5
  final String comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.itemId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}

class ReviewNotifier extends StateNotifier<List<Review>> {
  ReviewNotifier() : super(_seedReviews);

  /// Add a review (one per user per item)
  bool addReview(Review review) {
    final exists = state.any(
      (r) => r.itemId == review.itemId && r.userId == review.userId,
    );
    if (exists) return false; // already reviewed
    state = [review, ...state];
    return true;
  }

  /// Get all reviews for a specific item
  List<Review> reviewsFor(String itemId) =>
      state.where((r) => r.itemId == itemId).toList();

  /// Check if a user already reviewed an item
  bool hasReviewed(String itemId, String userId) =>
      state.any((r) => r.itemId == itemId && r.userId == userId);

  /// Average rating for an item
  double avgRating(String itemId) {
    final reviews = reviewsFor(itemId);
    if (reviews.isEmpty) return 0;
    return reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
  }
}

// Seed data so screens aren't empty on first launch
final _seedReviews = <Review>[
  Review(id: 's1', itemId: 'hotel_1', userId: 'seed_1', userName: 'Amina B.', rating: 5, comment: 'Un séjour exceptionnel, le service était parfait !', createdAt: DateTime(2026, 4, 28)),
  Review(id: 's2', itemId: 'hotel_1', userId: 'seed_2', userName: 'Youssef K.', rating: 4, comment: 'Très bel hôtel, piscine magnifique.', createdAt: DateTime(2026, 5, 1)),
  Review(id: 's3', itemId: 'hotel_2', userId: 'seed_1', userName: 'Amina B.', rating: 5, comment: 'Le riad le plus charmant de Marrakech.', createdAt: DateTime(2026, 4, 20)),
  Review(id: 's4', itemId: 'resto_1', userId: 'seed_3', userName: 'Fatima Z.', rating: 5, comment: 'La meilleure cuisine marocaine que j\'ai goûtée !', createdAt: DateTime(2026, 5, 3)),
  Review(id: 's5', itemId: 'resto_1', userId: 'seed_2', userName: 'Youssef K.', rating: 4, comment: 'Ambiance superbe, plats délicieux.', createdAt: DateTime(2026, 5, 5)),
  Review(id: 's6', itemId: 'exp_1', userId: 'seed_1', userName: 'Amina B.', rating: 5, comment: 'Une expérience inoubliable dans le désert !', createdAt: DateTime(2026, 4, 15)),
  Review(id: 's7', itemId: 'boutique_1', userId: 'seed_3', userName: 'Fatima Z.', rating: 4, comment: 'De très beaux produits artisanaux.', createdAt: DateTime(2026, 5, 2)),
];

final reviewProvider =
    StateNotifierProvider<ReviewNotifier, List<Review>>((ref) {
  return ReviewNotifier();
});
