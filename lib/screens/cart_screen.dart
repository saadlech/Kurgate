import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});
  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Mon Panier', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                    Text('${notifier.totalItems} article${notifier.totalItems != 1 ? 's' : ''}', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 14)),
                  ]),
                  const Spacer(),
                  if (cart.isNotEmpty)
                    GestureDetector(
                      onTap: () => _showClearDialog(context, notifier),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.08))),
                        child: Icon(Icons.delete_sweep_rounded, color: Colors.white.withValues(alpha: 0.4), size: 22),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: cart.isEmpty ? _buildEmptyState() : _buildCartContent(cart, notifier)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04), shape: BoxShape.circle), child: Icon(Icons.shopping_cart_outlined, color: Colors.white.withValues(alpha: 0.15), size: 44)),
      const SizedBox(height: 20),
      Text('Panier vide', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 20, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      Text('Parcourez les boutiques artisanales\npour ajouter des articles', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.2), fontSize: 14, height: 1.5)),
    ]),
  );

  Widget _buildCartContent(List<CartItem> cart, CartNotifier notifier) => Column(
    children: [
      Expanded(
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          itemCount: cart.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = cart[index];
            return _CartItemCard(
              item: item,
              onQuantityChanged: (q) => notifier.updateQuantity(item.id, q),
              onDelete: () => _showDeleteItemDialog(context, item, notifier),
            );
          },
        ),
      ),
      // Bottom bar
      Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(color: const Color(0xFF1A1A1A), border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.06)))),
        child: Column(children: [
          _totalRow('Sous-total', '\$${notifier.totalPrice}'),
          _totalRow('Livraison', 'Gratuite'),
          Divider(color: Colors.white.withValues(alpha: 0.08), height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Total', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
            Text('\$${notifier.totalPrice}', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF8C00), fontSize: 24, fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _showPaymentSheet(context, cart, notifier),
            child: Container(
              height: 52, width: double.infinity,
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFF8C00), Color(0xFFE77728)]), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: const Color(0xFFFF8C00).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))]),
              child: Center(child: Text('Payer (${notifier.totalItems} articles)', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.black, fontSize: 16, fontWeight: FontWeight.w800))),
            ),
          ),
        ]),
      ),
    ],
  );

  Widget _totalRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 14)),
      Text(value, style: TextStyle(fontFamily: 'DarkerGrotesque', color: value == 'Gratuite' ? const Color(0xFF2ECC71) : Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
    ]),
  );

  void _showDeleteItemDialog(BuildContext context, CartItem item, CartNotifier notifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF222222),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Retirer cet article ?', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
        content: Text('${item.productName} sera retiré du panier.', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.6))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Annuler', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w700))),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              notifier.removeItem(item.id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.productName} retiré', style: const TextStyle(fontFamily: 'DarkerGrotesque')), backgroundColor: const Color(0xFF2A2A2A), action: SnackBarAction(label: 'Annuler', textColor: const Color(0xFFFF8C00), onPressed: () => notifier.addItem(item))));
            },
            child: const Text('Retirer', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF5252), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context, CartNotifier notifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF222222),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Vider le panier ?', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontWeight: FontWeight.w800)),
        content: Text('Tous les articles seront retirés.', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.6))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Annuler', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w700))),
          TextButton(onPressed: () { notifier.clearAll(); Navigator.pop(ctx); }, child: const Text('Vider', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF5252), fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }

  void _showPaymentSheet(BuildContext context, List<CartItem> cart, CartNotifier notifier) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _CartPaymentSheet(items: cart, totalPrice: notifier.totalPrice, totalItems: notifier.totalItems, onPaid: () => notifier.clearAll()),
    );
  }
}

