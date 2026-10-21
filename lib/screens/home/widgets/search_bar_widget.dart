import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_theme.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Material(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: () => context.push('/search'),
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.hairline),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppColors.inkSoft, size: 19),
                const SizedBox(width: AppSpacing.sm + 2),
                Expanded(
                  child: Text(
                    'Tìm kiếm mũ bảo hiểm...',
                    style: AppTextStyles.searchHint,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.hairline),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    'LỌC',
                    style: AppTextStyles.meta.copyWith(
                      fontSize: 9.5,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
