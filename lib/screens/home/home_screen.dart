import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_theme.dart';
import '../../providers/home_provider.dart';

// Import all section widgets
import 'widgets/home_app_bar.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/banner_slider.dart';
import 'widgets/service_benefits.dart';
import 'widgets/section_header.dart';
import 'widgets/category_list.dart';
import 'widgets/product_grid.dart';
import 'widgets/promotion_cards.dart';

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
      appBar: const HomeAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          // Search bar
          const SearchBarWidget(),
          const SizedBox(height: AppSpacing.md),

          // Banner slider
          BannerSlider(banners: mockBanners),

          // Service benefits
          const ServiceBenefits(),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),

          // Category section
          const SectionHeader.withSeeAll(title: 'Danh mục nổi bật'),
          const SizedBox(height: 4),
          CategoryList(categories: mockCategories),

          const Divider(height: 1, color: Color(0xFFF0F0F0)),

          // Featured products section
          const SectionHeader.withSeeAll(title: 'Sản phẩm nổi bật'),
          const SizedBox(height: 4),
          ProductGrid(
            products: mockFeaturedProducts,
            onProductTap: (productId) => context.push('/product/$productId'),
          ),

          // Promotion cards
          const PromotionCards(),
        ],
      ),
    );
  }
}