// ─── Cart Item Card ────────────────────────────────────

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onDelete;
  const _CartItemCard({required this.item, required this.onQuantityChanged, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.06))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(borderRadius: BorderRadius.circular(12), child: SizedBox(width: 80, height: 80, child: Image.asset(item.imageUrl, fit: BoxFit.cover, cacheWidth: 160, cacheHeight: 160, gaplessPlayback: true, errorBuilder: (_, _, _) => Container(color: const Color(0xFF2A2A2A), child: const Center(child: Icon(Icons.storefront_rounded, color: Color(0xFF555555), size: 28)))))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(item.productName, style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis)),
            GestureDetector(
              onTap: onDelete,
              child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: const Color(0xFFFF5252).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFFF5252), size: 16)),
            ),
          ]),
          const SizedBox(height: 2),
          Row(children: [Icon(Icons.storefront_rounded, color: Colors.white.withValues(alpha: 0.3), size: 12), const SizedBox(width: 4), Expanded(child: Text(item.boutiqueName, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.35), fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis))]),
          const SizedBox(height: 2),
          Text(item.productDesc, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.25), fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Row(children: [
            Text('\$${item.totalPrice}', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF8C00), fontSize: 16, fontWeight: FontWeight.w800)),
            if (item.quantity > 1) Text('  (\$${item.unitPrice} × ${item.quantity})', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.25), fontSize: 11)),
            const Spacer(),
            _qtyBtn(Icons.remove_rounded, item.quantity > 1, () => onQuantityChanged(item.quantity - 1)),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('${item.quantity}', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700))),
            _qtyBtn(Icons.add_rounded, item.quantity < 10, () => onQuantityChanged(item.quantity + 1)),
          ]),
        ])),
      ]),
    );
  }

  Widget _qtyBtn(IconData icon, bool enabled, VoidCallback onTap) => GestureDetector(
    onTap: enabled ? onTap : null,
    child: Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: enabled ? const Color(0xFFFF8C00) : Colors.white.withValues(alpha: 0.05), border: Border.all(color: enabled ? const Color(0xFFFF8C00) : Colors.white.withValues(alpha: 0.1))),
      child: Icon(icon, color: enabled ? Colors.black : Colors.white.withValues(alpha: 0.2), size: 16)),
  );
}

// ─── Cart Payment Sheet ────────────────────────────────

class _CartPaymentSheet extends StatefulWidget {
  final List<CartItem> items;
  final int totalPrice, totalItems;
  final VoidCallback onPaid;
  const _CartPaymentSheet({required this.items, required this.totalPrice, required this.totalItems, required this.onPaid});
  @override
  State<_CartPaymentSheet> createState() => _CartPaymentSheetState();
}

