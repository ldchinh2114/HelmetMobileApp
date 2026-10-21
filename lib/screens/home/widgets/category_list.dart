import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_theme.dart';
import '../../../models/product.dart';
import '../../../providers/filter_provider.dart';

class CategoryList extends ConsumerWidget {
  final List<ProductCategory> categories;

  const CategoryList({super.key, required this.categories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.lg),
        itemBuilder: (context, index) {
          final category = categories[index];
          return _CategoryCard(
            category: category,
            onTap: () {
              ref.read(filterProvider.notifier).updateCategory(category.id);
              context.go('/category');
            },
          );
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final ProductCategory category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 76,
        child: Column(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: const BoxDecoration(
                color: AppColors.paper,
                shape: BoxShape.circle,
                border: Border.fromBorderSide(AppBorders.hairline),
              ),
              child: Center(
                child: Icon(
                  iconForCategory(category.name),
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              category.name,
              style: AppTextStyles.meta.copyWith(
                color: AppColors.ink,
                fontSize: 11.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Icons used across the catalogue for the helmet families.
IconData iconForCategory(String name) {
  switch (name.toLowerCase()) {
    case 'fullface':
      return Icons.sports_motorsports;
    case '3/4':
      return Icons.motorcycle;
    case '1/2':
      return Icons.sports_esports;
    case 'trẻ em':
      return Icons.child_care;
    case 'phượt':
      return Icons.landscape_outlined;
    default:
      return Icons.moped;
  }
}
