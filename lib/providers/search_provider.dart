import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import 'home_provider.dart';
import 'filter_provider.dart';

class SearchState {
  final String query;
  final List<Product> results;
  final bool isLoading;
  final bool hasSearched;
  final List<String> suggestions;
  final List<String> history;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.isLoading = false,
    this.hasSearched = false,
    this.suggestions = const [],
    this.history = const [],
  });

  SearchState copyWith({
    String? query,
    List<Product>? results,
    bool? isLoading,
    bool? hasSearched,
    List<String>? suggestions,
    List<String>? history,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      hasSearched: hasSearched ?? this.hasSearched,
      suggestions: suggestions ?? this.suggestions,
      history: history ?? this.history,
    );
  }
}

class SearchNotifier extends Notifier<SearchState> {
  Timer? _debounce;
  bool _disposed = false;

  @override
  SearchState build() {
    ref.onDispose(() {
      _disposed = true;
      _debounce?.cancel();
    });
    return const SearchState();
  }

  void updateQuery(String query) {
    state = state.copyWith(query: query);
    _debounce?.cancel();

    if (query.isEmpty) {
      state = state.copyWith(results: [], hasSearched: false, isLoading: false);
      return;
    }

    // Show suggestions based on query
    final suggestions = _getSuggestions(query);
    state = state.copyWith(suggestions: suggestions);

    // Debounce 300ms before searching
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!_disposed) _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (_disposed) return;
    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(productRepositoryProvider);
      final results = await repo.searchProducts(query);
      if (_disposed) return;
      state = state.copyWith(
        results: results,
        isLoading: false,
        hasSearched: true,
      );
      // Add to history
      if (results.isNotEmpty && !state.history.contains(query)) {
        state = state.copyWith(
          history: [query, ...state.history].take(10).toList(),
        );
      }
    } catch (e) {
      if (!_disposed) {
        state = state.copyWith(isLoading: false, hasSearched: true);
      }
    }
  }

  void selectSuggestion(String suggestion) {
    state = state.copyWith(query: suggestion);
    _performSearch(suggestion);
  }

  void clearSearch() {
    _debounce?.cancel();
    state = const SearchState(history: []);
  }

  void removeHistoryItem(String item) {
    state = state.copyWith(
      history: state.history.where((h) => h != item).toList(),
    );
  }

  List<String> _getSuggestions(String query) {
    final suggestions = <String>[
      'Mũ fullface',
      'Mũ 3/4',
      'Mũ 1/2',
      'Mũ trẻ em',
      'Mũ phượt',
      'Mũ HELMO',
      'Mũ carbon',
      'Mũ giá rẻ',
    ];
    return suggestions.where((s) => s.toLowerCase().contains(query.toLowerCase())).toList();
  }
}

final searchProvider = NotifierProvider<SearchNotifier, SearchState>(() {
  return SearchNotifier();
});

// Filtered products provider based on category + filter criteria
final filteredProductsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final filter = ref.watch(filterProvider);
  final repo = ref.watch(productRepositoryProvider);
  return repo.fetchProducts(
    categoryId: filter.categoryId,
    search: filter.searchQuery,
    sortBy: filter.sortBy,
    brand: filter.brand,
    color: filter.color,
    minPrice: filter.minPrice,
    maxPrice: filter.maxPrice,
  );
});