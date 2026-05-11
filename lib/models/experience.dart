import 'offre_touristique.dart';

class Experience extends OffreTouristique {
  final int dureeEstimee;   // in minutes
  final int capaciteMax;
  final String categorie;
  final List<String> inclus;  // what's included

  const Experience({
    required super.idOffre,
    required super.nom,
    required super.prix,
    super.note,
    super.imageUrl,
    super.description,
    super.localisation,
    super.images,
    super.nbAvis,
    required this.dureeEstimee,
    required this.capaciteMax,
    this.categorie = '',
    this.inclus = const [],
  }) : super(type: 'Experience');

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['dureeEstimee'] = dureeEstimee;
    map['capaciteMax'] = capaciteMax;
    map['categorie'] = categorie;
    map['inclus'] = inclus;
    return map;
  }

  factory Experience.fromMap(Map<String, dynamic> map) {
    return Experience(
      idOffre: map['idOffre'] as String,
      nom: map['nom'] as String,
      prix: (map['prix'] as num).toDouble(),
      note: (map['note'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] as String?,
      description: map['description'] as String? ?? '',
      localisation: map['localisation'] as String? ?? '',
      images: (map['images'] as List<dynamic>?)?.cast<String>() ?? [],
      nbAvis: map['nbAvis'] as int? ?? 0,
      dureeEstimee: map['dureeEstimee'] as int,
      capaciteMax: map['capaciteMax'] as int,
      categorie: map['categorie'] as String? ?? '',
      inclus: (map['inclus'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  @override
  String toString() {
    return 'Experience(idOffre: $idOffre, nom: $nom, localisation: $localisation, dureeEstimee: ${dureeEstimee}min)';
  }
}
