class Avis {
  final String idAvis;
  final String itemId;       // ID of the reviewed item (hotel_001, etc.)
  final String userId;
  final String userName;
  final int note;
  final String commentaire;
  final DateTime datePublication;

  const Avis({
    required this.idAvis,
    required this.itemId,
    required this.userId,
    required this.userName,
    required this.note,
    required this.commentaire,
    required this.datePublication,
  });

  /// Convert to Map (for Supabase database)
  Map<String, dynamic> toMap() {
    return {
      'id': idAvis,
      'item_id': itemId,
      'user_id': userId,
      'user_name': userName,
      'note': note,
      'commentaire': commentaire,
      'date_publication': datePublication.toIso8601String(),
    };
  }

  /// Create from Map (from Supabase database)
  factory Avis.fromMap(Map<String, dynamic> map) {
    return Avis(
      idAvis: map['id'] as String,
      itemId: map['item_id'] as String? ?? '',
      userId: map['user_id'] as String? ?? '',
      userName: map['user_name'] as String? ?? '',
      note: (map['note'] as num).toInt(),
      commentaire: map['commentaire'] as String? ?? '',
      datePublication: DateTime.parse(map['date_publication'] as String),
    );
  }

  @override
  String toString() {
    return 'Avis(idAvis: $idAvis, itemId: $itemId, note: $note, commentaire: $commentaire)';
  }
}
