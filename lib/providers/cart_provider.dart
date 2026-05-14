import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

// Cart state
class CartState {
  final List<CartItem> items;

  const CartState({this.items = const []});

  int get totalCount => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  int get itemCount => items.length;

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}

// Cart notifier using Notifier (Riverpod 3.x)
class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() => const CartState();

  /// Add item to cart. If same product + size + color exists, increase quantity.
  void addItem(Product product, {String size = 'M', String color = 'Đen', int quantity = 1}) {
    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == product.id && item.size == size && item.color == color,
    );

    if (existingIndex >= 0) {
      // Update existing item quantity
      final updatedItems = [...state.items];
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + quantity,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      // Add new item
      final newItem = CartItem(
        id: '${product.id}_${size}_${color}_${DateTime.now().millisecondsSinceEpoch}',
        product: product,
        size: size,
        color: color,
        quantity: quantity,
      );
      state = state.copyWith(items: [...state.items, newItem]);
    }
  }

  /// Remove item by id
  void removeItem(String itemId) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != itemId).toList(),
    );
  }

  /// Update item quantity
  void updateQuantity(String itemId, int quantity) {
    if (quantity < 1) return;
    state = state.copyWith(
      items: state.items.map((item) {
        if (item.id == itemId) {
          return item.copyWith(quantity: quantity);
        }
        return item;
      }).toList(),
    );
  }

  /// Increment item quantity
  void incrementQuantity(String itemId) {
    final item = state.items.firstWhere((i) => i.id == itemId);
    if (item.quantity < 99) {
      updateQuantity(itemId, item.quantity + 1);
    }
  }

  /// Decrement item quantity
  void decrementQuantity(String itemId) {
    final item = state.items.firstWhere((i) => i.id == itemId);
    if (item.quantity > 1) {
      updateQuantity(itemId, item.quantity - 1);
    }
  }

  /// Clear entire cart
  void clearCart() {
    state = const CartState();
  }
}

// Provider using NotifierProvider (Riverpod 3.x)
final cartProvider = NotifierProvider<CartNotifier, CartState>(() {
  return CartNotifier();
});

// Cart count provider (derived for badge)
final cartCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).totalCount;
});