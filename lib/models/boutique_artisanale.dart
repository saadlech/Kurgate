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
    // Parse nested products if present (from joined query)
    final rawProducts = map['produits_boutique'] as List<dynamic>?;
    final parsedProducts = rawProducts != null
        ? rawProducts
            .map((p) => Produit.fromMap(p as Map<String, dynamic>))
            .toList()
        : <Produit>[];

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
      products: parsedProducts,
    );
  }
}

class Produit {
  final String id;
  final String boutiqueId;
  final String name;
  final int price;
  final String desc;
  final int stock;
  final String imageUrl;

  const Produit({
    this.id = '',
    this.boutiqueId = '',
    required this.name,
    required this.price,
    this.desc = '',
    this.stock = 10,
    this.imageUrl = '',
  });

  factory Produit.fromMap(Map<String, dynamic> map) => Produit(
        id: map['id'] as String? ?? '',
        boutiqueId: map['boutique_id'] as String? ?? '',
        name: map['nom'] as String? ?? '',
        price: (map['prix'] as num?)?.toInt() ?? 0,
        desc: map['description'] as String? ?? '',
        stock: (map['stock'] as num?)?.toInt() ?? 10,
        imageUrl: map['image_url'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'boutique_id': boutiqueId,
        'nom': name,
        'prix': price,
        'description': desc,
        'stock': stock,
        'image_url': imageUrl,
      };
}
