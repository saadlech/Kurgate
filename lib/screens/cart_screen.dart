import 'package:flutter/material.dart';
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
        child: Column(children: [
          // Header
          Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Mon Panier', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
              Text('${notifier.totalItems} article${notifier.totalItems != 1 ? 's' : ''}', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 14)),
            ]),
            const Spacer(),
            if (cart.isNotEmpty) GestureDetector(
              onTap: () => _showClearDialog(context, notifier),
              child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.08))),
                child: Icon(Icons.delete_sweep_rounded, color: Colors.white.withValues(alpha: 0.4), size: 22)),
            ),
          ])),
          const SizedBox(height: 16),
          // Cart items
          Expanded(child: cart.isEmpty ? _buildEmptyState() : _buildCartContent(cart, notifier)),
        ]),
      ),
    );
  }

  Widget _buildEmptyState() => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04), shape: BoxShape.circle),
      child: Icon(Icons.shopping_cart_outlined, color: Colors.white.withValues(alpha: 0.15), size: 44)),
    const SizedBox(height: 20),
    Text('Panier vide', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 20, fontWeight: FontWeight.w700)),
    const SizedBox(height: 8),
    Text('Parcourez les boutiques artisanales\npour ajouter des articles', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.2), fontSize: 14, height: 1.5)),
  ]));

  Widget _buildCartContent(List<CartItem> cart, CartNotifier notifier) => Column(children: [
    Expanded(child: ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      itemCount: cart.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = cart[index];
        return Dismissible(
          key: Key(item.id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            notifier.removeItem(item.id);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${item.productName} retiré', style: const TextStyle(fontFamily: 'DarkerGrotesque')),
              backgroundColor: const Color(0xFF2A2A2A),
              action: SnackBarAction(label: 'Annuler', textColor: const Color(0xFFFF8C00), onPressed: () => notifier.addItem(item)),
            ));
          },
          background: Container(
            alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(color: const Color(0xFFFF5252).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(18)),
            child: const Icon(Icons.delete_rounded, color: Color(0xFFFF5252), size: 28),
          ),
          child: _CartItemCard(item: item, onQuantityChanged: (q) => notifier.updateQuantity(item.id, q)),
        );
      },
    )),
    // Bottom total bar
    Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A), border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.06)))),
      child: Column(children: [
        // Summary rows
        _totalRow('Sous-total', '\$${notifier.totalPrice}'),
        _totalRow('Livraison', 'Gratuite'),
        Divider(color: Colors.white.withValues(alpha: 0.08), height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Total', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          Text('\$${notifier.totalPrice}', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF8C00), fontSize: 24, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _showCheckoutConfirmation(context, cart, notifier),
          child: Container(height: 52, width: double.infinity,
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFF8C00), Color(0xFFE77728)]), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: const Color(0xFFFF8C00).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))]),
            child: Center(child: Text('Commander (${notifier.totalItems} articles)', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.black, fontSize: 16, fontWeight: FontWeight.w800)))),
        ),
      ]),
    ),
  ]);

  Widget _totalRow(String label, String value) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(label, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 14)),
    Text(value, style: TextStyle(fontFamily: 'DarkerGrotesque', color: value == 'Gratuite' ? const Color(0xFF2ECC71) : Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
  ]));

  void _showClearDialog(BuildContext context, CartNotifier notifier) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF222222),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Vider le panier ?', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontWeight: FontWeight.w800)),
      content: Text('Tous les articles seront retirés.', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.6))),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Annuler', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w700))),
        TextButton(onPressed: () { notifier.clearAll(); Navigator.pop(ctx); }, child: const Text('Vider', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF5252), fontWeight: FontWeight.w700))),
      ],
    ));
  }

  void _showCheckoutConfirmation(BuildContext context, List<CartItem> cart, CartNotifier notifier) {
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (ctx) => _CheckoutSheet(items: cart, totalPrice: notifier.totalPrice, totalItems: notifier.totalItems,
        onConfirmed: () { notifier.clearAll(); }),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  const _CartItemCard({required this.item, required this.onQuantityChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.06))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Product image
        ClipRRect(borderRadius: BorderRadius.circular(12),
          child: SizedBox(width: 80, height: 80, child: Image.asset(item.imageUrl, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: const Color(0xFF2A2A2A), child: const Center(child: Icon(Icons.storefront_rounded, color: Color(0xFF555555), size: 28)))))),
        const SizedBox(width: 12),
        // Details
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.productName, style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Row(children: [
            Icon(Icons.storefront_rounded, color: Colors.white.withValues(alpha: 0.3), size: 12), const SizedBox(width: 4),
            Expanded(child: Text(item.boutiqueName, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.35), fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
          ]),
          const SizedBox(height: 2),
          Text(item.productDesc, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.25), fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Row(children: [
            Text('\$${item.totalPrice}', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF8C00), fontSize: 16, fontWeight: FontWeight.w800)),
            if (item.quantity > 1) Text('  (\$${item.unitPrice} × ${item.quantity})', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.25), fontSize: 11)),
            const Spacer(),
            // Quantity controls
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
    child: Container(width: 28, height: 28,
      decoration: BoxDecoration(shape: BoxShape.circle, color: enabled ? const Color(0xFFFF8C00) : Colors.white.withValues(alpha: 0.05), border: Border.all(color: enabled ? const Color(0xFFFF8C00) : Colors.white.withValues(alpha: 0.1))),
      child: Icon(icon, color: enabled ? Colors.black : Colors.white.withValues(alpha: 0.2), size: 16)),
  );
}

