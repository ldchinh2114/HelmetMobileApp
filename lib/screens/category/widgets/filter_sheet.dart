import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/app_theme.dart';
import '../../../providers/filter_provider.dart';
import '../../../providers/home_provider.dart';

class FilterSheet extends ConsumerWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);
    final notifier = ref.read(filterProvider.notifier);
    final categories = mockCategories;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Bộ lọc', style: AppTextStyles.sectionTitle),
                TextButton(
                  onPressed: () => notifier.clearAll(),
                  child: const Text('Đặt lại', style: TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
          ),

          const Divider(),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  const Text('Danh mục', style: AppTextStyles.productName),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _FilterChip(
                        label: 'Tất cả',
                        isSelected: filter.categoryId == null,
                        onTap: () => notifier.updateCategory(null),
                      ),
                      ...categories.map((cat) => _FilterChip(
                        label: cat.name,
                        isSelected: filter.categoryId == cat.id,
                        onTap: () => notifier.updateCategory(cat.id),
                      )),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Brand
                  const Text('Thương hiệu', style: AppTextStyles.productName),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _FilterChip(
                        label: 'Tất cả',
                        isSelected: filter.brand == null,
                        onTap: () => notifier.updateBrand(null),
                      ),
                      ...brands.map((b) => _FilterChip(
                        label: b,
                        isSelected: filter.brand == b,
                        onTap: () => notifier.updateBrand(b),
                      )),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Color
                  const Text('Màu sắc', style: AppTextStyles.productName),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _FilterChip(
                        label: 'Tất cả',
                        isSelected: filter.color == null,
                        onTap: () => notifier.updateColor(null),
                      ),
                      ...colorOptions.map((c) => _FilterChip(
                        label: c,
                        isSelected: filter.color == c,
                        onTap: () => notifier.updateColor(c),
                      )),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Price range
                  const Text('Khoảng giá', style: AppTextStyles.productName),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _FilterChip(
                        label: 'Tất cả',
                        isSelected: filter.minPrice == null && filter.maxPrice == null,
                        onTap: () => notifier.updatePriceRange(null, null),
                      ),
                      ...FilterCriteria.priceRanges.map((r) => _FilterChip(
                        label: r.label,
                        isSelected: filter.minPrice == r.min && filter.maxPrice == r.max,
                        onTap: () => notifier.updatePriceRange(r.min, r.max),
                      )),
                    ],
                  ),

                  SizedBox(height: bottom + AppSpacing.lg),
                ],
              ),
            ),
          ),

          // Apply button
          Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: bottom + AppSpacing.md,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: const Text('Áp dụng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            color: isSelected ? Colors.white : AppColors.darkGray,
          ),
        ),
      ),
    );
  }
}