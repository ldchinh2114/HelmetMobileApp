import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_theme.dart';
import '../../widgets/common/classic_ui.dart';
import '../../widgets/common/product_artwork.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..forward();

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    // TODO: Check auth token here
    _navigationTimer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Faint roundel behind the mark
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Center(
                child: SizedBox(
                  width: 360,
                  height: 360,
                  child: HelmetMark(
                    style: HelmetStyle.fullFace,
                    color: AppColors.gold,
                    strokeWidth: 1.1,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: HelmetMark(
                    style: HelmetStyle.fullFace,
                    color: AppColors.primary,
                    strokeWidth: 1.8,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text('HELMO', style: AppTextStyles.wordmark),
                const SizedBox(height: AppSpacing.sm),
                const GoldRule(width: 44),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'MŨ BẢO HIỂM CHÍNH HÃNG',
                  style: AppTextStyles.eyebrow.copyWith(color: AppColors.inkFaint),
                ),
                const SizedBox(height: AppSpacing.xxl),
                SizedBox(
                  width: 120,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) => ClipRRect(
                      borderRadius: BorderRadius.circular(1),
                      child: LinearProgressIndicator(
                        value: _controller.value,
                        minHeight: 2,
                        backgroundColor: AppColors.hairline,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(AppColors.gold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
