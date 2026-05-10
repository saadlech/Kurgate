class Chambre {
  final String idChambre;
  final String numero;
  final String typeChambre;
  final int capacite;
  final String imageUrl;
  final bool estDisponible;

  const Chambre({
    required this.idChambre,
    required this.numero,
    required this.typeChambre,
    required this.capacite,
    required this.imageUrl,
    this.estDisponible = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'idChambre': idChambre,
      'numero': numero,
      'typeChambre': typeChambre,
      'capacite': capacite,
      'imageUrl': imageUrl,
      'estDisponible': estDisponible,
    };
  }

  factory Chambre.fromMap(Map<String, dynamic> map) {
    return Chambre(
      idChambre: map['idChambre'] as String,
      numero: map['numero'] as String,
      typeChambre: map['typeChambre'] as String,
      capacite: map['capacite'] as int,
      imageUrl: map['imageUrl'] as String,
      estDisponible: map['estDisponible'] as bool? ?? true,
    );
  }

  @override
  String toString() {
    return 'Chambre(idChambre: $idChambre, numero: $numero, typeChambre: $typeChambre, estDisponible: $estDisponible)';
  }
}
