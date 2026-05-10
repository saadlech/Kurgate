import 'offre_touristique.dart';

class Restaurant extends OffreTouristique {
  final String specialite;
  final int capacite;

  const Restaurant({
    required super.idOffre,
    required super.nom,
    required super.prix,
    super.note,
    super.imageUrl,
    required this.specialite,
    required this.capacite,
  }) : super(type: 'Restaurant');

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['specialite'] = specialite;
    map['capacite'] = capacite;
    return map;
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      idOffre: map['idOffre'] as String,
      nom: map['nom'] as String,
      prix: (map['prix'] as num).toDouble(),
      note: (map['note'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] as String?,
      specialite: map['specialite'] as String,
      capacite: map['capacite'] as int,
    );
  }

  @override
  String toString() {
    return 'Restaurant(idOffre: $idOffre, nom: $nom, specialite: $specialite, capacite: $capacite)';
  }
}
