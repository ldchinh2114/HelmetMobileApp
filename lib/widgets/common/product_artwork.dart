import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/product.dart';

/// Deterministic, locally drawn artwork for a product.
///
/// Remote product photography is not always reachable (and mock data points at
/// placeholder services), so the catalogue renders its own house style: a
/// hand-drawn helmet silhouette on warm paper, finished with a gold hairline
/// roundel and a monogram plaque.
class ProductArtwork extends StatelessWidget {
  final Product product;
  final double? padding;
  final bool showRoundel;
  final bool showMonogram;

  const ProductArtwork({
    super.key,
    required this.product,
    this.padding,
    this.showRoundel = true,
    this.showMonogram = true,
  });

  @override
  Widget build(BuildContext context) {
    final palette = ArtPalette.forProduct(product);
    final style = HelmetStyle.forCategory(product.categoryId, product.name);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(
          constraints.maxWidth.isFinite ? constraints.maxWidth : 200,
          constraints.maxHeight.isFinite ? constraints.maxHeight : 200,
        ).toDouble();
        return CustomPaint(
          painter: _ArtworkPainter(
            palette: palette,
            style: style,
            monogram: _monogramFor(product.name),
            showRoundel: showRoundel,
            showMonogram: showMonogram,
          ),
          size: Size.square(size),
        );
      },
    );
  }

  String _monogramFor(String name) {
    final cleaned = name.replaceAll(RegExp(r'^Mũ\s*'), '').trim();
    if (cleaned.isEmpty) return 'H';
    final words = cleaned.split(RegExp(r'\s+'));
    if (words.length == 1) {
      return words.first.substring(0, math.min(2, words.first.length)).toUpperCase();
    }
    return words.take(2).map((w) => w[0]).join().toUpperCase();
  }
}

/// A bare helmet outline, used as a decorative mark on dark panels.
class HelmetMark extends StatelessWidget {
  final HelmetStyle style;
  final Color color;
  final double strokeWidth;

  const HelmetMark({
    super.key,
    this.style = HelmetStyle.fullFace,
    this.color = AppColors.gold,
    this.strokeWidth = 1.6,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(
          constraints.maxWidth.isFinite ? constraints.maxWidth : 200,
          constraints.maxHeight.isFinite ? constraints.maxHeight : 200,
        ).toDouble();
        return CustomPaint(
          painter: _HelmetOutlinePainter(
            style: style,
            color: color,
            strokeWidth: strokeWidth,
          ),
          size: Size.square(size),
        );
      },
    );
  }
}

/// The drawn helmet variants.
enum HelmetStyle {
  fullFace,
  threeQuarter,
  half,
  child,
  adventure;

  static HelmetStyle forCategory(String? categoryId, String name) {
    final haystack = '${categoryId ?? ''} ${name.toLowerCase()}';
    if (haystack.contains('fullface') || haystack.contains('c1')) return HelmetStyle.fullFace;
    if (haystack.contains('3/4') || haystack.contains('c2')) return HelmetStyle.threeQuarter;
    if (haystack.contains('1/2') || haystack.contains('c3')) return HelmetStyle.half;
    if (haystack.contains('trẻ em') || haystack.contains('c4')) return HelmetStyle.child;
    if (haystack.contains('phượt') || haystack.contains('c5')) return HelmetStyle.adventure;
    return HelmetStyle.fullFace;
  }
}

/// A muted, classic colourway for a product.
class ArtPalette {
  final Color shell;
  final Color shellLight;
  final Color visor;
  final Color backdropTop;
  final Color backdropBottom;

  const ArtPalette({
    required this.shell,
    required this.shellLight,
    required this.visor,
    required this.backdropTop,
    required this.backdropBottom,
  });

  static const List<List<Color>> _schemes = [
    [Color(0xFF3B3733), Color(0xFF6E655C), Color(0xFF8C7F72)],
    [Color(0xFF5E1826), Color(0xFF8A3143), Color(0xFFA9606F)],
    [Color(0xFF2F4437), Color(0xFF4F6B58), Color(0xFF7E9B88)],
    [Color(0xFF23324A), Color(0xFF3D5578), Color(0xFF6D87A8)],
    [Color(0xFF6B5B4C), Color(0xFF947F6B), Color(0xFFB9A794)],
    [Color(0xFF44474B), Color(0xFF6C7075), Color(0xFF9DA1A6)],
  ];

