import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/review_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/feedback_sheet.dart';

class ReviewsSection extends ConsumerWidget {
  final String itemId;
  final String itemName;
  final String itemType; // 'Hôtel', 'Restaurant', etc.

  const ReviewsSection({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.itemType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(reviewProvider.select(
      (all) => all.where((r) => r.itemId == itemId).toList(),
    ));
    final auth = ref.watch(authProvider);
    final userId = auth.currentUser?.id ?? '';
    final hasReviewed = reviews.any((r) => r.userId == userId);
    final avg = reviews.isEmpty
        ? 0.0
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Icon(Icons.reviews_rounded, color: const Color(0xFFFF8C00), size: 20),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Avis des voyageurs',
                style: TextStyle(
                  fontFamily: 'DarkerGrotesque',
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (reviews.isNotEmpty) ...[
              ...List.generate(5, (i) => Icon(
                i < avg.round() ? Icons.star_rounded : Icons.star_border_rounded,
                color: const Color(0xFFFF8C00), size: 16,
              )),
              const SizedBox(width: 4),
              Text(
                '${avg.toStringAsFixed(1)} (${reviews.length})',
                style: TextStyle(
                  fontFamily: 'DarkerGrotesque',
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),

        // Write review button
        if (!hasReviewed && auth.isAuthenticated)
          GestureDetector(
            onTap: () => _showReviewSheet(context, ref),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF8C00).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFF8C00).withValues(alpha: 0.25),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit_rounded, size: 16, color: Color(0xFFFF8C00)),
                  SizedBox(width: 8),
                  Text(
                    'Donner mon avis',
                    style: TextStyle(
                      fontFamily: 'DarkerGrotesque',
                      color: Color(0xFFFF8C00),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Reviews list
        if (reviews.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Icon(Icons.rate_review_outlined,
                    color: Colors.white.withValues(alpha: 0.12), size: 36),
                const SizedBox(height: 8),
                Text(
                  'Aucun avis pour le moment',
                  style: TextStyle(
                    fontFamily: 'DarkerGrotesque',
                    color: Colors.white.withValues(alpha: 0.25),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        else
          ...reviews.map((r) => _ReviewCard(review: r)),
      ],
    );
  }

  void _showReviewSheet(BuildContext context, WidgetRef ref) {
    final user = ref.read(authProvider).currentUser;
    if (user == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FeedbackSheet(
        bookingName: itemName,
        bookingType: itemType,
        onSubmit: (rating, comment) {
          ref.read(reviewProvider.notifier).addReview(Review(
            id: '${itemId}_${user.id}',
            itemId: itemId,
            userId: user.id,
            userName: user.nom,
            rating: rating,
            comment: comment,
            createdAt: DateTime.now(),
          ));
        },
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User + stars
          Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFF8C00).withValues(alpha: 0.15),
                ),
                child: Center(
                  child: Text(
                    review.userName.isNotEmpty ? review.userName[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontFamily: 'DarkerGrotesque',
                      color: Color(0xFFFF8C00),
                      fontSize: 14, fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName, style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                    Text(
                      '${review.createdAt.day.toString().padLeft(2, '0')}/${review.createdAt.month.toString().padLeft(2, '0')}/${review.createdAt.year}',
                      style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.25), fontSize: 11),
                    ),
                  ],
                ),
              ),
              ...List.generate(5, (i) => Icon(
                i < review.rating ? Icons.star_rounded : Icons.star_border_rounded,
                color: const Color(0xFFFF8C00), size: 14,
              )),
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              review.comment,
              style: TextStyle(
                fontFamily: 'DarkerGrotesque',
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 13, height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
