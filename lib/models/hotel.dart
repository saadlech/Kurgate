import 'offre_touristique.dart';

class Hotel extends OffreTouristique {
  final int stars;
  final List<String> imageAssets;

  const Hotel({
    super.id,
    required super.name,
    super.location,
    super.price,
    super.rating = 0,
    super.reviews = 0,
    required super.imageUrl,
    super.description,
    super.tags,
    super.category,
    super.images,
    this.stars = 0,
    this.imageAssets = const [],
  });
}
