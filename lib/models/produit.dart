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

  Map<String, dynamic> toMap() {
    return {
      'idProduit': idProduit,
      'nom': nom,
      'prix': prix,
      'description': description,
      'stock': stock,
    };
  }

  factory Produit.fromMap(Map<String, dynamic> map) {
    return Produit(
      idProduit: map['idProduit'] as String,
      nom: map['nom'] as String,
      prix: map['prix'] as int,
      description: map['description'] as String,
      stock: map['stock'] as int,
    );
  }

  @override
  String toString() {
    return 'Produit(idProduit: $idProduit, nom: $nom, prix: $prix, stock: $stock)';
  }
}
