import 'offre_touristique.dart';
import 'vehicule.dart';

class LocationVoiture extends OffreTouristique {
  final String agence;
  final String typeVehicule;
  final String lieuPriseEnCharge;
  final List<Vehicule> vehicules;

  const LocationVoiture({
    required super.idOffre,
    required super.nom,
    required super.prix,
    super.note,
    super.imageUrl,
    required this.agence,
    required this.typeVehicule,
    required this.lieuPriseEnCharge,
    this.vehicules = const [],
  }) : super(type: 'LocationVoiture');

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['agence'] = agence;
    map['typeVehicule'] = typeVehicule;
    map['lieuPriseEnCharge'] = lieuPriseEnCharge;
    map['vehicules'] = vehicules.map((v) => v.toMap()).toList();
    return map;
  }

  factory LocationVoiture.fromMap(Map<String, dynamic> map) {
    return LocationVoiture(
      idOffre: map['idOffre'] as String,
      nom: map['nom'] as String,
      prix: (map['prix'] as num).toDouble(),
      note: (map['note'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] as String?,
      agence: map['agence'] as String,
      typeVehicule: map['typeVehicule'] as String,
      lieuPriseEnCharge: map['lieuPriseEnCharge'] as String,
      vehicules: (map['vehicules'] as List<dynamic>?)
              ?.map((v) => Vehicule.fromMap(v as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  @override
  String toString() {
    return 'LocationVoiture(idOffre: $idOffre, nom: $nom, agence: $agence, typeVehicule: $typeVehicule)';
  }
}
