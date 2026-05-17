import 'offre_touristique.dart';

class Restaurant extends OffreTouristique {
  final String specialite;
  final int capacite;
  final String horaires;

  const Restaurant({
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
    required this.specialite,
    this.capacite = 0,
    this.horaires = '',
  });

  /// Convert to Map (for Supabase database)
  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['specialite'] = specialite;
    map['capacite'] = capacite;
    map['horaires'] = horaires;
    return map;
  }

  /// Create from Map (from Supabase database)
  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
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
      specialite: map['specialite'] as String? ?? '',
      capacite: (map['capacite'] as num?)?.toInt() ?? 0,
      horaires: map['horaires'] as String? ?? '',
    );
  }
}
