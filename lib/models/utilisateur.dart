class Utilisateur {
  final String id;
  final String nom;
  final String email;
  final int numDeTelephone;

  Utilisateur({
    required this.id,
    required this.nom,
    required this.email,
    required this.numDeTelephone,
  });

  // ModifierProfil - Update profile
  Utilisateur modifierProfil({
    String? nom,
    String? email,
    int? numDeTelephone,
  }) {
    return Utilisateur(
      id: id,
      nom: nom ?? this.nom,
      email: email ?? this.email,
      numDeTelephone: numDeTelephone ?? this.numDeTelephone,
    );
  }

  // Convert to Map (for Supabase database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
      'num_de_telephone': numDeTelephone,
    };
  }

  // Create from Map (from Supabase database)
  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      id: map['id'] as String,
      nom: map['nom'] as String,
      email: map['email'] as String,
      numDeTelephone: (map['num_de_telephone'] as num).toInt(),
    );
  }

  @override
  String toString() {
    return 'Utilisateur(id: $id, nom: $nom, email: $email, numDeTelephone: $numDeTelephone)';
  }
}