  static const List<List<Color>> _backdrops = [
    [Color(0xFFF6F1E9), Color(0xFFEDE5D8)],
    [Color(0xFFF3EAEA), Color(0xFFE9DDDE)],
    [Color(0xFFEEF2EC), Color(0xFFE1E8DF)],
    [Color(0xFFEDEFF4), Color(0xFFE0E4EC)],
    [Color(0xFFF5EFE6), Color(0xFFE9DFD0)],
    [Color(0xFFF0F0EF), Color(0xFFE3E3E2)],
  ];

  static ArtPalette forProduct(Product product) {
    final seed = product.id.codeUnits.fold<int>(7, (a, b) => (a * 31 + b) & 0x7fffffff);
    final index = seed % _schemes.length;
    final shell = _schemes[index];
    final backdrop = _backdrops[(seed ~/ 7) % _backdrops.length];
    return ArtPalette(
      shell: shell[0],
      shellLight: shell[1],
      visor: shell[2],
      backdropTop: backdrop[0],
      backdropBottom: backdrop[1],
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ArtPalette &&
      other.shell == shell &&
      other.shellLight == shellLight &&
      other.visor == visor &&
      other.backdropTop == backdropTop &&
      other.backdropBottom == backdropBottom;

  @override
  int get hashCode => Object.hash(shell, shellLight, visor, backdropTop, backdropBottom);
}

/// Shared geometry for the helmet drawings (drawn in a 100x100 space).
class _HelmetPaths {
  static Path shell(HelmetStyle style) {
    switch (style) {
      case HelmetStyle.fullFace:
        return Path()
          ..moveTo(19, 58)
          ..cubicTo(19, 22, 81, 22, 81, 58)
          ..lineTo(81, 70)
          ..cubicTo(81, 88, 69, 95, 50, 95)
          ..cubicTo(31, 95, 19, 88, 19, 70)
          ..close();
      case HelmetStyle.threeQuarter:
        return Path()
          ..moveTo(20, 56)
          ..cubicTo(20, 23, 80, 23, 80, 56)
          ..cubicTo(80, 74, 68, 88, 50, 88)
          ..cubicTo(32, 88, 20, 74, 20, 56)
          ..close();
      case HelmetStyle.half:
        return Path()
          ..moveTo(22, 62)
          ..cubicTo(22, 28, 78, 28, 78, 62)
          ..cubicTo(78, 76, 66, 84, 50, 84)
          ..cubicTo(34, 84, 22, 76, 22, 62)
          ..close();
      case HelmetStyle.child:
        return Path()
          ..moveTo(24, 60)
          ..cubicTo(24, 30, 76, 30, 76, 60)
          ..cubicTo(76, 78, 64, 88, 50, 88)
          ..cubicTo(36, 88, 24, 78, 24, 60)
          ..close();
      case HelmetStyle.adventure:
        return Path()
          ..moveTo(20, 58)
          ..cubicTo(20, 24, 78, 24, 78, 58)
          ..cubicTo(78, 76, 66, 88, 50, 88)
          ..cubicTo(34, 88, 20, 76, 20, 58)
          ..close();
    }
  }

  static Path visor(HelmetStyle style) {
    switch (style) {
      case HelmetStyle.fullFace:
        return Path()
          ..moveTo(27, 44)
          ..cubicTo(27, 34, 36, 30, 50, 30)
          ..cubicTo(64, 30, 73, 34, 73, 44)
          ..lineTo(73, 56)
          ..cubicTo(73, 62, 66, 64, 50, 64)
          ..cubicTo(34, 64, 27, 62, 27, 56)
          ..close();
      case HelmetStyle.threeQuarter:
        return Path()
          ..moveTo(28, 42)
          ..cubicTo(28, 32, 37, 28, 50, 28)
          ..cubicTo(63, 28, 72, 32, 72, 42)
          ..lineTo(72, 52)
          ..cubicTo(72, 57, 63, 58, 48, 58)
          ..cubicTo(36, 58, 28, 56, 28, 52)
          ..close();
      case HelmetStyle.half:
        return Path()
          ..moveTo(29, 48)
          ..cubicTo(29, 38, 38, 34, 50, 34)
          ..cubicTo(62, 34, 71, 38, 71, 48)
          ..cubicTo(71, 54, 62, 56, 50, 56)
          ..cubicTo(38, 56, 29, 54, 29, 48)
          ..close();
      case HelmetStyle.child:
        return Path()
          ..moveTo(31, 50)
          ..cubicTo(31, 41, 39, 38, 50, 38)
          ..cubicTo(61, 38, 69, 41, 69, 50)
          ..cubicTo(69, 56, 61, 58, 50, 58)
          ..cubicTo(39, 58, 31, 56, 31, 50)
          ..close();
      case HelmetStyle.adventure:
        return Path()
          ..moveTo(29, 46)
          ..cubicTo(29, 36, 38, 32, 50, 32)
          ..cubicTo(62, 32, 71, 36, 71, 46)
          ..cubicTo(71, 53, 62, 55, 50, 55)
          ..cubicTo(38, 55, 29, 53, 29, 46)
          ..close();
    }
  }

  /// A symmetrical sun brim above the visor.
  static Path peak() {
    return Path()
      ..moveTo(24, 40)
      ..cubicTo(33, 29, 67, 29, 76, 40)
      ..cubicTo(66, 35, 34, 35, 24, 40)
      ..close();
  }
}

class _ArtworkPainter extends CustomPainter {
  final ArtPalette palette;
  final HelmetStyle style;
  final String monogram;
  final bool showRoundel;
  final bool showMonogram;

  _ArtworkPainter({
    required this.palette,
    required this.style,
    required this.monogram,
    required this.showRoundel,
    required this.showMonogram,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final shortest = math.min(size.width, size.height);
    if (shortest <= 0) return;

    // Paper backdrop
    final rect = Offset.zero & size;
    final backdrop = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [palette.backdropTop, palette.backdropBottom],
      ).createShader(rect);
    canvas.drawRect(rect, backdrop);

    // Gold roundel
    if (showRoundel) {
      final centre = Offset(size.width / 2, size.height * 0.46);
      canvas.drawCircle(
        centre,
        shortest * 0.36,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = shortest * 0.006
          ..color = AppColors.gold.withValues(alpha: 0.45),
      );
      canvas.drawCircle(
        centre,
        shortest * 0.385,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = shortest * 0.006
          ..color = AppColors.gold.withValues(alpha: 0.22),
      );
    }

    // Helmet, drawn in a 100x100 space then scaled
    final scale = shortest / 100;
    canvas.save();
    canvas.translate(
      (size.width - 100 * scale) / 2,
      (size.height - 100 * scale) / 2 + shortest * 0.02,
    );
    canvas.scale(scale);
    _paintHelmet(canvas);
    canvas.restore();

    // Monogram plaque
    if (showMonogram) _paintMonogram(canvas, size);
  }

  void _paintHelmet(Canvas canvas) {
    final shell = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [palette.shellLight, palette.shell],
      ).createShader(const Rect.fromLTWH(0, 0, 100, 100));

    final visor = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(palette.shell, Colors.black, 0.42)!,
          Color.lerp(palette.shell, Colors.white, 0.16)!,
        ],
      ).createShader(const Rect.fromLTWH(0, 0, 100, 100));

