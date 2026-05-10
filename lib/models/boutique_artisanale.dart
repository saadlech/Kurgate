import 'offre_touristique.dart';

class BoutiqueArtisanale extends OffreTouristique {
  final String nomArtisan;
  final String typeArtisanat;

  const BoutiqueArtisanale({
    required super.idOffre,
    required super.nom,
    required super.prix,
    super.note,
    super.imageUrl,
    required this.nomArtisan,
    required this.typeArtisanat,
  }) : super(type: 'BoutiqueArtisanale');

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['nomArtisan'] = nomArtisan;
    map['typeArtisanat'] = typeArtisanat;
    return map;
  }

  factory BoutiqueArtisanale.fromMap(Map<String, dynamic> map) {
    return BoutiqueArtisanale(
      idOffre: map['idOffre'] as String,
      nom: map['nom'] as String,
      prix: (map['prix'] as num).toDouble(),
      note: (map['note'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] as String?,
      nomArtisan: map['nomArtisan'] as String,
      typeArtisanat: map['typeArtisanat'] as String,
    );
  }

  @override
  String toString() {
    return 'BoutiqueArtisanale(idOffre: $idOffre, nom: $nom, nomArtisan: $nomArtisan)';
  }
}
