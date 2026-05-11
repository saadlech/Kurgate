import 'offre_touristique.dart';
import 'produit.dart';

class BoutiqueArtisanale extends OffreTouristique {
  final String nomArtisan;
  final String typeArtisanat;
  final String horaires;
  final List<Produit> produits;

  const BoutiqueArtisanale({
    required super.idOffre,
    required super.nom,
    required super.prix,
    super.note,
    super.imageUrl,
    super.description,
    super.localisation,
    super.images,
    super.nbAvis,
    required this.nomArtisan,
    required this.typeArtisanat,
    this.horaires = '',
    this.produits = const [],
  }) : super(type: 'BoutiqueArtisanale');

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['nomArtisan'] = nomArtisan;
    map['typeArtisanat'] = typeArtisanat;
    map['horaires'] = horaires;
    map['produits'] = produits.map((p) => p.toMap()).toList();
    return map;
  }

  factory BoutiqueArtisanale.fromMap(Map<String, dynamic> map) {
    return BoutiqueArtisanale(
      idOffre: map['idOffre'] as String,
      nom: map['nom'] as String,
      prix: (map['prix'] as num).toDouble(),
      note: (map['note'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] as String?,
      description: map['description'] as String? ?? '',
      localisation: map['localisation'] as String? ?? '',
      images: (map['images'] as List<dynamic>?)?.cast<String>() ?? [],
      nbAvis: map['nbAvis'] as int? ?? 0,
      nomArtisan: map['nomArtisan'] as String,
      typeArtisanat: map['typeArtisanat'] as String,
      horaires: map['horaires'] as String? ?? '',
      produits: (map['produits'] as List<dynamic>?)
              ?.map((p) => Produit.fromMap(p as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  @override
  String toString() {
    return 'BoutiqueArtisanale(idOffre: $idOffre, nom: $nom, nomArtisan: $nomArtisan)';
  }
}
