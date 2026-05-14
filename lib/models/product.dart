import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final double? originalPrice;
  final double? discountPercent;
  final String imageUrl;
  final double rating;
  final int soldCount;
  final bool isFavorite;
  final String? categoryId;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice,
    this.discountPercent,
    required this.imageUrl,
    this.rating = 0.0,
    this.soldCount = 0,
    this.isFavorite = false,
    this.categoryId,
  });
}

class ProductCategory {
  final String id;
  final String name;
  final String imageUrl;

  const ProductCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

class BannerItem {
  final String id;
  final String imageUrl;
  final String? title;
  final String? subtitle;
  final String? buttonText;
  final Color? overlayColor;

  const BannerItem({
    required this.id,
    required this.imageUrl,
    this.title,
    this.subtitle,
    this.buttonText,
    this.overlayColor,
  });
}