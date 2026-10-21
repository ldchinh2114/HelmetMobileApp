import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_theme.dart';
import '../../providers/home_provider.dart';
import '../../widgets/common/classic_ui.dart';

import 'widgets/banner_slider.dart';
import 'widgets/category_list.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_drawer.dart';
import 'widgets/product_grid.dart';
import 'widgets/promotion_cards.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/section_header.dart';
import 'widgets/service_benefits.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const HomeDrawer(),
      appBar: const HomeAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Reveal(
              child: Padding(
                padding: EdgeInsets.only(top: AppSpacing.lg),
                child: SearchBarWidget(),
              ),
            ),
            Reveal(
              delay: const Duration(milliseconds: 60),
              child: BannerSlider(banners: mockBanners),
            ),
            const Reveal(
              delay: Duration(milliseconds: 120),
              child: ServiceBenefits(),
            ),
            const Hairline(indent: AppSpacing.lg),
            Reveal(
              delay: const Duration(milliseconds: 170),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.xl,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: SectionHeader.withSeeAll(
                      title: 'Danh mục nổi bật',
                      eyebrow: 'Bộ sưu tập',
                    ),
                  ),
                  CategoryList(categories: mockCategories),
                ],
              ),
            ),
            const Hairline(indent: AppSpacing.lg),
            Reveal(
              delay: const Duration(milliseconds: 230),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.xl,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: SectionHeader.withSeeAll(
                      title: 'Sản phẩm nổi bật',
                      eyebrow: 'Bán chạy',
                    ),
                  ),
                  ProductGrid(
                    products: mockFeaturedProducts,
                    onProductTap: (productId) =>
                        context.push('/product/$productId'),
                  ),
                ],
              ),
            ),
            Reveal(
              delay: const Duration(milliseconds: 300),
              child: const PromotionCards(),
            ),
            const _HomeFooter(),
          ],
        ),
      ),
    );
  }
}

class _HomeFooter extends StatelessWidget {
  const _HomeFooter();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Hairline(indent: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('HELMO', style: AppTextStyles.wordmark),
              const SizedBox(height: AppSpacing.sm),
              const GoldRule(width: 34),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Chuyên mũ bảo hiểm chính hãng từ 2012. '
                'Sản phẩm đạt chuẩn an toàn quốc tế, bảo hành 12 tháng '
                'và đổi trả trong 7 ngày.',
                style: AppTextStyles.bodyMuted.copyWith(fontSize: 12.5),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Hairline(),
              const SizedBox(height: AppSpacing.md),
              Text(
                '© 2026 HELMO · 24 Hai Bà Trưng, Hà Nội',
                style: AppTextStyles.meta.copyWith(
                  fontSize: 10.5,
                  letterSpacing: 0.8,
                  color: AppColors.inkFaint,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
