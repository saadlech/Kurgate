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
}

class Produit {
  final String name;
  final String desc;
  final int price;

  const Produit(this.name, this.price, this.desc);
}
