/// A single chat message in the conversation.
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final bool isTyping;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.isTyping = false,
  });

  factory ChatMessage.typing() => ChatMessage(
        id: 'typing',
        content: '',
        isUser: false,
        timestamp: DateTime.now(),
        isTyping: true,
      );
}
