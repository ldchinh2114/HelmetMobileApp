import 'dart:async';

import 'package:flutter/material.dart';
import '../../../config/app_motion.dart';
import '../../../config/app_theme.dart';
import '../../../models/product.dart';
import '../../../widgets/common/product_artwork.dart';

class BannerSlider extends StatefulWidget {
  final List<BannerItem> banners;

  const BannerSlider({super.key, required this.banners});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || widget.banners.isEmpty) return;
      final nextPage = (_currentPage + 1) % widget.banners.length;
      _pageController.animateToPage(
        nextPage,
        duration: AppMotion.slow,
        curve: AppMotion.emphasized,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        children: [
          SizedBox(
            height: 208,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: widget.banners.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: _BannerCard(
                    banner: widget.banners[index],
                    style: HelmetStyle.values[index % HelmetStyle.values.length],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _Indicator(
            count: widget.banners.length,
            currentIndex: _currentPage,
          ),
        ],
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  final BannerItem banner;
  final HelmetStyle style;

  const _BannerCard({required this.banner, required this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E2823), Color(0xFF4A3226), Color(0xFF5E1826)],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Decorative helmet mark
          Positioned(
            right: -18,
            top: 16,
            child: SizedBox(
              width: 180,
              height: 180,
              child: Opacity(
                opacity: 0.22,
                child: HelmetMark(
                  style: style,
                  color: AppColors.gold,
                  strokeWidth: 1.4,
                ),
              ),
            ),
          ),
          // Gold frame
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.28),
                  ),
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'HELMO COLLECTION',
                  style: AppTextStyles.eyebrow.copyWith(color: AppColors.gold),
                ),
                const SizedBox(height: AppSpacing.sm),
                if (banner.title != null)
                  Text(
                    banner.title!,
                    style: AppTextStyles.displayMedium.copyWith(
                      color: Colors.white,
                      fontSize: 23,
                    ),
                  ),
                if (banner.subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs + 2),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: Text(
                      banner.subtitle!,
                      style: AppTextStyles.bodyMuted.copyWith(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
                if (banner.buttonText != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  _GoldButton(label: banner.buttonText!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GoldButton extends StatelessWidget {
  final String label;

  const _GoldButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 9),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gold),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.buttonSmall.copyWith(
          color: AppColors.gold,
          fontSize: 10.5,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

/// Thin segmented rule instead of dots.
class _Indicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _Indicator({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = currentIndex == index;
        return AnimatedContainer(
          duration: AppMotion.quick,
          curve: AppMotion.emphasized,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 26 : 12,
          height: 2,
          decoration: BoxDecoration(
            color: isActive ? AppColors.gold : AppColors.hairlineStrong,
          ),
        );
      }),
    );
  }
}
