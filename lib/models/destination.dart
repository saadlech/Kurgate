class Destination {
  final String idDestination;
  final String nom;
  final String sousTitre;
  final String imageUrl;
  final bool estDisponible;

  const Destination({
    required this.idDestination,
    required this.nom,
    required this.sousTitre,
    required this.imageUrl,
    this.estDisponible = false,
  });

  /// Convert to Map (for Supabase database)
  Map<String, dynamic> toMap() {
    return {
      'id': idDestination,
      'nom': nom,
      'sous_titre': sousTitre,
      'image_url': imageUrl,
      'est_disponible': estDisponible,
    };
  }

  /// Create from Map (from Supabase database)
  factory Destination.fromMap(Map<String, dynamic> map) {
    return Destination(
      idDestination: map['id'] as String,
      nom: map['nom'] as String,
      sousTitre: map['sous_titre'] as String? ?? '',
      imageUrl: map['image_url'] as String? ?? '',
      estDisponible: map['est_disponible'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return 'Destination(idDestination: $idDestination, nom: $nom, sousTitre: $sousTitre)';
  }

  static const List<Destination> cities = [
    Destination(
      idDestination: 'dest_001',
      nom: 'Marrakech',
      sousTitre: 'The Red City',
      imageUrl: 'assets/images/cities/marrakech.png',
      estDisponible: true,
    ),
    Destination(
      idDestination: 'dest_002',
      nom: 'Casablanca',
      sousTitre: 'The White City',
      imageUrl: 'assets/images/cities/casablanca.png',
      estDisponible: true,
    ),
    Destination(
      idDestination: 'dest_003',
      nom: 'Agadir',
      sousTitre: 'The Beach Paradise',
      imageUrl: 'assets/images/cities/agadir.png',
    ),
    Destination(
      idDestination: 'dest_004',
      nom: 'Tangier',
      sousTitre: 'The Gateway to Africa',
      imageUrl: 'assets/images/cities/tangier.png',
    ),
  ];
}
