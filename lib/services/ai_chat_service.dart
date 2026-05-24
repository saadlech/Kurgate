import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

/// Sends messages to the Supabase ai-agent Edge Function.
/// Conversation memory is managed client-side: we send history with every request.
class AiChatService {
  AiChatService._();
  static final instance = AiChatService._();

  static const String _url =
      'https://aurxykjqywoaiezwkvff.supabase.co/functions/v1/ai-agent';
  static const String _anonKey =
      'sb_publishable_VwBR1xse_Z2Zgs4b0kjYhA_w54eXJP8';

  String _sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
  String? _userId;

  /// Local history sent with each request (role: user|assistant).
  final List<Map<String, String>> _history = [];

  void setUserId(String? id) => _userId = id;

  /// Send a user message, add both sides to local history, return AI reply.
  Future<ChatMessage> sendMessage(String text) async {
    _history.add({'role': 'user', 'content': text});

    try {
      // Send history MINUS the last user msg (it's in 'question')
      final historyToSend = _history.length > 1
          ? _history.sublist(0, _history.length - 1)
          : <Map<String, String>>[];

      final res = await http
          .post(
            Uri.parse(_url),
            headers: {
              'Content-Type': 'application/json',
              'apikey': _anonKey,
            },
            body: jsonEncode({
              'question': text,
              'sessionId': _sessionId,
              'history': historyToSend,
              if (_userId != null) 'userId': _userId,
            }),
          )
          .timeout(const Duration(seconds: 90));

      if (res.statusCode != 200) throw Exception('${res.statusCode}: ${res.body}');

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final reply = (data['text'] as String?) ?? 'Désolé, une erreur est survenue.';

      if (data['sessionId'] != null) _sessionId = data['sessionId'] as String;

      // Keep history bounded to 20 entries
      _history.add({'role': 'assistant', 'content': reply});
      if (_history.length > 20) _history.removeRange(0, _history.length - 20);

      return ChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        content: reply,
        isUser: false,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      debugPrint('[AiChatService] $e');
      // Remove the failed user message so it's not stuck in history
      if (_history.isNotEmpty && _history.last['role'] == 'user') {
        _history.removeLast();
      }
      return ChatMessage(
        id: 'err_${DateTime.now().millisecondsSinceEpoch}',
        content: '😔 Erreur de connexion. Vérifiez votre réseau et réessayez.',
        isUser: false,
        timestamp: DateTime.now(),
      );
    }
  }

  void clearHistory() {
    _history.clear();
    _sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
  }
}
