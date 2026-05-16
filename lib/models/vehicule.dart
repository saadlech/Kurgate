class Vehicule {
  final String id;
  final String name;
  final String agence;
  final int price;
  final double rating;
  final int reviews;
  final String imageUrl;
  final List<String> tags;
  final String category;
  final String transmission;
  final String carburant;
  final int places;
  final String description;
  final List<String> images;

  const Vehicule({
    this.id = '',
    required this.name,
    required this.agence,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    this.tags = const [],
    this.category = '',
    required this.transmission,
    required this.carburant,
    required this.places,
    this.description = '',
    this.images = const [],
  });
}
