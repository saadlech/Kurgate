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

  /// Convert to Map (for Supabase database)
  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['stars'] = stars;
    return map;
  }

  /// Create from Map (from Supabase database)
  factory Hotel.fromMap(Map<String, dynamic> map) {
    return Hotel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      location: map['location'] as String? ?? '',
      price: (map['price'] as num?)?.toInt() ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      reviews: (map['reviews'] as num?)?.toInt() ?? 0,
      imageUrl: map['image_url'] as String? ?? '',
      description: map['description'] as String? ?? '',
      tags: (map['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      category: map['category'] as String? ?? '',
      images: (map['images'] as List<dynamic>?)?.cast<String>() ?? [],
      imageAssets: (map['images'] as List<dynamic>?)?.cast<String>() ?? [],
      stars: (map['stars'] as num?)?.toInt() ?? 0,
    );
  }
}
