import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wishlist state — previously the heart buttons were inert.
class WishlistNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};

  bool contains(String productId) => state.contains(productId);

  void toggle(String productId) {
    final next = {...state};
    if (!next.remove(productId)) next.add(productId);
    state = next;
  }
}

final wishlistProvider =
    NotifierProvider<WishlistNotifier, Set<String>>(WishlistNotifier.new);
