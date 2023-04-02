import 'package:flutter/material.dart';
import 'package:tuplive/core/constants/grid.dart';

/// Returns SizedBox with a width of:
///
/// const double x2Small = 2.0;
///
/// const double xSmall = 4.0;
///
/// const double small = 8.0;
///
/// const double medium = 16.0;
///
/// const double large = 24.0;
///
/// const double xLarge = 32.0;
///
/// const double x2Large = 40.0;
///
/// const double x3Large = 48.0;
///
/// const double x4Large = 56.0;
///
/// const double x5Large = 64.0;
///
/// const double x6Large = 72.0;
///
/// const double x7Large = 80.0;
///
/// const double x8Large = 200.0;
abstract class HorizontalSpacers {
  static const x2Small = SizedBox(width: AppGrid.x2Small);
  static const xSmall = SizedBox(width: AppGrid.xSmall);
  static const small = SizedBox(width: AppGrid.small);
  static const medium = SizedBox(width: AppGrid.medium);
  static const large = SizedBox(width: AppGrid.large);
  static const xLarge = SizedBox(width: AppGrid.xLarge);
  static const x2Large = SizedBox(width: AppGrid.x2Large);
  static const x3Large = SizedBox(width: AppGrid.x3Large);
  static const x4Large = SizedBox(width: AppGrid.x4Large);
  static const x5Large = SizedBox(width: AppGrid.x5Large);
  static const x6Large = SizedBox(width: AppGrid.x6Large);
  static const x7Large = SizedBox(width: AppGrid.x7Large);
  static const x8Large = SizedBox(width: AppGrid.x8Large);

  /// returns a sizedbox with predefined width [value]
  static fromSize(double value) => SizedBox(width: value);
}

/// Returns SizedBox with a height of:
///
/// const double x2Small = 2.0;
///
/// const double xSmall = 4.0;
///
/// const double small = 8.0;
///
/// const double medium = 16.0;
///
/// const double large = 24.0;
///
/// const double xLarge = 32.0;
///
/// const double x2Large = 40.0;
///
/// const double x3Large = 48.0;
///
/// const double x4Large = 56.0;
///
/// const double x5Large = 64.0;
///
/// const double x6Large = 72.0;
///
/// const double x7Large = 80.0;
///
/// const double x8Large = 200.0;
abstract class VerticalSpacers {
  static const x2Small = SizedBox(height: AppGrid.x2Small);
  static const xSmall = SizedBox(height: AppGrid.xSmall);
  static const small = SizedBox(height: AppGrid.small);
  static const medium = SizedBox(height: AppGrid.medium);
  static const large = SizedBox(height: AppGrid.large);
  static const xLarge = SizedBox(height: AppGrid.xLarge);
  static const x2Large = SizedBox(height: AppGrid.x2Large);
  static const x3Large = SizedBox(height: AppGrid.x3Large);
  static const x4Large = SizedBox(height: AppGrid.x4Large);
  static const x5Large = SizedBox(height: AppGrid.x5Large);
  static const x6Large = SizedBox(height: AppGrid.x6Large);
  static const x7Large = SizedBox(height: AppGrid.x7Large);
  static const x8Large = SizedBox(height: AppGrid.x8Large);

  /// returns a sizedbox with predefined height
  static SizedBox fromSize(double value) => SizedBox(height: value);
}
