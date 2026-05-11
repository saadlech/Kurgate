import 'offre_touristique.dart';

class Restaurant extends OffreTouristique {
  final String specialite;
  final int capacite;
  final String horaires;
  final List<MenuItem> menuItems;

  const Restaurant({
    required super.idOffre,
    required super.nom,
    required super.prix,
    super.note,
    super.imageUrl,
    super.description,
    super.localisation,
    super.images,
    super.nbAvis,
    required this.specialite,
    required this.capacite,
    this.horaires = '',
    this.menuItems = const [],
  }) : super(type: 'Restaurant');

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['specialite'] = specialite;
    map['capacite'] = capacite;
    map['horaires'] = horaires;
    map['menuItems'] = menuItems.map((m) => m.toMap()).toList();
    return map;
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      idOffre: map['idOffre'] as String,
      nom: map['nom'] as String,
      prix: (map['prix'] as num).toDouble(),
      note: (map['note'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] as String?,
      description: map['description'] as String? ?? '',
      localisation: map['localisation'] as String? ?? '',
      images: (map['images'] as List<dynamic>?)?.cast<String>() ?? [],
      nbAvis: map['nbAvis'] as int? ?? 0,
      specialite: map['specialite'] as String,
      capacite: map['capacite'] as int,
      horaires: map['horaires'] as String? ?? '',
    );
  }

  @override
  String toString() {
    return 'Restaurant(idOffre: $idOffre, nom: $nom, specialite: $specialite, capacite: $capacite)';
  }
}

class MenuItem {
  final String nom;
  final String description;
  final int prix;

  const MenuItem({
    required this.nom,
    this.description = '',
    required this.prix,
  });

  Map<String, dynamic> toMap() => {
    'nom': nom,
    'description': description,
    'prix': prix,
  };

  factory MenuItem.fromMap(Map<String, dynamic> map) => MenuItem(
    nom: map['nom'] as String,
    description: map['description'] as String? ?? '',
    prix: map['prix'] as int,
  );
}
