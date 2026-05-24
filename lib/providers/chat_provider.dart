import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';
import '../services/ai_chat_service.dart';

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier() : super([]) {
    _addWelcome();
  }

  final _service = AiChatService.instance;

  void _addWelcome() {
    state = [
      ChatMessage(
        id: 'welcome',
        content: 'Bonjour ! 👋 Je suis votre assistant Kurgate.\n\n'
            'Je peux chercher des hôtels, restaurants, expériences, véhicules et boutiques au Maroc, '
            'et créer des réservations directement.\n\n'
            'Essayez: "Hôtels à Marrakech" ou "Restaurants à Casablanca" 🇲🇦',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user bubble
    state = [
      ...state,
      ChatMessage(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        content: text.trim(),
        isUser: true,
        timestamp: DateTime.now(),
      ),
      ChatMessage.typing(),
    ];

    // Get AI response
    final reply = await _service.sendMessage(text.trim());

    // Remove typing indicator, add reply
    state = [...state.where((m) => !m.isTyping), reply];
  }

  void clearChat() {
    _service.clearHistory();
    state = [];
    _addWelcome();
  }

  bool get isLoading => state.any((m) => m.isTyping);
}

final chatProvider =
    StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier();
});
