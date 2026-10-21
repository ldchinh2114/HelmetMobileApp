import 'dart:async';

import 'package:flutter/material.dart';
import '../../config/app_motion.dart';
import '../../config/app_theme.dart';

/// A 1px rule. Classic layouts separate with lines, not shadows.
class Hairline extends StatelessWidget {
  final double indent;
  final Color color;
  final double thickness;

  const Hairline({
    super.key,
    this.indent = 0,
    this.color = AppColors.hairline,
    this.thickness = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: Container(height: thickness, color: color),
    );
  }
}

/// A short gold rule used as a ceremonial flourish under headings.
class GoldRule extends StatelessWidget {
  final double width;
  final double thickness;

  const GoldRule({super.key, this.width = 28, this.thickness = 2});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: thickness,
      color: AppColors.gold,
    );
  }
}

/// Small uppercase kicker.
class Eyebrow extends StatelessWidget {
  final String text;
  final Color color;

  const Eyebrow(this.text, {super.key, this.color = AppColors.gold});

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: AppTextStyles.eyebrow.copyWith(color: color));
  }
}

/// Section heading with an optional gold rule beneath.
class ClassicSectionTitle extends StatelessWidget {
  final String title;
  final String? eyebrow;
  final Widget? trailing;

  const ClassicSectionTitle({
    super.key,
    required this.title,
    this.eyebrow,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (eyebrow != null) ...[
          Eyebrow(eyebrow!),
          const SizedBox(height: AppSpacing.xs + 2),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: Text(title, style: AppTextStyles.sectionTitle)),
            ?trailing,
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        const GoldRule(),
      ],
    );
  }
}

/// Consistent empty / error state.
class ClassicEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const ClassicEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
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
              child: Icon(icon, size: 32, color: AppColors.inkFaint),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                message!,
                style: AppTextStyles.bodyMuted,
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel case final label?) ...[
              const SizedBox(height: AppSpacing.xl),
              OutlinedButton(
                onPressed: onAction,
                child: Text(label.toUpperCase()),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Fade-and-rise entrance used to stagger sections on first paint.
///
/// The animation is driven by a timer rather than a ticker so that content
/// still settles into place when the app is not in the foreground (background
/// tabs, headless previews) — a ticker would freeze at opacity 0.
class Reveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final double offset;

  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = 18,
  });

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> {
  static const Duration _tick = Duration(milliseconds: 16);

  Duration _elapsed = Duration.zero;
  double _progress = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _start();
    } else {
      _timer = Timer(widget.delay, _start);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _timer = Timer.periodic(_tick, (_) {
      _elapsed += _tick;
      final raw =
          (_elapsed.inMilliseconds / AppMotion.slow.inMilliseconds).clamp(0.0, 1.0);
      final eased = AppMotion.enter.transform(raw);
      if (mounted) {
        setState(() => _progress = eased);
      }
      if (raw >= 1.0) {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _progress,
      child: Transform.translate(
        offset: Offset(0, widget.offset * (1 - _progress)),
        child: widget.child,
      ),
    );
  }
}

/// Fades and cross-dissolves between two states of the same slot.
class CrossFade extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const CrossFade({
    super.key,
    required this.child,
    this.duration = AppMotion.quick,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: AppMotion.enter,
      switchOutCurve: AppMotion.exit,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.35),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

/// Standard snack bar with the classic ink treatment.
void showClassicSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            size: 18,
            color: isError ? AppColors.gold : AppColors.gold,
          ),
          const SizedBox(width: AppSpacing.sm + 2),
          Expanded(child: Text(message)),
        ],
      ),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(AppSpacing.lg),
      action: actionLabel != null && onAction != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: AppColors.gold,
              onPressed: onAction,
            )
          : null,
    ),
  );
}

/// A square, gold-outlined chip used for filters and quick choices.
class ClassicChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ClassicChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.quick,
        curve: AppMotion.emphasized,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.ink : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.ink : AppColors.hairlineStrong,
          ),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          label,
          style: AppTextStyles.label.copyWith(
            fontSize: 12.5,
            color: isSelected ? Colors.white : AppColors.inkSoft,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
