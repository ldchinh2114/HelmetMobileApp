import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_motion.dart';
import '../../config/app_theme.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../utils/formatters.dart';
import '../../widgets/common/classic_ui.dart';
import '../../widgets/common/product_artwork.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  String _selectedSize = 'M';
  String _selectedColor = 'Đen';
  int _quantity = 1;

  final List<String> _sizes = ['S', 'M', 'L', 'XL'];
  final List<_ColorOption> _colors = [
    _ColorOption(name: 'Đen', color: Color(0xFF2B2723)),
    _ColorOption(name: 'Trắng', color: Color(0xFFF5F2EC)),
    _ColorOption(name: 'Xanh', color: Color(0xFF23324A)),
    _ColorOption(name: 'Đỏ', color: Color(0xFF7C2233)),
  ];

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.productId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: productAsync.when(
        data: (product) {
          if (product == null) {
            return _buildError('Không tìm thấy sản phẩm');
          }
          return _buildDetail(product);
        },
        loading: () => _buildLoading(),
        error: (e, _) => _buildError('Lỗi tải dữ liệu: $e'),
      ),
    );
  }

  // ---------------------------------------------------------------- chrome

  Widget _buildTopBar({bool showActions = true}) {
    final wishlist = ref.watch(wishlistProvider);
    final isFavorite = wishlist.contains(widget.productId);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: AppBorders.hairline),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          _CircleAction(
            icon: Icons.arrow_back,
            tooltip: 'Quay lại',
            onTap: () => context.pop(),
          ),
          const Spacer(),
          if (showActions) ...[
            _CircleAction(
              icon: isFavorite ? Icons.favorite : Icons.favorite_border,
              tooltip: 'Yêu thích',
              color: isFavorite ? AppColors.primary : AppColors.ink,
              onTap: () =>
                  ref.read(wishlistProvider.notifier).toggle(widget.productId),
            ),
            const SizedBox(width: AppSpacing.sm),
            _CircleAction(
              icon: Icons.ios_share_outlined,
              tooltip: 'Chia sẻ',
              onTap: () => showClassicSnackBar(context, 'Đã sao chép liên kết sản phẩm'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Column(
      children: [
        _buildTopBar(showActions: false),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: AppColors.canvas,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.hairline),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                ...List.generate(
                  5,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Container(
                      height: 14,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: AppColors.canvas,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError(String message) {
    return Column(
      children: [
        _buildTopBar(showActions: false),
        Expanded(
          child: ClassicEmptyState(
            icon: Icons.search_off,
            title: message,
            message: 'Sản phẩm có thể đã được gỡ khỏi danh mục.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(productDetailProvider(widget.productId)),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------- detail

  Widget _buildDetail(Product product) {
    return Column(
      children: [
        _buildTopBar(),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Artwork
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Hero(
                      tag: 'product_${product.id}',
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.hairline),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ProductArtwork(
                                product: product,
                                showMonogram: false,
                              ),
                            ),
                            if (product.discountPercent != null)
                              Positioned(
                                top: AppSpacing.lg,
                                left: AppSpacing.lg,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.paper,
                                    border: Border.all(color: AppColors.primary),
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.sm),
                                  ),
                                  child: Text(
                                    'GIẢM ${product.discountPercent!.round()}%',
                                    style: AppTextStyles.buttonSmall.copyWith(
                                      color: AppColors.primary,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Title & price
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: AppTextStyles.displayMedium.copyWith(
                                fontSize: 21,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          _RatingChip(rating: product.rating),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            formatCurrency(product.price),
                            style: AppTextStyles.priceLarge,
                          ),
                          if (product.originalPrice != null) ...[
                            const SizedBox(width: AppSpacing.md),
                            Text(
                              formatCurrency(product.originalPrice!),
                              style: AppTextStyles.originalPrice
                                  .copyWith(fontSize: 14),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '${formatSoldCount(product.soldCount)} · Chính hãng · Bảo hành 12 tháng',
                        style: AppTextStyles.meta,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      const Hairline(),
                      const SizedBox(height: AppSpacing.xl),

                      // Size
                      const _FieldLabel('Kích cỡ'),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: _sizes.map((size) {
                          final isSelected = _selectedSize == size;
                          return Padding(
                            padding: const EdgeInsets.only(right: AppSpacing.sm),
                            child: _SizeOption(
                              label: size,
                              isSelected: isSelected,
                              onTap: () =>
                                  setState(() => _selectedSize = size),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Colour
                      const _FieldLabel('Màu sắc'),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: _colors.map((option) {
                          final isSelected = _selectedColor == option.name;
                          return Padding(
                            padding: const EdgeInsets.only(right: AppSpacing.lg),
                            child: _ColorOptionButton(
                              option: option,
                              isSelected: isSelected,
                              onTap: () =>
                                  setState(() => _selectedColor = option.name),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Quantity
                      const _FieldLabel('Số lượng'),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          _QuantityStepper(
                            quantity: _quantity,
                            onDecrement: () {
                              if (_quantity > 1) {
                                setState(() => _quantity--);
                              }
                            },
                            onIncrement: () {
                              if (_quantity < 99) {
                                setState(() => _quantity++);
                              }
                            },
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Text(
                            'Còn ${product.soldCount} sản phẩm',
                            style: AppTextStyles.meta,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      const Hairline(),
                      const SizedBox(height: AppSpacing.xl),

                      // Description
                      const _FieldLabel('Mô tả sản phẩm'),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Mũ bảo hiểm chính hãng HELMO với thiết kế hiện đại, chất liệu cao cấp. '
                        'Đạt tiêu chuẩn an toàn quốc tế ECE 22.05. Lớp lót êm ái, thoáng khí, '
                        'có thể tháo rời để vệ sinh. Phù hợp cho mọi đối tượng từ đi phố đến thể thao.',
                        style: AppTextStyles.body.copyWith(
                          fontSize: 13.5,
                          color: AppColors.inkSoft,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      const Hairline(),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        _buildBottomActions(product),
      ],
    );
  }

  Widget _buildBottomActions(Product product) {
    final totalPrice = product.price * _quantity;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.paper,
        border: Border(top: AppBorders.hairline),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                ref.read(cartProvider.notifier).addItem(
                      product,
                      size: _selectedSize,
                      color: _selectedColor,
                      quantity: _quantity,
                    );
                showClassicSnackBar(
                  context,
                  'Đã thêm $_quantity × ${product.name} vào giỏ hàng',
                  actionLabel: 'XEM',
                  onAction: () => context.go('/cart'),
                );
              },
              child: const Text(
                'THÊM GIỎ',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 2,
            child: FilledButton(
              onPressed: () => context.push('/checkout'),
              child: Text(
                'MUA NGAY · ${formatCurrency(totalPrice)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text, style: AppTextStyles.label.copyWith(fontSize: 14)),
        const SizedBox(width: AppSpacing.sm),
        const GoldRule(width: 18),
      ],
    );
  }
}

class _RatingChip extends StatelessWidget {
  final double rating;

  const _RatingChip({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gold),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 13, color: AppColors.star),
          const SizedBox(width: AppSpacing.xs),
          Text(
            rating.toStringAsFixed(1),
            style: AppTextStyles.priceSmall.copyWith(
              color: AppColors.gold,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color? color;
  final VoidCallback onTap;

  const _CircleAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.paper,
      shape: const CircleBorder(side: AppBorders.hairline),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Icon(icon, size: 18, color: color ?? AppColors.ink),
          ),
        ),
      ),
    );
  }
}

class _SizeOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SizeOption({
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
        width: 50,
        height: 42,
        alignment: Alignment.center,
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
            color: isSelected ? Colors.white : AppColors.ink,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _ColorOptionButton extends StatelessWidget {
  final _ColorOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorOptionButton({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: AppMotion.quick,
            curve: AppMotion.emphasized,
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: option.color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.gold : AppColors.hairlineStrong,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    size: 15,
                    color: option.isLight ? AppColors.ink : Colors.white,
                  )
                : null,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            option.name,
            style: AppTextStyles.meta.copyWith(
              fontSize: 11,
              color: isSelected ? AppColors.ink : AppColors.inkFaint,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantityStepper({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.hairlineStrong),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(icon: Icons.remove, onTap: onDecrement),
          SizedBox(
            width: 44,
            child: Center(
              child: Text(
                '$quantity',
                style: AppTextStyles.priceSmall.copyWith(
                  color: AppColors.ink,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          _StepButton(icon: Icons.add, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(icon, size: 16, color: AppColors.inkSoft),
      ),
    );
  }
}

class _ColorOption {
  final String name;
  final Color color;

  const _ColorOption({required this.name, required this.color});

  bool get isLight => color.computeLuminance() > 0.6;
}
