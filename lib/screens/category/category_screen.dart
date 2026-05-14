import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_theme.dart';
import '../../providers/filter_provider.dart';
import '../../providers/search_provider.dart';
import '../../providers/home_provider.dart';
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
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: AppColors.white,
        title: const Text('Danh mục', style: AppTextStyles.sectionTitle),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.tune, color: AppColors.black, size: 24),
                onPressed: () => _showFilterSheet(context),
              ),
              if (filterNotifier.activeFilterCount > 0)
                Positioned(
                  right: 8,
                  top: 6,
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
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Category chips
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
              children: [
                _CategoryChip(
                  label: 'Tất cả',
                  isSelected: filter.categoryId == null,
                  onTap: () => filterNotifier.updateCategory(null),
                ),
                ...categories.map((cat) => _CategoryChip(
                  label: cat.name,
                  isSelected: filter.categoryId == cat.id,
                  onTap: () => filterNotifier.updateCategory(cat.id),
                )),
              ],
            ),
          ),

          // Sort + Clear filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                // Sort dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightGray.withValues(alpha: 0.5)),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: filter.sortBy,
                      isDense: true,
                      icon: const Icon(Icons.arrow_drop_down, size: 18),
                      style: const TextStyle(fontSize: 13, color: AppColors.darkGray),
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
                    child: const Row(
                      children: [
                        Icon(Icons.close, size: 14, color: AppColors.gray),
                        SizedBox(width: 4),
                        Text('Xóa bộ lọc', style: TextStyle(fontSize: 12, color: AppColors.gray)),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Product grid
          Expanded(
            child: productsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: AppSpacing.md),
                        const Text('Không có sản phẩm phù hợp', style: AppTextStyles.productName),
                        const SizedBox(height: AppSpacing.sm),
                        ElevatedButton(
                          onPressed: () => filterNotifier.clearAll(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Xóa bộ lọc'),
                        ),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      onTap: () => context.push('/product/${product.id}'),
                      onFavoriteTap: () {},
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (e, _) => Center(child: Text('Lỗi: $e')),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterSheet(),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.xxl),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.lightGray,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.darkGray,
            ),
          ),
        ),
      ),
    );
  }
}