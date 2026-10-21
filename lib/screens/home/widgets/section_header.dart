import 'package:flutter/material.dart';
import '../../../config/app_motion.dart';
import '../../../config/app_theme.dart';
import '../../../widgets/common/classic_ui.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? eyebrow;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.eyebrow,
    this.actionLabel,
    this.onAction,
  });

  const SectionHeader.withSeeAll({
    super.key,
    required this.title,
    this.eyebrow,
    this.onAction,
  }) : actionLabel = 'Xem tất cả';

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
            if (actionLabel != null)
              _SeeAllLink(label: actionLabel!, onTap: onAction),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        const GoldRule(),
      ],
    );
  }
}

class _SeeAllLink extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;

  const _SeeAllLink({required this.label, this.onTap});

  @override
  State<_SeeAllLink> createState() => _SeeAllLinkState();
}

class _SeeAllLinkState extends State<_SeeAllLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = _hovered ? AppColors.primaryDark : AppColors.primary;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: AppTextStyles.link.copyWith(color: color),
              ),
              const SizedBox(width: AppSpacing.xs),
              AnimatedSlide(
                duration: AppMotion.quick,
                curve: AppMotion.emphasized,
                offset: _hovered ? const Offset(0.3, 0) : Offset.zero,
                child: Icon(Icons.arrow_forward, size: 13, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
