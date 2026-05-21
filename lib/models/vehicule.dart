class Vehicule {
  final String id;
  final String name;
  final int price;
  final double rating;
  final int reviews;
  final String imageUrl;
  final List<String> tags;
  final String category;
  final String transmission;
  final String carburant;
  final int places;
  final String description;
  final List<String> images;

  const Vehicule({
    this.id = '',
    required this.name,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    this.tags = const [],
    this.category = '',
    required this.transmission,
    required this.carburant,
    required this.places,
    this.description = '',
    this.images = const [],
  });

  /// Convert to Map (for Supabase database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'rating': rating,
      'reviews': reviews,
      'image_url': imageUrl,
      'tags': tags,
      'category': category,
      'transmission': transmission,
      'carburant': carburant,
      'places': places,
      'description': description,
      'images': images,
    };
  }

  /// Create from Map (from Supabase database)
  factory Vehicule.fromMap(Map<String, dynamic> map) {
    return Vehicule(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      price: (map['price'] as num?)?.toInt() ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      reviews: (map['reviews'] as num?)?.toInt() ?? 0,
      imageUrl: map['image_url'] as String? ?? '',
      tags: (map['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      category: map['category'] as String? ?? '',
      transmission: map['transmission'] as String? ?? '',
      carburant: map['carburant'] as String? ?? '',
      places: (map['places'] as num?)?.toInt() ?? 0,
      description: map['description'] as String? ?? '',
      images: (map['images'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}
