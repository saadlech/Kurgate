import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';
import '../providers/chat_provider.dart';
import '../providers/booking_provider.dart';
import 'payment_screen.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});
  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final _focus = FocusNode();

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
    ref.listen(chatProvider, (_, _) => _scrollToBottom());

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
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.07)),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: _icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Image.asset(
              'assets/images/ai_assistant.png',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Assistant Kurgate',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'DarkerGrotesque',
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2ECC71),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'En ligne',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontFamily: 'DarkerGrotesque',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
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
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(icon, color: Colors.white.withOpacity(0.6), size: 20),
  );
}

// ── Input bar ─────────────────────────────────────────────────────────────────
class _InputBar extends StatelessWidget {
  final TextEditingController ctrl;
  final FocusNode focus;
  final VoidCallback onSend;
  const _InputBar({
    required this.ctrl,
    required this.focus,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 10,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
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
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: 'Écrivez votre message...',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.25),
                    fontFamily: 'DarkerGrotesque',
                    fontSize: 15,
                  ),
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
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF8C00), Color(0xFFE07020)],
                ),
                borderRadius: BorderRadius.circular(23),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF8C00).withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Message bubble ────────────────────────────────────────────────────────────
class _Bubble extends ConsumerWidget {
  final ChatMessage msg;
  const _Bubble({required this.msg});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (msg.isTyping) return const _Typing();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment:
            msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // ── Text bubble ──
          Row(
            mainAxisAlignment: msg.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!msg.isUser) ...[_avatar(), const SizedBox(width: 8)],
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.78,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
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

          // ── Item cards carousel ──
          if (!msg.isUser && msg.items.isNotEmpty) ...[
            const SizedBox(height: 10),
            _ItemCardsRow(items: msg.items),
          ],

          // ── Inline payment / card registration widget ──
          if (!msg.isUser && msg.bookings.isNotEmpty) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: _PaymentWidget(
                bookings: msg.bookings,
                messageId: msg.id,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _avatar() => ClipRRect(
    borderRadius: BorderRadius.circular(9),
    child: Image.asset(
      'assets/images/ai_assistant.png',
      width: 28,
      height: 28,
      fit: BoxFit.cover,
    ),
  );
}

// ── Inline payment widget – consolidated for all bookings ─────────────────────
class _PaymentWidget extends ConsumerWidget {
  final List<BookingInfo> bookings;
  final String messageId;

  const _PaymentWidget({
    required this.bookings,
    required this.messageId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalAmount = bookings.fold<int>(0, (sum, b) => sum + b.amount);

    // Check if ALL bookings are paid
    final localBookings = ref.watch(bookingProvider);
    final allPaid = bookings.every((b) {
      final match = localBookings.where((lb) => lb.idReservation == b.id);
      return match.isNotEmpty && match.first.statut == 'Payée';
    });

    if (allPaid) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2ECC71).withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2ECC71).withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2ECC71).withOpacity(0.15),
              ),
              child: const Icon(Icons.check_rounded, color: Color(0xFF2ECC71), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Paiement réussi', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFF2ECC71), fontSize: 14, fontWeight: FontWeight.w800)),
                  Text('$totalAmount MAD · ${bookings.length} réservation${bookings.length > 1 ? 's' : ''}', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withOpacity(0.35), fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFF8C00).withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C00).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.receipt_long_rounded, color: Color(0xFFFF8C00), size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${bookings.length} réservation${bookings.length > 1 ? 's' : ''} à payer', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
                    Text('Total de votre voyage', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withOpacity(0.35), fontSize: 11)),
                  ],
                ),
              ),
              Text('$totalAmount MAD', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF8C00), fontSize: 16, fontWeight: FontWeight.w800)),
            ],
          ),

          // Booking breakdown (if multiple)
          if (bookings.length > 1) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Column(
                children: bookings.map((b) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 5, color: Colors.white.withOpacity(0.3)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          b.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withOpacity(0.6), fontSize: 12),
                        ),
                      ),
                      Text('${b.amount} MAD', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withOpacity(0.45), fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ],

          const SizedBox(height: 14),
          // Pay button → navigates to PaymentScreen with the first booking
          // (the PaymentScreen handles payment status update)
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => PaymentScreen(bookingId: bookings.first.id)),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFFF8C00), Color(0xFFE07020)]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: const Color(0xFFFF8C00).withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_rounded, size: 16, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    bookings.length > 1 ? 'Payer tout · $totalAmount MAD' : 'Payer maintenant',
                    style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Security note
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield_rounded, size: 10, color: Colors.white.withOpacity(0.2)),
              const SizedBox(width: 4),
              Text('Paiement sécurisé — Vos données sont chiffrées', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withOpacity(0.2), fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}



