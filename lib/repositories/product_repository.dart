import '../models/product.dart';
import '../providers/home_provider.dart';

/// Repository for product-related data operations.
class ProductRepository {
  /// Fetch all products with pagination, search, and filter support
  Future<List<Product>> fetchProducts({
    int page = 1,
    int limit = 10,
    String? categoryId,
    String? search,
    String? sortBy = 'newest',
    String? order,
    String? brand,
    String? color,
    double? minPrice,
    double? maxPrice,
  }) async {
    // TODO: Replace with API call
    await Future.delayed(const Duration(milliseconds: 400));

    List<Product> result = List.from(mockFeaturedProducts);

    // Filter by category
    if (categoryId != null) {
      result = result.where((p) => p.categoryId == categoryId).toList();
    }

    // Filter by search query
    if (search != null && search.isNotEmpty) {
      final query = search.toLowerCase();
      result = result.where((p) =>
        p.name.toLowerCase().contains(query) ||
        (p.categoryId?.toLowerCase().contains(query) ?? false)
      ).toList();
    }

    // Filter by brand (using product name as proxy for demo)
    if (brand != null) {
      result = result.where((p) => p.name.contains(brand)).toList();
    }

    // Filter by color (simulated)
    if (color != null) {
      // In real app, product has a color field
    }

    // Filter by price range
    if (minPrice != null) {
      result = result.where((p) => p.price >= minPrice).toList();
    }
    if (maxPrice != null) {
      result = result.where((p) => p.price <= maxPrice).toList();
    }

    // Sort
    switch (sortBy) {
      case 'price_asc':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'best_seller':
        result.sort((a, b) => b.soldCount.compareTo(a.soldCount));
        break;
      case 'newest':
      default:
        // Keep original order as "newest"
        break;
    }

    // Pagination
    final start = (page - 1) * limit;
    if (start >= result.length) return [];
    final end = start + limit > result.length ? result.length : start + limit;
    return result.sublist(start, end);
  }

  /// Get a single product by ID
  Future<Product?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return mockFeaturedProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Search products with debounce simulation
  Future<List<Product>> searchProducts(String query, {int page = 1, int limit = 10}) async {
    return fetchProducts(search: query, page: page, limit: limit);
  }

  /// Get products by category
  Future<List<Product>> getByCategory(String categoryId, {int page = 1, int limit = 10}) async {
    return fetchProducts(categoryId: categoryId, page: page, limit: limit);
  }
}