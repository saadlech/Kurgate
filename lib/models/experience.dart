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
}
