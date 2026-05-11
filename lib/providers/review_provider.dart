import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/avis.dart';

class ReviewNotifier extends StateNotifier<List<Avis>> {
  ReviewNotifier() : super(_seedReviews);

  /// Add a review (one per user per item)
  bool addReview(Avis avis) {
    final exists = state.any(
      (r) => r.itemId == avis.itemId && r.userId == avis.userId,
    );
    if (exists) return false;
    state = [avis, ...state];
    return true;
  }

  /// Get all reviews for a specific item
  List<Avis> reviewsFor(String itemId) =>
      state.where((r) => r.itemId == itemId).toList();

  /// Check if a user already reviewed an item
  bool hasReviewed(String itemId, String userId) =>
      state.any((r) => r.itemId == itemId && r.userId == userId);

  /// Average rating for an item
  double avgRating(String itemId) {
    final reviews = reviewsFor(itemId);
    if (reviews.isEmpty) return 0;
    return reviews.map((r) => r.note).reduce((a, b) => a + b) / reviews.length;
  }
}

// Seed data so screens aren't empty on first launch
final _seedReviews = <Avis>[
  Avis(idAvis: 's1', itemId: 'hotel_001', userId: 'seed_1', userName: 'Amina B.', note: 5, commentaire: 'Un séjour exceptionnel, le service était parfait !', datePublication: DateTime(2026, 4, 28)),
  Avis(idAvis: 's2', itemId: 'hotel_001', userId: 'seed_2', userName: 'Youssef K.', note: 4, commentaire: 'Très bel hôtel, piscine magnifique.', datePublication: DateTime(2026, 5, 1)),
  Avis(idAvis: 's3', itemId: 'hotel_002', userId: 'seed_1', userName: 'Amina B.', note: 5, commentaire: 'Le riad le plus charmant de Marrakech.', datePublication: DateTime(2026, 4, 20)),
  Avis(idAvis: 's4', itemId: 'resto_001', userId: 'seed_3', userName: 'Fatima Z.', note: 5, commentaire: 'La meilleure cuisine marocaine que j\'ai goûtée !', datePublication: DateTime(2026, 5, 3)),
  Avis(idAvis: 's5', itemId: 'resto_001', userId: 'seed_2', userName: 'Youssef K.', note: 4, commentaire: 'Ambiance superbe, plats délicieux.', datePublication: DateTime(2026, 5, 5)),
  Avis(idAvis: 's6', itemId: 'exp_001', userId: 'seed_1', userName: 'Amina B.', note: 5, commentaire: 'Une expérience inoubliable dans le désert !', datePublication: DateTime(2026, 4, 15)),
  Avis(idAvis: 's7', itemId: 'boutique_001', userId: 'seed_3', userName: 'Fatima Z.', note: 4, commentaire: 'De très beaux produits artisanaux.', datePublication: DateTime(2026, 5, 2)),
];

final reviewProvider =
    StateNotifierProvider<ReviewNotifier, List<Avis>>((ref) {
  return ReviewNotifier();
});
