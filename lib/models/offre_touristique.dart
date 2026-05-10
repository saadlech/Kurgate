class OffreTouristique {
  final String idOffre;
  final String nom;
  final double prix;
  final double note;
  final String type;
  final String? imageUrl;

  const OffreTouristique({
    required this.idOffre,
    required this.nom,
    required this.prix,
    this.note = 0.0,
    required this.type,
    this.imageUrl,
  });

  /// Vérifie la disponibilité de l'offre pour une période donnée
  bool verifierDisponibilite({
    required DateTime debut,
    required DateTime fin,
    required int nbPersonnes,
  }) {
    // TODO: Implement actual availability check with backend
    if (fin.isBefore(debut)) return false;
    if (nbPersonnes <= 0) return false;
    return true;
  }

  Map<String, dynamic> toMap() {
    return {
      'idOffre': idOffre,
      'nom': nom,
      'prix': prix,
      'note': note,
      'type': type,
      'imageUrl': imageUrl,
    };
  }

  factory OffreTouristique.fromMap(Map<String, dynamic> map) {
    return OffreTouristique(
      idOffre: map['idOffre'] as String,
      nom: map['nom'] as String,
      prix: (map['prix'] as num).toDouble(),
      note: (map['note'] as num?)?.toDouble() ?? 0.0,
      type: map['type'] as String,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  @override
  String toString() {
    return 'OffreTouristique(idOffre: $idOffre, nom: $nom, prix: $prix, type: $type)';
  }

  // Sample data for backward compatibility with HomeScreen
  static const List<OffreTouristique> sampleOffers = [
    OffreTouristique(
      idOffre: 'offre_001',
      nom: 'Riad Al Nour',
      type: 'Hotel',
      prix: 120,
      note: 4.5,
      imageUrl:
          'https://images.unsplash.com/photo-1590073242678-70ee3fc28e8e?w=600&q=80',
    ),
    OffreTouristique(
      idOffre: 'offre_002',
      nom: 'Desert Safari Tour',
      type: 'Experience',
      prix: 85,
      note: 4.8,
      imageUrl:
          'https://images.unsplash.com/photo-1509023464722-18d996393ca8?w=600&q=80',
    ),
    OffreTouristique(
      idOffre: 'offre_003',
      nom: 'Jardin Majorelle',
      type: 'Experience',
      prix: 15,
      note: 4.7,
      imageUrl:
          'https://images.unsplash.com/photo-1591378603223-e15b45a81640?w=600&q=80',
    ),
    OffreTouristique(
      idOffre: 'offre_004',
      nom: 'Riad Yasmine',
      type: 'Hotel',
      prix: 95,
      note: 4.3,
      imageUrl:
          'https://images.unsplash.com/photo-1548018560-c7196e4f6bec?w=600&q=80',
    ),
  ];
}
