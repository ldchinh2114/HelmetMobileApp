// Basic smoke tests for the HELMO shell.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sellingproduct/main.dart';
import 'package:sellingproduct/config/app_theme.dart';
import 'package:sellingproduct/utils/formatters.dart';

void main() {
  testWidgets('app boots into the router', (WidgetTester tester) async {
    await tester.pumpWidget(const HelmoApp());
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(MaterialApp), findsOneWidget);

    // Tear the tree down so the splash timer is cancelled.
    await tester.pumpWidget(const SizedBox.shrink());
  });

  test('currency is formatted the Vietnamese way', () {
    expect(formatCurrency(1890000), '1.890.000₫');
    expect(formatCurrency(550000), '550.000₫');
  });

  test('theme exposes the classic light palette', () {
    final theme = buildAppTheme();
    expect(theme.brightness, Brightness.light);
    expect(theme.colorScheme.primary, AppColors.primary);
  });
}
