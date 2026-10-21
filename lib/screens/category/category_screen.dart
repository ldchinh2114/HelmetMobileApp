import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_theme.dart';
import '../../providers/filter_provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/search_provider.dart';
import '../../widgets/common/classic_ui.dart';
import '../home/widgets/product_card.dart';
import 'widgets/filter_sheet.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(filterProvider);
    final filterNotifier = ref.read(filterProvider.notifier);
    final productsAsync = ref.watch(filteredProductsProvider);
    final categories = mockCategories;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Danh mục', style: AppTextStyles.sectionTitle),
        centerTitle: true,
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.tune, color: AppColors.ink, size: 21),
                tooltip: 'Bộ lọc',
                onPressed: () => _showFilterSheet(context),
              ),
              if (filterNotifier.activeFilterCount > 0)
                Positioned(
                  right: 6,
                  top: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${filterNotifier.activeFilterCount}',
                        style: AppTextStyles.badgeCount,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        shape: const Border(bottom: AppBorders.hairline),
      ),
      body: Column(
        children: [
          // Category chips
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              children: [
                ClassicChoiceChip(
                  label: 'Tất cả',
                  isSelected: filter.categoryId == null,
                  onTap: () => filterNotifier.updateCategory(null),
                ),
                const SizedBox(width: AppSpacing.sm),
                ...categories.expand((cat) => [
                  ClassicChoiceChip(
                    label: cat.name,
                    isSelected: filter.categoryId == cat.id,
                    onTap: () => filterNotifier.updateCategory(cat.id),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ]),
              ],
            ),
          ),
          const Hairline(),

          // Sort + clear
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs + 2,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.hairlineStrong),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: filter.sortBy,
                      isDense: true,
                      icon: const Icon(Icons.expand_more, size: 16),
                      style: AppTextStyles.meta.copyWith(
                        fontSize: 12.5,
                        color: AppColors.ink,
                      ),
                      items: FilterCriteria.sortOptions.map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(FilterCriteria.sortLabels[s]!),
                      )).toList(),
                      onChanged: (value) {
                        if (value != null) filterNotifier.updateSortBy(value);
                      },
                    ),
                  ),
                ),
                const Spacer(),
                if (filter.hasActiveFilter)
                  GestureDetector(
                    onTap: () => filterNotifier.clearAll(),
                    child: Row(
                      children: [
                        const Icon(Icons.close, size: 13, color: AppColors.primary),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Xóa bộ lọc',
                          style: AppTextStyles.meta.copyWith(
                            fontSize: 12,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const Hairline(),

          // Product grid
          Expanded(
            child: productsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return ClassicEmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'Không có sản phẩm phù hợp',
                    message: 'Hãy nới lỏng bộ lọc để xem thêm lựa chọn.',
                    actionLabel: 'Xóa bộ lọc',
                    onAction: () => filterNotifier.clearAll(),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.63,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      onTap: () => context.push('/product/${product.id}'),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (e, _) => ClassicEmptyState(
                icon: Icons.error_outline,
                title: 'Lỗi tải dữ liệu',
                message: '$e',
                actionLabel: 'Thử lại',
                onAction: () => ref.invalidate(filteredProductsProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.ink.withValues(alpha: 0.45),
      builder: (_) => const FilterSheet(),
    );
  }
}
