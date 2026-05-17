class Attraction {
  final String idAttraction;
  final String nom;
  final String type;
  final String description;
  final String imageUrl;
  final double note;
  final String location;
  final double lat;
  final double lon;

  const Attraction({
    required this.idAttraction,
    required this.nom,
    required this.type,
    required this.description,
    required this.imageUrl,
    this.note = 0.0,
    required this.location,
    required this.lat,
    required this.lon,
  });

  /// Convert to Map (for Supabase database)
  Map<String, dynamic> toMap() {
    return {
      'id': idAttraction,
      'nom': nom,
      'type': type,
      'description': description,
      'image_url': imageUrl,
      'note': note,
      'location': location,
      'lat': lat,
      'lon': lon,
    };
  }

  /// Create from Map (from Supabase database)
  factory Attraction.fromMap(Map<String, dynamic> map) {
    return Attraction(
      idAttraction: map['id'] as String,
      nom: map['nom'] as String,
      type: map['type'] as String? ?? '',
      description: map['description'] as String? ?? '',
      imageUrl: map['image_url'] as String? ?? '',
      note: (map['note'] as num?)?.toDouble() ?? 0.0,
      location: map['location'] as String? ?? '',
      lat: (map['lat'] as num).toDouble(),
      lon: (map['lon'] as num).toDouble(),
    );
  }

  @override
  String toString() {
    return 'Attraction(idAttraction: $idAttraction, nom: $nom, type: $type, location: $location)';
  }
}
