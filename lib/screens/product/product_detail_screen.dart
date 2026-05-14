import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_theme.dart';
import '../../models/product.dart';
import '../../providers/home_provider.dart';
import '../../providers/cart_provider.dart';

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
  bool _isFavorite = false;

  final List<String> _sizes = ['S', 'M', 'L', 'XL'];
  final List<_ColorOption> _colors = [
    _ColorOption(name: 'Đen', color: const Color(0xFF212121)),
    _ColorOption(name: 'Trắng', color: const Color(0xFFF5F5F5)),
    _ColorOption(name: 'Xanh', color: const Color(0xFF1565C0)),
    _ColorOption(name: 'Đỏ', color: const Color(0xFFC62828)),
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

  Widget _buildLoading() {
    return SafeArea(
      child: Column(
        children: [
          _buildAppBar(null),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  // Image shimmer
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Text shimmers
                  ...List.generate(5, (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return SafeArea(
      child: Column(
        children: [
          _buildAppBar(null),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.gray),
                  const SizedBox(height: AppSpacing.lg),
                  Text(message, style: AppTextStyles.productName),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(productDetailProvider(widget.productId)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(Product? product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.black, size: 22),
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (product != null)
            IconButton(
              icon: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? AppColors.primary : AppColors.gray,
                  size: 22,
                ),
              ),
              onPressed: () => setState(() => _isFavorite = !_isFavorite),
            ),
          IconButton(
            icon: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.share_outlined, color: AppColors.black, size: 22),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDetail(Product product) {
    return Column(
      children: [
        // AppBar floating
        _buildAppBar(product),

        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Hero(
                    tag: 'product_${product.id}',
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(Icons.shield, size: 100, color: Colors.grey[300]),
                          ),
                          // Discount badge
                          if (product.discountPercent != null)
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(AppRadius.sm),
                                ),
                                child: Text(
                                  '-${product.discountPercent!.round()}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Product info section
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
                  ),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name + rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: AppTextStyles.sectionTitle.copyWith(fontSize: 20),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.starYellow.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, size: 16, color: AppColors.starYellow),
                                const SizedBox(width: 4),
                                Text(
                                  product.rating.toString(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.starYellow,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Price
                      Row(
                        children: [
                          Text(
                            formatCurrency(product.price),
                            style: AppTextStyles.price.copyWith(fontSize: 24),
                          ),
                          if (product.originalPrice != null) ...[
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              formatCurrency(product.originalPrice!),
                              style: AppTextStyles.originalPrice.copyWith(fontSize: 16),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Đã bán ${product.soldCount} sản phẩm',
                        style: AppTextStyles.soldCount.copyWith(fontSize: 13),
                      ),

                      const Divider(height: AppSpacing.xl),

                      // Size selector
                      Text('Kích cỡ', style: AppTextStyles.productName.copyWith(fontSize: 14)),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: _sizes.map((size) {
                          final isSelected = _selectedSize == size;
                          return Padding(
                            padding: const EdgeInsets.only(right: AppSpacing.sm),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedSize = size),
                              child: Container(
                                width: 52,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary : Colors.transparent,
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                  border: Border.all(
                                    color: isSelected ? AppColors.primary : AppColors.lightGray,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    size,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected ? AppColors.white : AppColors.darkGray,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Color selector
                      Text('Màu sắc', style: AppTextStyles.productName.copyWith(fontSize: 14)),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: _colors.map((opt) {
                          final isSelected = _selectedColor == opt.name;
                          return Padding(
                            padding: const EdgeInsets.only(right: AppSpacing.md),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedColor = opt.name),
                              child: Column(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: opt.color,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: opt.color == const Color(0xFFF5F5F5)
                                            ? AppColors.lightGray
                                            : opt.color,
                                        width: 2,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: AppColors.primary.withValues(alpha: 0.3),
                                                blurRadius: 6,
                                                spreadRadius: 1,
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: isSelected
                                        ? const Icon(Icons.check, size: 18, color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    opt.name,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isSelected ? AppColors.primary : AppColors.gray,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Quantity selector
                      Text('Số lượng', style: AppTextStyles.productName.copyWith(fontSize: 14)),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.lightGray),
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            child: Row(
                              children: [
                                _QuantityButton(
                                  icon: Icons.remove,
                                  onTap: () {
                                    if (_quantity > 1) {
                                      setState(() => _quantity--);
                                    }
                                  },
                                ),
                                Container(
                                  width: 48,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    '$_quantity',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                                _QuantityButton(
                                  icon: Icons.add,
                                  onTap: () {
                                    if (_quantity < 99) {
                                      setState(() => _quantity++);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Text(
                            'Còn ${product.soldCount} sản phẩm',
                            style: AppTextStyles.soldCount.copyWith(fontSize: 12),
                          ),
                        ],
                      ),

                      const Divider(height: AppSpacing.xl),

                      // Description
                      Text('Mô tả sản phẩm', style: AppTextStyles.productName.copyWith(fontSize: 14)),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Mũ bảo hiểm chính hãng HELMO với thiết kế hiện đại, chất liệu cao cấp. '
                        'Đạt tiêu chuẩn an toàn quốc tế ECE 22.05. Lớp lót êm ái, thoáng khí, '
                        'có thể tháo rời để vệ sinh. Phù hợp cho mọi đối tượng từ đi phố đến thể thao.',
                        style: AppTextStyles.soldCount.copyWith(
                          fontSize: 13,
                          color: AppColors.darkGray,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom action bar
        _buildBottomActions(product),
      ],
    );
  }

  Widget _buildBottomActions(Product product) {
    final totalPrice = product.price * _quantity;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.sm,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Add to cart button
            Expanded(
              flex: 2,
              child: OutlinedButton.icon(
                onPressed: () {
                  ref.read(cartProvider.notifier).addItem(
                    product,
                    size: _selectedSize,
                    color: _selectedColor,
                    quantity: _quantity,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã thêm "$_quantity ${product.name}" vào giỏ hàng'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                label: const Text('Giỏ hàng', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            // Buy now button
            Expanded(
              flex: 3,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push('/checkout');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.flash_on, size: 20),
                label: Text(
                  'Mua ngay - ${formatCurrency(totalPrice)}',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(),
        child: Icon(icon, size: 20, color: AppColors.darkGray),
      ),
    );
  }
}

class _ColorOption {
  final String name;
  final Color color;

  const _ColorOption({required this.name, required this.color});
}