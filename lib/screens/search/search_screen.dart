import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_theme.dart';
import '../../providers/search_provider.dart';
import '../../widgets/common/classic_ui.dart';
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
    Future<void>.delayed(const Duration(milliseconds: 120), () {
      if (mounted) _focusNode.requestFocus();
    });
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
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: AppSpacing.md),
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.paper,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.hairline),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              onChanged: (value) =>
                  ref.read(searchProvider.notifier).updateQuery(value),
              style: AppTextStyles.searchText,
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm mũ bảo hiểm...',
                hintStyle: AppTextStyles.searchHint,
                prefixIcon: Icon(Icons.search, color: AppColors.inkSoft, size: 19),
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 11, horizontal: 4),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Hủy'),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        shape: const Border(bottom: AppBorders.hairline),
      ),
      body: _buildBody(searchState),
    );
  }

  Widget _buildBody(SearchState searchState) {
    if (!searchState.hasSearched && searchState.query.isEmpty) {
      return _buildInitial(searchState);
    }

    if (searchState.isLoading) {
      return const Center(
        child: SizedBox(
          width: 26,
          height: 26,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (searchState.results.isNotEmpty) {
      return _buildResults(searchState);
    }

    if (searchState.hasSearched && searchState.results.isEmpty) {
      return ClassicEmptyState(
        icon: Icons.search_off,
        title: 'Không tìm thấy sản phẩm',
        message: 'Không có kết quả cho "${searchState.query}". '
            'Thử một từ khóa khác hoặc xem danh mục sản phẩm.',
        actionLabel: 'Xem danh mục',
        onAction: () {
          context.pop();
          context.go('/category');
        },
      );
    }

    if (searchState.query.isNotEmpty && searchState.suggestions.isNotEmpty) {
      return _buildSuggestions(searchState);
    }

    return const SizedBox.shrink();
  }

  Widget _buildInitial(SearchState searchState) {
    const suggestions = [
      'Fullface',
      '3/4',
      'Giá rẻ',
      'Carbon',
      'Trẻ em',
      'HELMO',
    ];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        const Eyebrow('Gợi ý tìm kiếm'),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: suggestions.map((s) {
            return ClassicChoiceChip(
              label: s,
              isSelected: false,
              onTap: () {
                _searchController.text = s;
                ref.read(searchProvider.notifier).selectSuggestion(s);
              },
            );
          }).toList(),
        ),
        if (searchState.history.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Eyebrow('Lịch sử tìm kiếm'),
              GestureDetector(
                onTap: () => ref.read(searchProvider.notifier).clearSearch(),
                child: Text(
                  'Xóa tất cả',
                  style: AppTextStyles.meta.copyWith(
                    color: AppColors.primary,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Hairline(),
          ...searchState.history.map((h) => _HistoryRow(
                label: h,
                onTap: () {
                  _searchController.text = h;
                  ref.read(searchProvider.notifier).selectSuggestion(h);
                },
                onRemove: () =>
                    ref.read(searchProvider.notifier).removeHistoryItem(h),
              )),
        ],
      ],
    );
  }

  Widget _buildSuggestions(SearchState searchState) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: searchState.suggestions.length,
      separatorBuilder: (_, _) => const Hairline(),
      itemBuilder: (context, index) {
        final suggestion = searchState.suggestions[index];
        return _HistoryRow(
          label: suggestion,
          icon: Icons.search,
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
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Tìm thấy ${searchState.results.length} sản phẩm cho '
                  '"${searchState.query}"',
                  style: AppTextStyles.meta.copyWith(fontSize: 12.5),
                ),
              ),
              const GoldRule(width: 20),
            ],
          ),
        ),
        const Hairline(indent: AppSpacing.lg),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: GridView.builder(
              itemCount: searchState.results.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.63,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
              ),
              itemBuilder: (context, index) {
                final product = searchState.results[index];
                return ProductCard(
                  product: product,
                  onTap: () => context.push('/product/${product.id}'),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const _HistoryRow({
    required this.label,
    required this.onTap,
    this.icon = Icons.history,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, size: 17, color: AppColors.inkFaint),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(fontSize: 13.5),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onRemove != null)
              GestureDetector(
                onTap: onRemove,
                child: const Icon(Icons.close, size: 15, color: AppColors.inkFaint),
              ),
          ],
        ),
      ),
    );
  }
}
