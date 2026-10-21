import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/app_config.dart';
import 'config/app_theme.dart';
import 'config/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('HELMO build ${AppConfig.designRevision}');
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.paper,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const ProviderScope(child: HelmoApp()));
}

class HelmoApp extends StatelessWidget {
  const HelmoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'HELMO - Mũ Bảo Hiểm Chính Hãng',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: appRouter,
      builder: (context, child) {
        // Classic typography renders crisply with subpixel off and no glow.
        return MediaQuery.withClampedTextScaling(
          minScaleFactor: 0.9,
          maxScaleFactor: 1.2,
          child: ScrollConfiguration(
            behavior: const _ClassicScrollBehavior(),
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}

class _ClassicScrollBehavior extends MaterialScrollBehavior {
  const _ClassicScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
