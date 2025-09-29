import 'package:flutter/material.dart';

/// Figma-based, orientation-aware scaler for Flutter UIs.
///
/// - Maps shortestSide → figmaW and longestSide → figmaH (rotation-stable)
/// - Base scale = min(widthRatio, heightRatio) to avoid over-expansion
/// - Fonts: portrait = gentle mean; landscape = base scale (when [tightFontsInLandscape])
class DesignScale {
  /// Create a scaler bound to [context]. Defaults to a 440×956 Figma frame.
  DesignScale.of(
    this.context, {
    this.figmaW = 440,
    this.figmaH = 956,
    this.minScale = 0.90,
    this.maxScale = 1.15,
    this.tightFontsInLandscape = true,
  }) : mq = MediaQuery.of(context);

  /// Build context the scaler reads from (via [MediaQuery]).
  final BuildContext context;

  /// Snapshot of media metrics.
  final MediaQueryData mq;

  /// Figma base frame width/height you designed against.
  final double figmaW, figmaH;

  /// Global clamps for scales across devices.
  final double minScale, maxScale;

  /// If true, fonts follow [scale] exactly in landscape.
  final bool tightFontsInLandscape;

  Size get _size => mq.size;
  double get _short => _size.shortestSide;
  double get _long => _size.longestSide;

  /// Width ratio against the shortest side.
  double get _rw => _short / figmaW;

  /// Height ratio against the longest side.
  double get _rh => _long / figmaH;

  bool get _isLandscape => _size.width > _size.height;

  double _clamp(double v, {double? lo, double? hi}) =>
      v.clamp(lo ?? minScale, hi ?? maxScale);

  /// Base scale used for spacings/radii/icons/etc.
  double get scale => _clamp(_rw < _rh ? _rw : _rh);

  /// Font scale:
  /// - Portrait: mean of ratios clamped to [0.95, 1.10].
  /// - Landscape (when [tightFontsInLandscape] = true): equals [scale].
  double get fontScale {
    final portraitMean = _clamp((_rw + _rh) * 0.5, lo: 0.95, hi: 1.10);
    return (tightFontsInLandscape && _isLandscape) ? scale : portraitMean;
  }

  /// Scale width/padding/radius or neutral lengths.
  double sx(double v) => v * scale;

  /// Scale heights (semantic alias of [sx]).
  double sy(double v) => v * scale;

  /// Scale fonts.
  double sp(double v) => v * fontScale;
}
