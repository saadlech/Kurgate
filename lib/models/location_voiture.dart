import 'offre_touristique.dart';

class LocationVoiture extends OffreTouristique {
  final String typeVehicule;
  final String typeCarburant;
  final String typeTransmission;
  final int nbPlaces;
  final bool estDisponible;

  const LocationVoiture({
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
    required this.typeVehicule,
    required this.typeCarburant,
    required this.typeTransmission,
    required this.nbPlaces,
    this.estDisponible = true,
  });
}
