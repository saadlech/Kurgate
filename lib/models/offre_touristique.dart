/// Base class for all tourist offerings (hotels, restaurants, experiences, etc.)
class OffreTouristique {
  final String id;
  final String name;
  final String location;
  final int price;
  final double rating;
  final int reviews;
  final String imageUrl;
  final String description;
  final List<String> tags;
  final String category;
  final List<String> images;

  const OffreTouristique({
    this.id = '',
    required this.name,
    this.location = '',
    this.price = 0,
    this.rating = 0,
    this.reviews = 0,
    this.imageUrl = '',
    this.description = '',
    this.tags = const [],
    this.category = '',
    this.images = const [],
  });

  /// Convert to Map (for Supabase database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'price': price,
      'rating': rating,
      'reviews': reviews,
      'image_url': imageUrl,
      'description': description,
      'tags': tags,
      'category': category,
      'images': images,
    };
  }

  /// Create from Map (from Supabase database)
  factory OffreTouristique.fromMap(Map<String, dynamic> map) {
    return OffreTouristique(
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
    );
  }
}
