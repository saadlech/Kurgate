class Produit {
  final String idProduit;
  final String nom;
  final int prix;
  final String description;
  final int stock;

  const Produit({
    required this.idProduit,
    required this.nom,
    required this.prix,
    required this.description,
    required this.stock,
  });

  /// Convert to Map (for Supabase database)
  Map<String, dynamic> toMap() {
    return {
      'id': idProduit,
      'nom': nom,
      'prix': prix,
      'description': description,
      'stock': stock,
    };
  }

  /// Create from Map (from Supabase database)
  factory Produit.fromMap(Map<String, dynamic> map) {
    return Produit(
      idProduit: map['id'] as String,
      nom: map['nom'] as String,
      prix: (map['prix'] as num).toInt(),
      description: map['description'] as String? ?? '',
      stock: (map['stock'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  String toString() {
    return 'Produit(idProduit: $idProduit, nom: $nom, prix: $prix, stock: $stock)';
  }
}
