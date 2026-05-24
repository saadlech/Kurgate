import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});
  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _ctrl   = TextEditingController();
  final _scroll = ScrollController();
  final _focus  = FocusNode();

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    _ctrl.clear();
    ref.read(chatProvider.notifier).sendMessage(text);
    _scrollToBottom();
    Future.delayed(const Duration(milliseconds: 1500), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    final msgs = ref.watch(chatProvider);
    ref.listen(chatProvider, (_, __) => _scrollToBottom());

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Column(
        children: [
          _Header(onClear: () => ref.read(chatProvider.notifier).clearChat()),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              itemCount: msgs.length,
              itemBuilder: (_, i) => _Bubble(msg: msgs[i]),
            ),
          ),
          _InputBar(ctrl: _ctrl, focus: _focus, onSend: _send),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final VoidCallback onClear;
  const _Header({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 12,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.07))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: _icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFF8C00), Color(0xFFFCA91C)]),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Assistant Kurgate',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'DarkerGrotesque',
                        fontSize: 17,
                        fontWeight: FontWeight.w800)),
                Row(children: [
                  Container(width: 7, height: 7,
                      decoration: const BoxDecoration(color: Color(0xFF2ECC71), shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  Text('En ligne',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontFamily: 'DarkerGrotesque',
                          fontSize: 12)),
                ]),
              ],
            ),
          ),
          GestureDetector(onTap: onClear, child: _icon(Icons.refresh_rounded)),
        ],
      ),
    );
  }

  Widget _icon(IconData icon) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: Colors.white.withOpacity(0.6), size: 20),
      );
}

// ── Input bar ─────────────────────────────────────────────────────────────────
class _InputBar extends StatelessWidget {
  final TextEditingController ctrl;
  final FocusNode focus;
  final VoidCallback onSend;
  const _InputBar({required this.ctrl, required this.focus, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 16, right: 10, top: 10,
          bottom: MediaQuery.of(context).padding.bottom + 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.07))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: Colors.white.withOpacity(0.09)),
              ),
              child: TextField(
                controller: ctrl,
                focusNode: focus,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'DarkerGrotesque',
                    fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Écrivez votre message...',
                  hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.25),
                      fontFamily: 'DarkerGrotesque',
                      fontSize: 15),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                maxLines: null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFFFF8C00), Color(0xFFE07020)]),
                borderRadius: BorderRadius.circular(23),
                boxShadow: [BoxShadow(
                    color: const Color(0xFFFF8C00).withOpacity(0.35),
                    blurRadius: 10, offset: const Offset(0, 3))],
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Message bubble ────────────────────────────────────────────────────────────
class _Bubble extends StatelessWidget {
  final ChatMessage msg;
  const _Bubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    if (msg.isTyping) return const _Typing();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isUser) ...[_avatar(), const SizedBox(width: 8)],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.78),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: msg.isUser
                    ? const Color(0xFFFF8C00)
                    : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(msg.isUser ? 18 : 4),
                  bottomRight: Radius.circular(msg.isUser ? 4 : 18),
                ),
                border: msg.isUser
                    ? null
                    : Border.all(color: Colors.white.withOpacity(0.09)),
              ),
              child: Text(
                msg.content,
                style: TextStyle(
                  fontFamily: 'DarkerGrotesque',
                  color: msg.isUser
                      ? Colors.white
                      : Colors.white.withOpacity(0.88),
                  fontSize: 14.5,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar() => Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFFFF8C00), Color(0xFFFCA91C)]),
            borderRadius: BorderRadius.circular(9)),
        child:
            const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 14),
      );
}

// ── Typing indicator ──────────────────────────────────────────────────────────
class _Typing extends StatefulWidget {
  const _Typing();
  @override
  State<_Typing> createState() => _TypingState();
}

class _TypingState extends State<_Typing> with TickerProviderStateMixin {
  late final List<AnimationController> _dots;

  @override
  void initState() {
    super.initState();
    _dots = List.generate(3, (i) {
      final c = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 550));
      Future.delayed(Duration(milliseconds: i * 170), () {
        if (mounted) c.repeat(reverse: true);
      });
      return c;
    });
  }

  @override
  void dispose() {
    for (final d in _dots) d.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFFFF8C00), Color(0xFFFCA91C)]),
                borderRadius: BorderRadius.circular(9)),
            child: const Icon(Icons.auto_awesome_rounded,
                color: Colors.white, size: 14),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(4)),
              border: Border.all(color: Colors.white.withOpacity(0.09)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => AnimatedBuilder(
                animation: _dots[i],
                builder: (_, __) => Container(
                  width: 7, height: 7,
                  margin: EdgeInsets.only(right: i < 2 ? 5 : 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.lerp(Colors.white.withOpacity(0.15),
                        const Color(0xFFFF8C00), _dots[i].value),
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
