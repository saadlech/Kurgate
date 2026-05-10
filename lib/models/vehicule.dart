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
  });

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
    );
  }

  @override
  String toString() {
    return 'Vehicule(idVehicule: $idVehicule, marque: $marque, modele: $modele, annee: $annee, estDisponible: $estDisponible)';
  }
}
