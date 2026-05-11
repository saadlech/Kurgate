import 'offre_touristique.dart';
import 'chambre.dart';

class Hotel extends OffreTouristique {
  final int nbEtoiles;
  final List<Chambre> chambres;

  const Hotel({
    required super.idOffre,
    required super.nom,
    required super.prix,
    super.note,
    super.imageUrl,
    super.description,
    super.localisation,
    super.images,
    super.nbAvis,
    required this.nbEtoiles,
    this.chambres = const [],
  }) : super(type: 'Hotel');

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['nbEtoiles'] = nbEtoiles;
    map['chambres'] = chambres.map((c) => c.toMap()).toList();
    return map;
  }

  factory Hotel.fromMap(Map<String, dynamic> map) {
    return Hotel(
      idOffre: map['idOffre'] as String,
      nom: map['nom'] as String,
      prix: (map['prix'] as num).toDouble(),
      note: (map['note'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] as String?,
      description: map['description'] as String? ?? '',
      localisation: map['localisation'] as String? ?? '',
      images: (map['images'] as List<dynamic>?)?.cast<String>() ?? [],
      nbAvis: map['nbAvis'] as int? ?? 0,
      nbEtoiles: map['nbEtoiles'] as int,
      chambres: (map['chambres'] as List<dynamic>?)
              ?.map((c) => Chambre.fromMap(c as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  @override
  String toString() {
    return 'Hotel(idOffre: $idOffre, nom: $nom, localisation: $localisation, nbEtoiles: $nbEtoiles)';
  }
}
