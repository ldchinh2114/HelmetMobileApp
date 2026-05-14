import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterCriteria {
  final String? categoryId;
  final String? brand;
  final String? color;
  final double? minPrice;
  final double? maxPrice;
  final String sortBy; // 'newest', 'price_asc', 'price_desc', 'best_seller'
  final String? searchQuery;

  const FilterCriteria({
    this.categoryId,
    this.brand,
    this.color,
    this.minPrice,
    this.maxPrice,
    this.sortBy = 'newest',
    this.searchQuery,
  });

  FilterCriteria copyWith({
    String? categoryId,
    String? brand,
    String? color,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? searchQuery,
    bool clearCategoryId = false,
    bool clearBrand = false,
    bool clearColor = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearSearchQuery = false,
  }) {
    return FilterCriteria(
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
      brand: clearBrand ? null : (brand ?? this.brand),
      color: clearColor ? null : (color ?? this.color),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      sortBy: sortBy ?? this.sortBy,
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
    );
  }

  bool get hasActiveFilter =>
      categoryId != null ||
      brand != null ||
      color != null ||
      minPrice != null ||
      maxPrice != null;

  static const List<String> sortOptions = [
    'newest',
    'price_asc',
    'price_desc',
    'best_seller',
  ];

  static const Map<String, String> sortLabels = {
    'newest': 'Mới nhất',
    'price_asc': 'Giá: Thấp → Cao',
    'price_desc': 'Giá: Cao → Thấp',
    'best_seller': 'Bán chạy',
  };

  static const List<PriceRange> priceRanges = [
    PriceRange(label: 'Dưới 500k', min: null, max: 500000),
    PriceRange(label: '500k - 1tr', min: 500000, max: 1000000),
    PriceRange(label: '1tr - 2tr', min: 1000000, max: 2000000),
    PriceRange(label: 'Trên 2tr', min: 2000000, max: null),
  ];
}

class PriceRange {
  final String label;
  final double? min;
  final double? max;

  const PriceRange({required this.label, this.min, this.max});
}

class FilterNotifier extends Notifier<FilterCriteria> {
  @override
  FilterCriteria build() => const FilterCriteria();

  void updateCategory(String? categoryId) {
    state = state.copyWith(categoryId: categoryId);
  }

  void updateBrand(String? brand) {
    state = state.copyWith(brand: brand);
  }

  void updateColor(String? color) {
    state = state.copyWith(color: color);
  }

  void updatePriceRange(double? min, double? max) {
    state = state.copyWith(
      minPrice: min,
      maxPrice: max,
      clearMinPrice: min == null,
      clearMaxPrice: max == null,
    );
  }

  void updateSortBy(String sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void updateSearchQuery(String? query) {
    state = state.copyWith(
      searchQuery: query,
      clearSearchQuery: query == null || query.isEmpty,
    );
  }

  void clearAll() {
    state = const FilterCriteria();
  }

  int get activeFilterCount {
    int count = 0;
    if (state.categoryId != null) count++;
    if (state.brand != null) count++;
    if (state.color != null) count++;
    if (state.minPrice != null || state.maxPrice != null) count++;
    return count;
  }
}

final filterProvider = NotifierProvider<FilterNotifier, FilterCriteria>(() {
  return FilterNotifier();
});

// Brands list
const List<String> brands = ['HELMO', 'Royal', 'LS2', 'NAN', 'Andes'];
const List<String> colorOptions = ['Đen', 'Trắng', 'Xanh', 'Đỏ', 'Bạc', 'Vàng'];