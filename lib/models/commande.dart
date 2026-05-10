class Commande {
  final String idCommande;
  final DateTime dateCommande;
  final double montantTotal;
  String statut;

  Commande({
    required this.idCommande,
    required this.dateCommande,
    required this.montantTotal,
    this.statut = 'En attente',
  });

  /// Effectuer le paiement de la commande
  void payer() {
    statut = 'Payée';
  }

  /// Annuler la commande
  void annuler() {
    statut = 'Annulée';
  }

  Map<String, dynamic> toMap() {
    return {
      'idCommande': idCommande,
      'dateCommande': dateCommande.toIso8601String(),
      'montantTotal': montantTotal,
      'statut': statut,
    };
  }

  factory Commande.fromMap(Map<String, dynamic> map) {
    return Commande(
      idCommande: map['idCommande'] as String,
      dateCommande: DateTime.parse(map['dateCommande'] as String),
      montantTotal: (map['montantTotal'] as num).toDouble(),
      statut: map['statut'] as String? ?? 'En attente',
    );
  }

  @override
  String toString() {
    return 'Commande(idCommande: $idCommande, montantTotal: $montantTotal, statut: $statut)';
  }
}
