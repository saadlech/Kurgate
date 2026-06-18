/// A single item returned by the AI assistant (hotel, restaurant, etc.)
class ChatItem {
  final String id;
  final String name;
  final String? imageUrl;
  final String? location;
  final int? price;
  final double? rating;
  final int? reviews;
  final String? category;
  final String? type;

  const ChatItem({
    required this.id,
    required this.name,
    this.imageUrl,
    this.location,
    this.price,
    this.rating,
    this.reviews,
    this.category,
    this.type,
  });

  factory ChatItem.fromMap(Map<String, dynamic> map) => ChatItem(
        id: map['id'] as String? ?? '',
        name: map['name'] as String? ?? map['nom'] as String? ?? '',
        imageUrl: map['image_url'] as String?,
        location: map['location'] as String?,
        price: (map['price'] ?? map['prix'] ?? map['prix_moyen'])
            ?.toInt() as int?,
        rating: (map['rating'] as num?)?.toDouble(),
        reviews: (map['reviews'] as num?)?.toInt(),
        category: map['category'] as String?,
        type: map['_type'] as String?,
      );
}

/// Info about a single booking created by the AI agent.
class BookingInfo {
  final String id;
  final int amount;
  final String name;

  const BookingInfo({
    required this.id,
    required this.amount,
    required this.name,
  });
}

/// A single chat message in the conversation.
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final bool isTyping;
  final List<ChatItem> items;

  /// All bookings created in this AI response.
  /// Used to show a single consolidated payment widget.
  final List<BookingInfo> bookings;

  /// Legacy single-booking getters for backward compatibility.
  String? get bookingId =>
      bookings.isNotEmpty ? bookings.first.id : null;
  int? get bookingAmount =>
      bookings.isNotEmpty
          ? bookings.fold<int>(0, (sum, b) => sum + b.amount)
          : null;
  String? get bookingName =>
      bookings.isNotEmpty ? bookings.first.name : null;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.isTyping = false,
    this.items = const [],
    this.bookings = const [],
  });

  factory ChatMessage.typing() => ChatMessage(
        id: 'typing',
        content: '',
        isUser: false,
        timestamp: DateTime.now(),
        isTyping: true,
      );
}
