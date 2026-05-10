class Avis {
  final String idAvis;
  final int note;
  final String commentaire;
  final DateTime datePublication;

  const Avis({
    required this.idAvis,
    required this.note,
    required this.commentaire,
    required this.datePublication,
  });

  Map<String, dynamic> toMap() {
    return {
      'idAvis': idAvis,
      'note': note,
      'commentaire': commentaire,
      'datePublication': datePublication.toIso8601String(),
    };
  }

  factory Avis.fromMap(Map<String, dynamic> map) {
    return Avis(
      idAvis: map['idAvis'] as String,
      note: map['note'] as int,
      commentaire: map['commentaire'] as String,
      datePublication: DateTime.parse(map['datePublication'] as String),
    );
  }

  @override
  String toString() {
    return 'Avis(idAvis: $idAvis, note: $note, commentaire: $commentaire)';
  }
}
