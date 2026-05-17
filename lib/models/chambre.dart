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

  /// Convert to Map (for Supabase database)
  Map<String, dynamic> toMap() {
    return {
      'id': idChambre,
      'numero': numero,
      'type_chambre': typeChambre,
      'description': description,
      'capacite': capacite,
      'prix_par_nuit': prixParNuit,
      'image_url': imageUrl,
      'est_disponible': estDisponible,
    };
  }

  /// Create from Map (from Supabase database)
  factory Chambre.fromMap(Map<String, dynamic> map) {
    return Chambre(
      idChambre: map['id'] as String,
      numero: map['numero'] as String,
      typeChambre: map['type_chambre'] as String? ?? '',
      description: map['description'] as String? ?? '',
      capacite: (map['capacite'] as num?)?.toInt() ?? 0,
      prixParNuit: (map['prix_par_nuit'] as num?)?.toInt() ?? 0,
      imageUrl: map['image_url'] as String? ?? '',
      estDisponible: map['est_disponible'] as bool? ?? true,
    );
  }

  @override
  String toString() {
    return 'Chambre(idChambre: $idChambre, typeChambre: $typeChambre, capacite: $capacite, prixParNuit: $prixParNuit)';
  }
}
