import 'offre_touristique.dart';

class Experience extends OffreTouristique {
  final String duree;
  final int capacite;

  const Experience({
    super.id,
    required super.name,
    required super.location,
    required super.price,
    required super.rating,
    required super.reviews,
    required super.imageUrl,
    super.description,
    super.tags,
    super.category,
    super.images,
    required this.duree,
    required this.capacite,
  });

  /// Convert to Map (for Supabase database)
  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['duree'] = duree;
    map['capacite'] = capacite;
    return map;
  }

  /// Create from Map (from Supabase database)
  factory Experience.fromMap(Map<String, dynamic> map) {
    return Experience(
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
      duree: map['duree'] as String? ?? '',
      capacite: (map['capacite'] as num?)?.toInt() ?? 0,
    );
  }
}
