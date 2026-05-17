class Reservation {
  final String idReservation;
  final String itemId;        // source item ID (hotel_001, etc.)
  final String typeOffre;     // hotel, vehicule, experience, restaurant
  final String nom;           // display name
  final String sousTitre;
  final String imageUrl;
  final int nbPersonnes;
  final DateTime dateDebut;
  final DateTime dateFin;
  final int prixTotal;
  final Map<String, String> details;
  final String statut;        // 'En attente', 'Payée', 'Annulée'
  final int? note;            // 1-5 star rating
  final String? commentaire;  // user feedback

  const Reservation({
    required this.idReservation,
    required this.itemId,
    required this.typeOffre,
    required this.nom,
    this.sousTitre = '',
    this.imageUrl = '',
    required this.nbPersonnes,
    required this.dateDebut,
    required this.dateFin,
    this.prixTotal = 0,
    this.details = const {},
    this.statut = 'En attente',
    this.note,
    this.commentaire,
  });

  Reservation copyWith({
    String? statut,
    int? note,
    String? commentaire,
  }) =>
      Reservation(
        idReservation: idReservation,
        itemId: itemId,
        typeOffre: typeOffre,
        nom: nom,
        sousTitre: sousTitre,
        imageUrl: imageUrl,
        nbPersonnes: nbPersonnes,
        dateDebut: dateDebut,
        dateFin: dateFin,
        prixTotal: prixTotal,
        details: details,
        statut: statut ?? this.statut,
        note: note ?? this.note,
        commentaire: commentaire ?? this.commentaire,
      );

  /// Annuler la réservation
  Reservation annulerReservation() => copyWith(statut: 'Annulée');

  /// Confirmer le paiement
  Reservation payer() => copyWith(statut: 'Payée');

  /// Label for status display
  String get statusLabel => statut;

  /// Label for UI display
  String get typeLabel {
    switch (typeOffre) {
      case 'hotel':
        return 'Hôtel';
      case 'vehicule':
        return 'Véhicule';
      case 'experience':
        return 'Expérience';
      case 'restaurant':
        return 'Restaurant';
      default:
        return typeOffre;
    }
  }

  /// Convert to Map (for Supabase database)
  Map<String, dynamic> toMap() {
    return {
      'id': idReservation,
      'item_id': itemId,
      'type_offre': typeOffre,
      'nom': nom,
      'sous_titre': sousTitre,
      'image_url': imageUrl,
      'nb_personnes': nbPersonnes,
      'date_debut': dateDebut.toIso8601String(),
      'date_fin': dateFin.toIso8601String(),
      'prix_total': prixTotal,
      'details': details,
      'statut': statut,
      'note': note,
      'commentaire': commentaire,
    };
  }

  /// Create from Map (from Supabase database)
  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      idReservation: map['id'] as String,
      itemId: map['item_id'] as String? ?? '',
      typeOffre: map['type_offre'] as String? ?? '',
      nom: map['nom'] as String? ?? '',
      sousTitre: map['sous_titre'] as String? ?? '',
      imageUrl: map['image_url'] as String? ?? '',
      nbPersonnes: (map['nb_personnes'] as num?)?.toInt() ?? 1,
      dateDebut: DateTime.parse(map['date_debut'] as String),
      dateFin: DateTime.parse(map['date_fin'] as String),
      prixTotal: (map['prix_total'] as num?)?.toInt() ?? 0,
      details: (map['details'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v.toString())) ??
          {},
      statut: map['statut'] as String? ?? 'En attente',
      note: (map['note'] as num?)?.toInt(),
      commentaire: map['commentaire'] as String?,
    );
  }

  @override
  String toString() {
    return 'Reservation(idReservation: $idReservation, nom: $nom, statut: $statut)';
  }
}