    final visorEdge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..color = Colors.black.withValues(alpha: 0.3);

    final shellEdge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.black.withValues(alpha: 0.16);

    final seam = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = Colors.black.withValues(alpha: 0.18);

    final highlight = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.22);

    canvas.drawPath(_HelmetPaths.shell(style), shell);
    canvas.drawPath(_HelmetPaths.shell(style), shellEdge);

    if (style == HelmetStyle.adventure) {
      canvas.drawPath(_HelmetPaths.peak(), Paint()..color = palette.shellLight);
      canvas.drawPath(_HelmetPaths.peak(), shellEdge);
    }

    canvas.drawPath(_HelmetPaths.visor(style), visor);
    canvas.drawPath(_HelmetPaths.visor(style), visorEdge);

    switch (style) {
      case HelmetStyle.fullFace:
        final chin = RRect.fromRectAndRadius(
          const Rect.fromLTWH(38, 70, 24, 15),
          const Radius.circular(6),
        );
        canvas.drawRRect(chin, Paint()..color = Colors.black.withValues(alpha: 0.22));
        canvas.drawRRect(chin, seam);
        canvas.drawPath(
          Path()
            ..moveTo(33, 33)
            ..cubicTo(38, 26, 47, 24, 54, 25),
          highlight,
        );
        break;
      case HelmetStyle.threeQuarter:
        canvas.drawPath(
          Path()
            ..moveTo(72, 44)
            ..cubicTo(76, 50, 76, 58, 71, 64),
          seam,
        );
        canvas.drawPath(
          Path()
            ..moveTo(34, 32)
            ..cubicTo(39, 26, 47, 24, 53, 25),
          highlight,
        );
        break;
      case HelmetStyle.half:
        canvas.drawPath(
          Path()
            ..moveTo(34, 80)
            ..cubicTo(40, 86, 60, 86, 66, 80),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = Colors.black.withValues(alpha: 0.25),
        );
        break;
      case HelmetStyle.child:
        // Soft chin strap instead of cheek pads.
        canvas.drawPath(
          Path()
            ..moveTo(34, 82)
            ..cubicTo(40, 89, 60, 89, 66, 82),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.4
            ..color = Colors.black.withValues(alpha: 0.2),
        );
        break;
      case HelmetStyle.adventure:
        canvas.drawPath(
          Path()
            ..moveTo(33, 34)
            ..cubicTo(38, 27, 46, 25, 52, 26),
          highlight,
        );
        break;
    }
  }

  void _paintMonogram(Canvas canvas, Size size) {
    final shortest = math.min(size.width, size.height);
    final plaqueRect = Rect.fromLTWH(
      size.width - shortest * 0.235,
      size.height - shortest * 0.235,
      shortest * 0.165,
      shortest * 0.165,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(plaqueRect, Radius.circular(shortest * 0.02)),
      Paint()..color = AppColors.paper.withValues(alpha: 0.85),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(plaqueRect, Radius.circular(shortest * 0.02)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = shortest * 0.004
        ..color = AppColors.gold.withValues(alpha: 0.6),
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: monogram,
        style: TextStyle(
          fontFamily: AppFonts.display,
          fontFamilyFallback: AppFonts.displayFallback,
          fontSize: shortest * 0.072,
          fontWeight: FontWeight.w600,
          color: AppColors.ink.withValues(alpha: 0.65),
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(
        plaqueRect.center.dx - textPainter.width / 2,
        plaqueRect.center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _ArtworkPainter oldDelegate) {
    return oldDelegate.palette != palette ||
        oldDelegate.style != style ||
        oldDelegate.monogram != monogram;
  }
}

class _HelmetOutlinePainter extends CustomPainter {
  final HelmetStyle style;
  final Color color;
  final double strokeWidth;

  _HelmetOutlinePainter({
    required this.style,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final shortest = math.min(size.width, size.height);
    if (shortest <= 0) return;

    final scale = shortest / 100;
    canvas.save();
    canvas.translate(
      (size.width - 100 * scale) / 2,
      (size.height - 100 * scale) / 2,
    );
    canvas.scale(scale);

    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth / scale
      ..strokeJoin = StrokeJoin.round
      ..color = color;

    canvas.drawPath(_HelmetPaths.shell(style), line);
    canvas.drawPath(_HelmetPaths.visor(style), line);
    if (style == HelmetStyle.adventure) {
      canvas.drawPath(_HelmetPaths.peak(), line);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HelmetOutlinePainter oldDelegate) {
    return oldDelegate.style != style ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
