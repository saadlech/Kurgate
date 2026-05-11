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

  Map<String, dynamic> toMap() {
    return {
      'idReservation': idReservation,
      'itemId': itemId,
      'typeOffre': typeOffre,
      'nom': nom,
      'sousTitre': sousTitre,
      'imageUrl': imageUrl,
      'nbPersonnes': nbPersonnes,
      'dateDebut': dateDebut.toIso8601String(),
      'dateFin': dateFin.toIso8601String(),
      'prixTotal': prixTotal,
      'details': details,
      'statut': statut,
      'note': note,
      'commentaire': commentaire,
    };
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      idReservation: map['idReservation'] as String,
      itemId: map['itemId'] as String? ?? '',
      typeOffre: map['typeOffre'] as String? ?? '',
      nom: map['nom'] as String? ?? '',
      sousTitre: map['sousTitre'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      nbPersonnes: map['nbPersonnes'] as int? ?? 1,
      dateDebut: DateTime.parse(map['dateDebut'] as String),
      dateFin: DateTime.parse(map['dateFin'] as String),
      prixTotal: map['prixTotal'] as int? ?? 0,
      details: (map['details'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v.toString())) ??
          {},
      statut: map['statut'] as String? ?? 'En attente',
      note: map['note'] as int?,
      commentaire: map['commentaire'] as String?,
    );
  }

  @override
  String toString() {
    return 'Reservation(idReservation: $idReservation, nom: $nom, statut: $statut)';
  }
}