class _CartPaymentSheetState extends State<_CartPaymentSheet> with TickerProviderStateMixin {
  final _cardCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  bool _processing = false;
  bool _success = false;
  late AnimationController _pulseCtrl;
  late AnimationController _successCtrl;
  late Animation<double> _successScale;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _successCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _successScale = CurvedAnimation(parent: _successCtrl, curve: Curves.elasticOut);
  }

  @override
  void dispose() { _cardCtrl.dispose(); _expiryCtrl.dispose(); _cvvCtrl.dispose(); _nameCtrl.dispose(); _addressCtrl.dispose(); _pulseCtrl.dispose(); _successCtrl.dispose(); super.dispose(); }

  bool get _formValid => _cardCtrl.text.replaceAll(' ', '').length == 16 && _expiryCtrl.text.length == 5 && _cvvCtrl.text.length == 3 && _nameCtrl.text.trim().isNotEmpty && _addressCtrl.text.trim().isNotEmpty;

  void _pay() {
    if (!_formValid || _processing) return;
    setState(() => _processing = true);
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      widget.onPaid();
      setState(() { _processing = false; _success = true; });
      _successCtrl.forward();
      Future.delayed(const Duration(seconds: 2), () { if (mounted) Navigator.pop(context); });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      decoration: const BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 12, 24, MediaQuery.of(context).viewInsets.bottom + 32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),

          if (_success) ...[
            const SizedBox(height: 20),
            ScaleTransition(scale: _successScale, child: Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF2ECC71).withValues(alpha: 0.15)), child: const Icon(Icons.check_rounded, color: Color(0xFF2ECC71), size: 44))),
            const SizedBox(height: 16),
            const Text('Paiement réussi !', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('${widget.totalItems} articles commandés avec succès.', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 14)),
            const SizedBox(height: 8),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.location_on_rounded, color: const Color(0xFFFF8C00).withValues(alpha: 0.6), size: 16),
              const SizedBox(width: 4),
              Flexible(child: Text(_addressCtrl.text.trim(), style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.35), fontSize: 13), textAlign: TextAlign.center)),
            ]),
            const SizedBox(height: 24),
          ] else if (_processing) ...[
            const SizedBox(height: 20),
            AnimatedBuilder(animation: _pulseCtrl, builder: (ctx, child) => Transform.scale(scale: 0.9 + _pulseCtrl.value * 0.15, child: child),
              child: Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFFF8C00).withValues(alpha: 0.12), border: Border.all(color: const Color(0xFFFF8C00).withValues(alpha: 0.3), width: 2)), child: const Icon(Icons.credit_card_rounded, color: Color(0xFFFF8C00), size: 36))),
            const SizedBox(height: 20),
            const Text('Traitement en cours...', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            SizedBox(width: 160, child: LinearProgressIndicator(backgroundColor: Colors.white.withValues(alpha: 0.06), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF8C00)), minHeight: 3, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
          ] else ...[
            // Order summary
            const Text('Paiement', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withValues(alpha: 0.08))),
              child: Column(children: [
                ...widget.items.map((item) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [
                  const Icon(Icons.shopping_bag_rounded, color: Color(0xFFFF8C00), size: 14),
                  const SizedBox(width: 8),
                  Expanded(child: Text('${item.productName} × ${item.quantity}', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.6), fontSize: 12))),
                  Text('\$${item.totalPrice}', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.5), fontSize: 12, fontWeight: FontWeight.w600)),
                ]))),
                Divider(color: Colors.white.withValues(alpha: 0.08), height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Total', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                  Text('\$${widget.totalPrice}', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF8C00), fontSize: 20, fontWeight: FontWeight.w800)),
                ]),
              ]),
            ),
            const SizedBox(height: 20),
            // Delivery address
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(Icons.location_on_rounded, color: const Color(0xFFFF8C00), size: 16),
                const SizedBox(width: 6),
                Text('Adresse de livraison', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 12, fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.08))),
                child: TextField(
                  controller: _addressCtrl,
                  style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  minLines: 1,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.home_rounded, size: 16, color: Colors.white.withValues(alpha: 0.3)),
                    hintText: 'Ex: 123 Rue Mohamed V, Guéliz, Marrakech',
                    hintStyle: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.15), fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            // Card form
            _field('Numéro de carte', '0000 0000 0000 0000', _cardCtrl, Icons.credit_card_rounded, TextInputType.number, [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16), _CardFmt()]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _field('Expiration', 'MM/AA', _expiryCtrl, Icons.calendar_today_rounded, TextInputType.number, [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4), _ExpiryFmt()])),
              const SizedBox(width: 12),
              Expanded(child: _field('CVV', '•••', _cvvCtrl, Icons.lock_rounded, TextInputType.number, [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)], obscure: true)),
            ]),
            const SizedBox(height: 12),
            _field('Nom du titulaire', 'Prénom Nom', _nameCtrl, Icons.person_rounded, TextInputType.name, [LengthLimitingTextInputFormatter(40)]),
            const SizedBox(height: 8),
            Row(children: [Icon(Icons.shield_rounded, size: 12, color: Colors.white.withValues(alpha: 0.2)), const SizedBox(width: 6), Text('Paiement sécurisé et chiffré', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.2), fontSize: 11))]),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, height: 50, child: AnimatedBuilder(
              animation: Listenable.merge([_cardCtrl, _expiryCtrl, _cvvCtrl, _nameCtrl, _addressCtrl]),
              builder: (ctx, _) {
                final v = _formValid;
                return ElevatedButton(
                  onPressed: v ? _pay : null,
                  style: ElevatedButton.styleFrom(backgroundColor: v ? const Color(0xFFFF8C00) : Colors.white.withValues(alpha: 0.06), foregroundColor: Colors.black, disabledBackgroundColor: Colors.white.withValues(alpha: 0.06), disabledForegroundColor: Colors.white.withValues(alpha: 0.2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.lock_rounded, size: 16, color: v ? Colors.black : Colors.white.withValues(alpha: 0.2)),
                    const SizedBox(width: 8),
                    Text('Payer \$${widget.totalPrice}', style: TextStyle(fontFamily: 'DarkerGrotesque', fontSize: 16, fontWeight: FontWeight.w800, color: v ? Colors.black : Colors.white.withValues(alpha: 0.2))),
                  ]),
                );
              },
            )),
          ],
        ]),
      ),
    );
  }

  Widget _field(String label, String hint, TextEditingController ctrl, IconData icon, TextInputType kbType, List<TextInputFormatter> fmt, {bool obscure = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 12, fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      Container(
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.08))),
        child: TextField(controller: ctrl, keyboardType: kbType, obscureText: obscure, inputFormatters: fmt,
          style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 1),
          decoration: InputDecoration(prefixIcon: Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.3)), hintText: hint, hintStyle: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.15), fontSize: 15, letterSpacing: 1), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12))),
      ),
    ]);
  }
}

class _CardFmt extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue o, TextEditingValue n) {
    final t = n.text.replaceAll(' ', '');
    final b = StringBuffer();
    for (int i = 0; i < t.length; i++) { if (i > 0 && i % 4 == 0) b.write(' '); b.write(t[i]); }
    final f = b.toString();
    return TextEditingValue(text: f, selection: TextSelection.collapsed(offset: f.length));
  }
}

class _ExpiryFmt extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue o, TextEditingValue n) {
    final t = n.text.replaceAll('/', '');
    final b = StringBuffer();
    for (int i = 0; i < t.length; i++) { if (i == 2) b.write('/'); b.write(t[i]); }
    final f = b.toString();
    return TextEditingValue(text: f, selection: TextSelection.collapsed(offset: f.length));
  }
}