class _CheckoutSheet extends StatefulWidget {
  final List<CartItem> items;
  final int totalPrice, totalItems;
  final VoidCallback onConfirmed;
  const _CheckoutSheet({required this.items, required this.totalPrice, required this.totalItems, required this.onConfirmed});
  @override
  State<_CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<_CheckoutSheet> with SingleTickerProviderStateMixin {
  bool _confirmed = false;
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  @override
  void initState() { super.initState(); _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600)); _scaleAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.elasticOut)); }
  @override
  void dispose() { _animCtrl.dispose(); super.dispose(); }

  void _confirm() {
    setState(() => _confirmed = true);
    _animCtrl.forward();
    widget.onConfirmed();
    Future.delayed(const Duration(seconds: 2), () { if (mounted) Navigator.of(context).pop(); });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF222222), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))),
        if (_confirmed) ...[
          const SizedBox(height: 20),
          ScaleTransition(scale: _scaleAnim, child: Container(width: 80, height: 80, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF2ECC71)), child: const Icon(Icons.check_rounded, color: Colors.white, size: 44))),
          const SizedBox(height: 20),
          const Text('Commande confirmée !', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('${widget.totalItems} articles commandés avec succès.', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.5), fontSize: 14)),
          const SizedBox(height: 24),
        ] else ...[
          const Text('Confirmer la commande', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withValues(alpha: 0.08))),
            child: Column(children: [
              ...widget.items.map((item) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
                const Icon(Icons.shopping_bag_rounded, color: Color(0xFFFF8C00), size: 16), const SizedBox(width: 8),
                Expanded(child: Text('${item.productName} × ${item.quantity}', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.7), fontSize: 13, fontWeight: FontWeight.w500))),
                Text('\$${item.totalPrice}', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.5), fontSize: 13, fontWeight: FontWeight.w600)),
              ]))),
              const Divider(height: 20, color: Color(0xFF444444)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)), Text('\$${widget.totalPrice}', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF8C00), fontSize: 22, fontWeight: FontWeight.w800))]),
            ])),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: GestureDetector(onTap: () => Navigator.of(context).pop(), child: Container(height: 50, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withValues(alpha: 0.1))), child: const Center(child: Text('Annuler', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)))))),
            const SizedBox(width: 12),
            Expanded(flex: 2, child: GestureDetector(onTap: _confirm, child: Container(height: 50, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFF8C00), Color(0xFFFF6B00)]), borderRadius: BorderRadius.circular(14)), child: const Center(child: Text('Confirmer', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.black, fontSize: 16, fontWeight: FontWeight.w800)))))),
          ]),
        ],
      ]),
    );
  }
}
