import 'offre_touristique.dart';

class Experience extends OffreTouristique {
  final String location;
  final int dureeEstimee;
  final int capaciteMax;

  const Experience({
    required super.idOffre,
    required super.nom,
    required super.prix,
    super.note,
    super.imageUrl,
    required this.location,
    required this.dureeEstimee,
    required this.capaciteMax,
  }) : super(type: 'Experience');

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['location'] = location;
    map['dureeEstimee'] = dureeEstimee;
    map['capaciteMax'] = capaciteMax;
    return map;
  }

  factory Experience.fromMap(Map<String, dynamic> map) {
    return Experience(
      idOffre: map['idOffre'] as String,
      nom: map['nom'] as String,
      prix: (map['prix'] as num).toDouble(),
      note: (map['note'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] as String?,
      location: map['location'] as String,
      dureeEstimee: map['dureeEstimee'] as int,
      capaciteMax: map['capaciteMax'] as int,
    );
  }

  @override
  String toString() {
    return 'Experience(idOffre: $idOffre, nom: $nom, location: $location, dureeEstimee: ${dureeEstimee}min)';
  }
}
