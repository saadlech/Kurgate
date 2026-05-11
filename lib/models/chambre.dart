class Chambre {
  final String idChambre;
  final String numero;
  final String typeChambre;
  final String description;
  final int capacite;
  final int prixParNuit;
  final String imageUrl;
  final bool estDisponible;

  const Chambre({
    required this.idChambre,
    required this.numero,
    required this.typeChambre,
    this.description = '',
    required this.capacite,
    this.prixParNuit = 0,
    required this.imageUrl,
    this.estDisponible = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'idChambre': idChambre,
      'numero': numero,
      'typeChambre': typeChambre,
      'description': description,
      'capacite': capacite,
      'prixParNuit': prixParNuit,
      'imageUrl': imageUrl,
      'estDisponible': estDisponible,
    };
  }

  factory Chambre.fromMap(Map<String, dynamic> map) {
    return Chambre(
      idChambre: map['idChambre'] as String,
      numero: map['numero'] as String,
      typeChambre: map['typeChambre'] as String,
      description: map['description'] as String? ?? '',
      capacite: map['capacite'] as int,
      prixParNuit: map['prixParNuit'] as int? ?? 0,
      imageUrl: map['imageUrl'] as String,
      estDisponible: map['estDisponible'] as bool? ?? true,
    );
  }

  @override
  String toString() {
    return 'Chambre(idChambre: $idChambre, typeChambre: $typeChambre, capacite: $capacite, prixParNuit: $prixParNuit)';
  }
}