// ── Item cards horizontal list ────────────────────────────────────────────────
class _ItemCardsRow extends StatelessWidget {
  final List<ChatItem> items;
  const _ItemCardsRow({required this.items});

  IconData _typeIcon(String? type) {
    switch (type) {
      case 'hotel':
        return Icons.hotel_rounded;
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'experience':
        return Icons.explore_rounded;
      case 'vehicule':
        return Icons.directions_car_rounded;
      case 'boutique':
        return Icons.store_rounded;
      case 'attraction':
        return Icons.photo_camera_rounded;
      default:
        return Icons.place_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 36, right: 8),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final item = items[i];
          return _ItemCard(item: item, typeIcon: _typeIcon(item.type));
        },
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final ChatItem item;
  final IconData typeIcon;
  const _ItemCard({required this.item, required this.typeIcon});

  @override
  Widget build(BuildContext context) {
    final hasImage =
        item.imageUrl != null && item.imageUrl!.isNotEmpty;

    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image or fallback ──
          SizedBox(
            height: 95,
            width: double.infinity,
            child: hasImage
                ? Image.network(
                    item.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _imageFallback(),
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return _imageFallback(loading: true);
                    },
                  )
                : _imageFallback(),
          ),

          // ── Info ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'DarkerGrotesque',
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const Spacer(),
                  // Rating + Price row
                  Row(
                    children: [
                      if (item.rating != null) ...[
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFB800),
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          item.rating!.toStringAsFixed(1),
                          style: TextStyle(
                            fontFamily: 'DarkerGrotesque',
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (item.price != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF8C00), Color(0xFFE07020)],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${item.price} MAD',
                            style: const TextStyle(
                              fontFamily: 'DarkerGrotesque',
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  // Location row
                  if (item.location != null && item.location!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: Colors.white.withOpacity(0.35),
                          size: 11,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            item.location!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'DarkerGrotesque',
                              color: Colors.white.withOpacity(0.35),
                              fontSize: 10.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageFallback({bool loading = false}) => Container(
    color: const Color(0xFF2A2A2A),
    child: Center(
      child: loading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: const Color(0xFFFF8C00).withOpacity(0.5),
              ),
            )
          : Icon(
              typeIcon,
              color: Colors.white.withOpacity(0.15),
              size: 32,
            ),
    ),
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
        vsync: this,
        duration: const Duration(milliseconds: 550),
      );
      Future.delayed(Duration(milliseconds: i * 170), () {
        if (mounted) c.repeat(reverse: true);
      });
      return c;
    });
  }

  @override
  void dispose() {
    for (final d in _dots) {
      d.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Image.asset(
              'assets/images/ai_assistant.png',
              width: 28,
              height: 28,
              fit: BoxFit.cover,
            ),
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
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: Colors.white.withOpacity(0.09)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (i) => AnimatedBuilder(
                  animation: _dots[i],
                  builder: (_, _) => Container(
                    width: 7,
                    height: 7,
                    margin: EdgeInsets.only(right: i < 2 ? 5 : 0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.lerp(
                        Colors.white.withOpacity(0.15),
                        const Color(0xFFFF8C00),
                        _dots[i].value,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
