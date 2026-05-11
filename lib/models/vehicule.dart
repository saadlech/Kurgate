class Vehicule {
  final String idVehicule;
  final String marque;
  final String modele;
  final int annee;
  final String typeCarburant;
  final String typeTransmission;
  final int nbPlaces;
  final double prixParJour;
  final String imageUrl;
  final bool estDisponible;
  final String description;
  final String agence;
  final double note;
  final int nbAvis;
  final String categorie;
  final List<String> images;

  const Vehicule({
    required this.idVehicule,
    required this.marque,
    required this.modele,
    required this.annee,
    required this.typeCarburant,
    required this.typeTransmission,
    required this.nbPlaces,
    required this.prixParJour,
    required this.imageUrl,
    this.estDisponible = true,
    this.description = '',
    this.agence = '',
    this.note = 0.0,
    this.nbAvis = 0,
    this.categorie = '',
    this.images = const [],
  });

  /// Display name combining brand and model
  String get nom => '$marque $modele';

  Map<String, dynamic> toMap() {
    return {
      'idVehicule': idVehicule,
      'marque': marque,
      'modele': modele,
      'annee': annee,
      'typeCarburant': typeCarburant,
      'typeTransmission': typeTransmission,
      'nbPlaces': nbPlaces,
      'prixParJour': prixParJour,
      'imageUrl': imageUrl,
      'estDisponible': estDisponible,
      'description': description,
      'agence': agence,
      'note': note,
      'nbAvis': nbAvis,
      'categorie': categorie,
      'images': images,
    };
  }

  factory Vehicule.fromMap(Map<String, dynamic> map) {
    return Vehicule(
      idVehicule: map['idVehicule'] as String,
      marque: map['marque'] as String,
      modele: map['modele'] as String,
      annee: map['annee'] as int,
      typeCarburant: map['typeCarburant'] as String,
      typeTransmission: map['typeTransmission'] as String,
      nbPlaces: map['nbPlaces'] as int,
      prixParJour: (map['prixParJour'] as num).toDouble(),
      imageUrl: map['imageUrl'] as String,
      estDisponible: map['estDisponible'] as bool? ?? true,
      description: map['description'] as String? ?? '',
      agence: map['agence'] as String? ?? '',
      note: (map['note'] as num?)?.toDouble() ?? 0.0,
      nbAvis: map['nbAvis'] as int? ?? 0,
      categorie: map['categorie'] as String? ?? '',
      images: (map['images'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  @override
  String toString() {
    return 'Vehicule(idVehicule: $idVehicule, marque: $marque, modele: $modele, annee: $annee, estDisponible: $estDisponible)';
  }
}
