import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';
import '../models/reservation.dart';
import '../services/ai_chat_service.dart';
import 'auth_provider.dart';
import 'booking_provider.dart';

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier(this._ref) : super([]) {
    _addWelcome();
  }

  final Ref _ref;
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

    // If bookings were created, sync them all to bookingProvider
    if (reply.bookings.isNotEmpty) {
      _syncBookingsToProvider(reply.bookings);
    }

    // Remove typing indicator, add reply
    state = [...state.where((m) => !m.isTyping), reply];
  }

  /// Sync all AI-created bookings into the local bookingProvider
  void _syncBookingsToProvider(List<BookingInfo> bookings) {
    try {
      final allBookingData = _service.lastBookingsData;
      final existing = _ref.read(bookingProvider);
      for (final data in allBookingData) {
        final reservation = Reservation.fromMap(data);
        final id = data['id'] as String?;
        if (id != null && !existing.any((r) => r.idReservation == id)) {
          _ref.read(bookingProvider.notifier).addBookingLocal(reservation);
        }
      }
    } catch (e) {
      debugPrint('[ChatNotifier] Error syncing bookings: $e');
    }
  }

  /// Pay a booking via the Edge Function, then update local state.
  Future<bool> payBooking(String bookingId) async {
    try {
      const url = 'https://aurxykjqywoaiezwkvff.supabase.co/functions/v1/ai-agent';
      const anonKey = 'sb_publishable_VwBR1xse_Z2Zgs4b0kjYhA_w54eXJP8';
      final res = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', 'apikey': anonKey},
        body: jsonEncode({
          'question': '__update_booking',
          'bookingId': bookingId,
          'statut': 'Payée',
        }),
      ).timeout(const Duration(seconds: 30));
      if (res.statusCode != 200) return false;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return data['success'] == true;
    } catch (e) {
      debugPrint('[ChatNotifier] payBooking error: $e');
      return false;
    }
  }

  /// After successful payment, replace the booking message with a success version
  /// (clear bookings so the payment widget disappears).
  void markBookingPaid(String messageId) {
    state = [
      ...state.map((m) {
        if (m.id == messageId) {
          return ChatMessage(
            id: m.id,
            content: m.content,
            isUser: m.isUser,
            timestamp: m.timestamp,
            items: m.items,
            // Clear bookings to hide payment widget
            bookings: const [],
          );
        }
        return m;
      }),
      ChatMessage(
        id: 'payment_ok_${DateTime.now().millisecondsSinceEpoch}',
        content: '✅ Paiement effectué avec succès ! Toutes vos réservations sont maintenant confirmées.',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];
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
  final notifier = ChatNotifier(ref);

  // Listen to auth changes and update userId in the service
  ref.listen(authProvider, (previous, next) {
    notifier._service.setUserId(next.currentUser?.id);
  });

  // Set the initial user ID if the user is already authenticated
  final initialUser = ref.read(authProvider).currentUser;
  notifier._service.setUserId(initialUser?.id);

  return notifier;
});
