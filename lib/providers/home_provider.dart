import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

// Repository provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

// Product list provider
final productListProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.fetchProducts();
});

// Product detail provider
final productDetailProvider =
    FutureProvider.family.autoDispose<Product?, String>((ref, id) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getById(id);
});

// -- Mock Data (for Phase 1, will be removed when API is ready) --

class HomeData {
  final List<BannerItem> banners;
  final List<ProductCategory> categories;
  final List<Product> featuredProducts;

  const HomeData({
    required this.banners,
    required this.categories,
    required this.featuredProducts,
  });
}

final List<BannerItem> mockBanners = [
  BannerItem(
    id: 'b1',
    imageUrl: 'https://picsum.photos/seed/helmet1/800/400',
    title: 'Fullface Chính Hãng',
    subtitle: 'Bảo vệ tối đa cho mọi hành trình',
    buttonText: 'Mua ngay',
    overlayColor: Colors.black54,
  ),
  BannerItem(
    id: 'b2',
    imageUrl: 'https://picsum.photos/seed/helmet2/800/400',
    title: 'Mũ 3/4 Thời Trang',
    subtitle: 'Phong cách trẻ trung, năng động',
    buttonText: 'Mua ngay',
    overlayColor: Colors.black45,
  ),
  BannerItem(
    id: 'b3',
    imageUrl: 'https://picsum.photos/seed/helmet3/800/400',
    title: 'Sale Mùa Hè',
    subtitle: 'Giảm đến 30% tất cả sản phẩm',
    buttonText: 'Xem ngay',
    overlayColor: Colors.black45,
  ),
];

final List<ProductCategory> mockCategories = [
  ProductCategory(id: 'c1', name: 'Fullface', imageUrl: 'https://picsum.photos/seed/fullface/200/200'),
  ProductCategory(id: 'c2', name: '3/4', imageUrl: 'https://picsum.photos/seed/threefour/200/200'),
  ProductCategory(id: 'c3', name: '1/2', imageUrl: 'https://picsum.photos/seed/half/200/200'),
  ProductCategory(id: 'c4', name: 'Trẻ em', imageUrl: 'https://picsum.photos/seed/kids/200/200'),
  ProductCategory(id: 'c5', name: 'Phượt', imageUrl: 'https://picsum.photos/seed/adventure/200/200'),
];

final List<Product> mockFeaturedProducts = [
  Product(
    id: 'p1',
    name: 'Mũ Fullface HELMO Racer Carbon',
    price: 1890000,
    originalPrice: 2500000,
    discountPercent: 24,
    imageUrl: 'https://picsum.photos/seed/product1/400/400',
    rating: 4.8,
    soldCount: 256,
    categoryId: 'c1',
  ),
  Product(
    id: 'p2',
    name: 'Mũ 3/4 HELMO City Urban',
    price: 850000,
    originalPrice: 1200000,
    discountPercent: 29,
    imageUrl: 'https://picsum.photos/seed/product2/400/400',
    rating: 4.5,
    soldCount: 189,
    categoryId: 'c2',
  ),
  Product(
    id: 'p3',
    name: 'Mũ 1/2 HELMO Sport Lite',
    price: 550000,
    originalPrice: 750000,
    discountPercent: 27,
    imageUrl: 'https://picsum.photos/seed/product3/400/400',
    rating: 4.3,
    soldCount: 320,
    categoryId: 'c3',
  ),
  Product(
    id: 'p4',
    name: 'Mũ Trẻ Em HELMO Kiddo',
    price: 390000,
    originalPrice: null,
    discountPercent: null,
    imageUrl: 'https://picsum.photos/seed/product4/400/400',
    rating: 4.7,
    soldCount: 145,
    categoryId: 'c4',
  ),
  Product(
    id: 'p5',
    name: 'Mũ Phượt HELMO Explorer Pro',
    price: 1250000,
    originalPrice: 1600000,
    discountPercent: 22,
    imageUrl: 'https://picsum.photos/seed/product5/400/400',
    rating: 4.6,
    soldCount: 98,
    categoryId: 'c5',
  ),
  Product(
    id: 'p6',
    name: 'Mũ Fullface HELMO Street Fighter',
    price: 2150000,
    originalPrice: null,
    discountPercent: null,
    imageUrl: 'https://picsum.photos/seed/product6/400/400',
    rating: 4.9,
    soldCount: 67,
    categoryId: 'c1',
  ),
];

// Format currency
String formatCurrency(double amount) {
  return '${amount ~/ 1000}.${(amount % 1000).toString().padLeft(3, '0')}đ';
}