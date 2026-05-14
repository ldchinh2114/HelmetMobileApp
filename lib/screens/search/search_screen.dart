import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_theme.dart';
import '../../providers/search_provider.dart';
import '../home/widgets/product_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: AppColors.white,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(AppRadius.xxl),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            onChanged: (value) => ref.read(searchProvider.notifier).updateQuery(value),
            decoration: const InputDecoration(
              hintText: 'Tìm kiếm mũ bảo hiểm...',
              hintStyle: AppTextStyles.searchHint,
              prefixIcon: Icon(Icons.search, color: AppColors.gray, size: 22),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Hủy', style: TextStyle(color: AppColors.darkGray, fontSize: 14)),
          ),
        ],
      ),
      body: _buildBody(searchState),
    );
  }

  Widget _buildBody(SearchState searchState) {
    // Initial state - show suggestions and history
    if (!searchState.hasSearched && searchState.query.isEmpty) {
      return _buildInitial(searchState);
    }

    // Loading
    if (searchState.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    // Has results
    if (searchState.results.isNotEmpty) {
      return _buildResults(searchState);
    }

    // Has searched but no results
    if (searchState.hasSearched && searchState.results.isEmpty) {
      return _buildEmptyResults(searchState);
    }

    // Suggestions while typing
    if (searchState.query.isNotEmpty && searchState.suggestions.isNotEmpty) {
      return _buildSuggestions(searchState);
    }

    return const SizedBox.shrink();
  }

  Widget _buildInitial(SearchState searchState) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Suggestions
          const Text('Gợi ý tìm kiếm', style: AppTextStyles.productName),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Fullface', '3/4', 'Giá rẻ', 'Carbon', 'Trẻ em', 'HELMO'].map((s) {
              return ActionChip(
                label: Text(s, style: const TextStyle(color: Colors.white, fontSize: 13)),
                backgroundColor: AppColors.primary.withValues(alpha: 0.8),
                onPressed: () {
                  _searchController.text = s;
                  ref.read(searchProvider.notifier).selectSuggestion(s);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.xl),

          // History
          if (searchState.history.isNotEmpty) ...[
            const Text('Lịch sử tìm kiếm', style: AppTextStyles.productName),
            const SizedBox(height: AppSpacing.sm),
            ...searchState.history.map((h) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.history, size: 20, color: AppColors.gray),
              title: Text(h, style: const TextStyle(fontSize: 14, color: AppColors.darkGray)),
              trailing: GestureDetector(
                onTap: () => ref.read(searchProvider.notifier).removeHistoryItem(h),
                child: const Icon(Icons.close, size: 16, color: AppColors.lightGray),
              ),
              onTap: () {
                _searchController.text = h;
                ref.read(searchProvider.notifier).selectSuggestion(h);
              },
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestions(SearchState searchState) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: searchState.suggestions.length,
      separatorBuilder: (_, _) => const Divider(height: 1, color: Color(0xFFF0F0F0)),
      itemBuilder: (context, index) {
        final suggestion = searchState.suggestions[index];
        return ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.search, size: 20, color: AppColors.gray),
          title: Text(suggestion,
            style: const TextStyle(fontSize: 14),
          ),
          onTap: () {
            _searchController.text = suggestion;
            ref.read(searchProvider.notifier).selectSuggestion(suggestion);
          },
        );
      },
    );
  }

  Widget _buildResults(SearchState searchState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
          child: Text(
            'Tìm thấy ${searchState.results.length} sản phẩm cho "${searchState.query}"',
            style: AppTextStyles.soldCount.copyWith(fontSize: 13),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: GridView.builder(
              itemCount: searchState.results.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final product = searchState.results[index];
                return ProductCard(
                  product: product,
                  onTap: () => context.push('/product/${product.id}'),
                  onFavoriteTap: () {},
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyResults(SearchState searchState) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            const SizedBox(height: AppSpacing.lg),
            const Text('Không tìm thấy sản phẩm', style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Không có kết quả cho "${searchState.query}"',
              style: AppTextStyles.soldCount,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Gợi ý: Kiểm tra từ khóa hoặc xem danh mục sản phẩm',
              style: AppTextStyles.soldCount,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}