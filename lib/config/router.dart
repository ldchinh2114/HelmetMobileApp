import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/app_motion.dart';
import '../config/app_theme.dart';
import '../providers/cart_provider.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/category/category_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/product/product_detail_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/wishlist/wishlist_screen.dart';
import '../widgets/common/classic_ui.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

/// A calm, classic page transition: the new page rises and settles.
CustomTransitionPage<T> _fadeRisePage<T>({
  required GoRouterState state,
  required Widget child,
  Offset begin = const Offset(0, 0.035),
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: AppMotion.page,
    reverseTransitionDuration: AppMotion.quick,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: AppMotion.emphasized,
        reverseCurve: AppMotion.exit,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(begin: begin, end: Offset.zero).animate(curved),
          child: child,
        ),
      );
    },
  );
}

GoRouter buildRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      // Splash
      GoRoute(
        path: '/splash',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _fadeRisePage<void>(
          state: state,
          child: const SplashScreen(),
        ),
      ),

      // Auth routes (no bottom nav)
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _fadeRisePage<void>(
          state: state,
          child: const _ComingSoonScreen(
            title: 'Đăng nhập',
            subtitle: 'Tính năng đang được phát triển',
          ),
        ),
      ),
      GoRoute(
        path: '/register',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _fadeRisePage<void>(
          state: state,
          child: const _ComingSoonScreen(
            title: 'Tạo tài khoản',
            subtitle: 'Tính năng đang được phát triển',
          ),
        ),
      ),

      // Main app shell WITH bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/cart',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CartScreen(),
            ),
          ),
          GoRoute(
            path: '/category',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CategoryScreen(),
            ),
          ),
          GoRoute(
            path: '/wishlist',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: WishlistScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),

      // Push routes (no bottom nav)
      GoRoute(
        path: '/search',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _fadeRisePage<void>(
          state: state,
          child: const SearchScreen(),
        ),
      ),
      GoRoute(
        path: '/product/:id',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return _fadeRisePage<void>(
            state: state,
            child: ProductDetailScreen(productId: id),
          );
        },
      ),
      GoRoute(
        path: '/checkout',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _fadeRisePage<void>(
          state: state,
          child: const _ComingSoonScreen(
            title: 'Thanh toán',
            subtitle: 'Tính năng đang được phát triển',
          ),
        ),
      ),
      GoRoute(
        path: '/order-confirmation',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _fadeRisePage<void>(
          state: state,
          child: const _ComingSoonScreen(
            title: 'Xác nhận đơn hàng',
            subtitle: 'Tính năng đang được phát triển',
          ),
        ),
      ),
    ],
  );
}

final appRouter = buildRouter();

/// Maps route paths to bottom navigation indexes.
int tabIndexForLocation(String location) {
  if (location.startsWith('/home')) return 0;
  if (location.startsWith('/category')) return 1;
  if (location.startsWith('/cart')) return 2;
  if (location.startsWith('/wishlist')) return 3;
  if (location.startsWith('/profile')) return 4;
  return 0;
}

void goToTab(BuildContext context, int index) {
  switch (index) {
    case 0:
      context.go('/home');
      break;
    case 1:
      context.go('/category');
      break;
    case 2:
      context.go('/cart');
      break;
    case 3:
      context.go('/wishlist');
      break;
    case 4:
      context.go('/profile');
      break;
  }
}

/// Shell that wraps all tab screens with the bottom navigation bar.
/// Each child screen should NOT have its own Scaffold — the shell provides it.
class AppShell extends ConsumerStatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = tabIndexForLocation(location);
    final cartCount = ref.watch(cartCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: widget.child,
      bottomNavigationBar: ClassicBottomNav(
        currentIndex: currentIndex,
        cartCount: cartCount,
      ),
    );
  }
}

/// Bottom navigation drawn in the classic style: hairline rule on top,
/// serif-friendly small labels and a gold marker on the active tab.
class ClassicBottomNav extends StatelessWidget {
  final int currentIndex;
  final int cartCount;

  const ClassicBottomNav({
    super.key,
    required this.currentIndex,
    this.cartCount = 0,
  });

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Trang chủ'),
    _NavItem(icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view, label: 'Danh mục'),
    _NavItem(icon: Icons.shopping_basket_outlined, activeIcon: Icons.shopping_basket, label: 'Giỏ hàng'),
    _NavItem(icon: Icons.favorite_outline, activeIcon: Icons.favorite, label: 'Yêu thích'),
    _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Tài khoản'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.paper,
        border: Border(top: AppBorders.hairline),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = index == currentIndex;
              return Expanded(
                child: _NavTab(
                  item: item,
                  isSelected: isSelected,
                  badgeCount: item.label == 'Giỏ hàng' ? cartCount : 0,
                  onTap: () => goToTab(context, index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _NavTab extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final int badgeCount;
  final VoidCallback onTap;

  const _NavTab({
    required this.item,
    required this.isSelected,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.inkFaint;
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.primary.withValues(alpha: 0.06),
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 26,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedSwitcher(
                  duration: AppMotion.quick,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.85, end: 1).animate(animation),
                      child: child,
                    ),
                  ),
                  child: Icon(
                    isSelected ? item.activeIcon : item.icon,
                    key: ValueKey(isSelected),
                    size: 21,
                    color: color,
                  ),
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -9,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          badgeCount > 99 ? '99+' : '$badgeCount',
                          style: AppTextStyles.badgeCount,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            item.label,
            style: AppTextStyles.navLabel.copyWith(
              color: color,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          const SizedBox(height: 5),
          // Gold marker under the active tab
          AnimatedContainer(
            duration: AppMotion.quick,
            curve: AppMotion.emphasized,
            height: 2,
            width: isSelected ? 18 : 0,
            color: AppColors.gold,
          ),
        ],
      ),
    );
  }
}

/// Shared placeholder for screens that are not built yet.
class _ComingSoonScreen extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ComingSoonScreen({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title, style: AppTextStyles.sectionTitle.copyWith(fontSize: 17)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                color: AppColors.canvas,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.hourglass_empty, size: 30, color: AppColors.inkFaint),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: AppTextStyles.sectionTitle.copyWith(fontSize: 18)),
            const SizedBox(height: AppSpacing.sm),
            Text(subtitle, style: AppTextStyles.bodyMuted),
            const SizedBox(height: AppSpacing.xl),
            const GoldRule(width: 36),
          ],
        ),
      ),
    );
  }
}
