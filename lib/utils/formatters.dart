// Formatting helpers shared across the app.

/// Formats a VND amount the Vietnamese way: `1.890.000₫`.
String formatCurrency(double amount) {
  final rounded = amount.round().abs();
  final digits = rounded.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  final sign = amount < 0 ? '-' : '';
  return '$sign$buffer₫';
}

/// Formats a compact price for dense layouts: `1,89 tr` / `550K`.
String formatCompactPrice(double amount) {
  if (amount >= 1000000) {
    final millions = amount / 1000000;
    final text = millions == millions.roundToDouble()
        ? millions.toStringAsFixed(0)
        : millions.toStringAsFixed(2);
    return '$text tr';
  }
  if (amount >= 1000) return '${(amount / 1000).round()}K';
  return '${amount.round()}';
}

/// `256` -> `256 sản phẩm`, `1200` -> `1,2k sản phẩm`.
String formatSoldCount(int count) {
  if (count >= 1000) {
    final thousands = count / 1000;
    final text = thousands == thousands.roundToDouble()
        ? thousands.toStringAsFixed(0)
        : thousands.toStringAsFixed(1).replaceAll('.', ',');
    return '$text nghìn lượt mua';
  }
  return '$count lượt mua';
}
