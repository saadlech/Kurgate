import 'offre_touristique.dart';

class BoutiqueArtisanale extends OffreTouristique {
  final String artisan;
  final String prixMoyen;
  final String horaires;
  final List<Produit> products;

  const BoutiqueArtisanale({
    super.id,
    required super.name,
    required super.location,
    super.price = 0,
    required super.rating,
    required super.reviews,
    required super.imageUrl,
    super.description,
    super.tags,
    super.category,
    super.images,
    required this.artisan,
    this.prixMoyen = '',
    this.horaires = '',
    this.products = const [],
  });

  /// Convert to Map (for Supabase database)
  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['artisan'] = artisan;
    map['prix_moyen'] = prixMoyen;
    map['horaires'] = horaires;
    return map;
  }

  /// Create from Map (from Supabase database)
  factory BoutiqueArtisanale.fromMap(Map<String, dynamic> map) {
    return BoutiqueArtisanale(
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
      artisan: map['artisan'] as String? ?? '',
      prixMoyen: map['prix_moyen'] as String? ?? '',
      horaires: map['horaires'] as String? ?? '',
    );
  }
}

class Produit {
  final String name;
  final String desc;
  final int price;

  const Produit(this.name, this.price, this.desc);
}
