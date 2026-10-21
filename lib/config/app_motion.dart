import 'package:flutter/material.dart';

/// Motion tokens. Everything eases into place; nothing snaps.
class AppMotion {
  static const Duration instant = Duration(milliseconds: 120);
  static const Duration quick = Duration(milliseconds: 220);
  static const Duration standard = Duration(milliseconds: 320);
  static const Duration slow = Duration(milliseconds: 520);
  static const Duration page = Duration(milliseconds: 380);

  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve emphasized = Cubic(0.2, 0.0, 0.0, 1.0);
  static const Curve smooth = Curves.easeInOutCubic;

  /// Stagger between successive items in a list or grid.
  static const Duration stagger = Duration(milliseconds: 70);
}
