import 'product.dart';

class CartItem {
  final String id;
  final Product product;
  final String size;
  final String color;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.size,
    required this.color,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    String? id,
    Product? product,
    String? size,
    String? color,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      size: size ?? this.size,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'productId': product.id,
    'productName': product.name,
    'productPrice': product.price,
    'productImageUrl': product.imageUrl,
    'size': size,
    'color': color,
    'quantity': quantity,
  };
}