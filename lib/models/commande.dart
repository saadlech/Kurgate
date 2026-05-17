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

  /// Convert to Map (for Supabase database)
  Map<String, dynamic> toMap() {
    return {
      'id': idCommande,
      'date_commande': dateCommande.toIso8601String(),
      'montant_total': montantTotal,
      'statut': statut,
    };
  }

  /// Create from Map (from Supabase database)
  factory Commande.fromMap(Map<String, dynamic> map) {
    return Commande(
      idCommande: map['id'] as String,
      dateCommande: DateTime.parse(map['date_commande'] as String),
      montantTotal: (map['montant_total'] as num).toDouble(),
      statut: map['statut'] as String? ?? 'En attente',
    );
  }

  @override
  String toString() {
    return 'Commande(idCommande: $idCommande, montantTotal: $montantTotal, statut: $statut)';
  }
}
