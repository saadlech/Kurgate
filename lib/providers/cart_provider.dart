import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/supabase_service.dart';

class CartItem {
  final String id;
  final String boutiqueName;
  final String artisan;
  final String productName;
  final String productDesc;
  final String imageUrl;
  final int unitPrice;
  final int quantity;
  final DateTime addedAt;

  const CartItem({
    required this.id,
    required this.boutiqueName,
    required this.artisan,
    required this.productName,
    required this.productDesc,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
    required this.addedAt,
  });

  int get totalPrice => unitPrice * quantity;

  CartItem copyWith({int? quantity}) => CartItem(
    id: id,
    boutiqueName: boutiqueName,
    artisan: artisan,
    productName: productName,
    productDesc: productDesc,
    imageUrl: imageUrl,
    unitPrice: unitPrice,
    quantity: quantity ?? this.quantity,
    addedAt: addedAt,
  );

  /// Convert to a map for Supabase commandes insertion
  Map<String, dynamic> toCommandeMap() => {
    'boutique_name': boutiqueName,
    'artisan': artisan,
    'product_name': productName,
    'product_desc': productDesc,
    'image_url': imageUrl,
    'unit_price': unitPrice,
    'quantity': quantity,
    'total_price': totalPrice,
  };
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(CartItem item) {
    // Check if same product from same boutique exists
    final existingIndex = state.indexWhere(
      (i) => i.boutiqueName == item.boutiqueName && i.productName == item.productName,
    );
    if (existingIndex >= 0) {
      // Update quantity
      final existing = state[existingIndex];
      final updated = existing.copyWith(quantity: existing.quantity + item.quantity);
      state = [...state];
      state[existingIndex] = updated;
      state = List.from(state);
    } else {
      state = [item, ...state];
    }
  }

  void removeItem(String id) {
    state = state.where((i) => i.id != id).toList();
    _deleteRemote(id);
  }

  void updateQuantity(String id, int quantity) {
    if (quantity <= 0) {
      removeItem(id);
      return;
    }
    state = state.map((i) => i.id == id ? i.copyWith(quantity: quantity) : i).toList();
  }

  /// Checkout: persist all cart items to Supabase `commandes` then clear
  Future<void> checkout({String? address}) async {
    if (state.isEmpty) return;
    // Persist each item as a commande row
    for (final item in state) {
      final map = item.toCommandeMap();
      if (address != null && address.isNotEmpty) {
        map['address'] = address;
      }
      map['statut'] = 'Payée';
      try {
        await SupabaseService.createCommande(map);
      } catch (_) {
        // fire-and-forget — local cart clears regardless
      }
    }
    state = [];
  }

  Future<void> clearAll() async {
    state = [];
    try {
      await SupabaseService.deleteAllCommandes();
    } catch (_) {}
  }

  Future<void> _deleteRemote(String id) async {
    try {
      await SupabaseService.deleteCommande(id);
    } catch (_) {}
  }

  int get totalItems => state.fold(0, (sum, item) => sum + item.quantity);
  int get totalPrice => state.fold(0, (sum, item) => sum + item.totalPrice);
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
