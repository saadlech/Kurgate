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
}
