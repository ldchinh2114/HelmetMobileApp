import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_theme.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GestureDetector(
        onTap: () => context.push('/search'),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(AppRadius.xxl),
          ),
          child: const Row(
            children: [
              SizedBox(width: 16),
              Icon(Icons.search, color: AppColors.gray, size: 22),
              SizedBox(width: 8),
              Text(
                'Tìm kiếm mũ bảo hiểm...',
                style: AppTextStyles.searchHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}