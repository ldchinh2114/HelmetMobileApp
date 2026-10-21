import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/app_theme.dart';
import '../../../providers/filter_provider.dart';
import '../../../providers/home_provider.dart';
import '../../../widgets/common/classic_ui.dart';

class FilterSheet extends ConsumerWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);
    final notifier = ref.read(filterProvider.notifier);
    final categories = mockCategories;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.82,
      ),
      decoration: const BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        border: Border(top: AppBorders.hairline),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.md),
            width: 36,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.hairlineStrong,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Row(
              children: [
                const Text('Bộ lọc', style: AppTextStyles.sectionTitle),
                const SizedBox(width: AppSpacing.sm),
                const GoldRule(width: 18),
                const Spacer(),
                TextButton(
                  onPressed: () => notifier.clearAll(),
                  child: const Text('Đặt lại'),
                ),
              ],
            ),
          ),
          const Hairline(),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Eyebrow('Danh mục'),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      ClassicChoiceChip(
                        label: 'Tất cả',
                        isSelected: filter.categoryId == null,
                        onTap: () => notifier.updateCategory(null),
                      ),
                      ...categories.map((cat) => ClassicChoiceChip(
                            label: cat.name,
                            isSelected: filter.categoryId == cat.id,
                            onTap: () => notifier.updateCategory(cat.id),
                          )),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const Eyebrow('Thương hiệu'),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      ClassicChoiceChip(
                        label: 'Tất cả',
                        isSelected: filter.brand == null,
                        onTap: () => notifier.updateBrand(null),
                      ),
                      ...brands.map((b) => ClassicChoiceChip(
                            label: b,
                            isSelected: filter.brand == b,
                            onTap: () => notifier.updateBrand(b),
                          )),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const Eyebrow('Màu sắc'),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      ClassicChoiceChip(
                        label: 'Tất cả',
                        isSelected: filter.color == null,
                        onTap: () => notifier.updateColor(null),
                      ),
                      ...colorOptions.map((c) => ClassicChoiceChip(
                            label: c,
                            isSelected: filter.color == c,
                            onTap: () => notifier.updateColor(c),
                          )),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const Eyebrow('Khoảng giá'),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      ClassicChoiceChip(
                        label: 'Tất cả',
                        isSelected:
                            filter.minPrice == null && filter.maxPrice == null,
                        onTap: () => notifier.updatePriceRange(null, null),
                      ),
                      ...FilterCriteria.priceRanges.map((r) => ClassicChoiceChip(
                            label: r.label,
                            isSelected:
                                filter.minPrice == r.min && filter.maxPrice == r.max,
                            onTap: () => notifier.updatePriceRange(r.min, r.max),
                          )),
                    ],
                  ),
                  SizedBox(height: bottom + AppSpacing.lg),
                ],
              ),
            ),
          ),

          const Hairline(),

          // Apply
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl,
              bottom + AppSpacing.lg,
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ÁP DỤNG'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
