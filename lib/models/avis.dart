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

  Map<String, dynamic> toMap() {
    return {
      'idAvis': idAvis,
      'itemId': itemId,
      'userId': userId,
      'userName': userName,
      'note': note,
      'commentaire': commentaire,
      'datePublication': datePublication.toIso8601String(),
    };
  }

  factory Avis.fromMap(Map<String, dynamic> map) {
    return Avis(
      idAvis: map['idAvis'] as String,
      itemId: map['itemId'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      userName: map['userName'] as String? ?? '',
      note: map['note'] as int,
      commentaire: map['commentaire'] as String,
      datePublication: DateTime.parse(map['datePublication'] as String),
    );
  }

  @override
  String toString() {
    return 'Avis(idAvis: $idAvis, itemId: $itemId, note: $note, commentaire: $commentaire)';
  }
}
