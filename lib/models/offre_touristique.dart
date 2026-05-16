/// Base class for all tourist offerings (hotels, restaurants, experiences, etc.)
class OffreTouristique {
  final String id;
  final String name;
  final String location;
  final int price;
  final double rating;
  final int reviews;
  final String imageUrl;
  final String description;
  final List<String> tags;
  final String category;
  final List<String> images;

  const OffreTouristique({
    this.id = '',
    required this.name,
    this.location = '',
    this.price = 0,
    this.rating = 0,
    this.reviews = 0,
    this.imageUrl = '',
    this.description = '',
    this.tags = const [],
    this.category = '',
    this.images = const [],
  });
}
