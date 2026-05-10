class Reservation {
  final String idReservation;
  final int nbPersonnes;
  final DateTime dateDebut;
  final DateTime dateFin;
  String statut;

  Reservation({
    required this.idReservation,
    required this.nbPersonnes,
    required this.dateDebut,
    required this.dateFin,
    this.statut = 'En attente',
  });

  /// Annuler la réservation
  void annulerReservation() {
    statut = 'Annulée';
  }

  /// Confirmer la réservation
  void confirmer() {
    statut = 'Confirmée';
  }

  Map<String, dynamic> toMap() {
    return {
      'idReservation': idReservation,
      'nbPersonnes': nbPersonnes,
      'dateDebut': dateDebut.toIso8601String(),
      'dateFin': dateFin.toIso8601String(),
      'statut': statut,
    };
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      idReservation: map['idReservation'] as String,
      nbPersonnes: map['nbPersonnes'] as int,
      dateDebut: DateTime.parse(map['dateDebut'] as String),
      dateFin: DateTime.parse(map['dateFin'] as String),
      statut: map['statut'] as String? ?? 'En attente',
    );
  }

  @override
  String toString() {
    return 'Reservation(idReservation: $idReservation, nbPersonnes: $nbPersonnes, statut: $statut)';
  }
}
