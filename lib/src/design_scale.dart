import 'package:flutter/material.dart';

/// Orientation-aware, frame-based scaler for Flutter UIs.
///
/// Maps the device's `shortestSide → design width` and
/// `longestSide → design height`, then uses `min(rw, rh)` as the
/// base scale to avoid blow-ups on squat screens. Fonts use a
/// tighter strategy to prevent huge text in landscape.
class DesignScale {
  DesignScale.of(
    this.context, {
    this.figmaW = 440,
    this.figmaH = 956,
    this.minScale = 0.90,
    this.maxScale = 1.15,
    this.tightFontsInLandscape = true,
  }) : size = MediaQuery.of(context).size;

  final BuildContext context;
  final Size size;

  /// Design frame (width × height) your layout was authored against.
  final double figmaW, figmaH;

  /// Global clamps for both base and font scales.
  final double minScale, maxScale;

  /// If true (default), fonts follow the base scale in landscape to
  /// avoid oversized typography. If false, fonts use a gentle mean.
  final bool tightFontsInLandscape;

  /// Ratios using the “frame mapping” (shortest→W, longest→H).
  double get _rw => (size.shortestSide / figmaW);
  double get _rh => (size.longestSide / figmaH);

  /// Base scale — conservative: never larger than the smaller ratio.
  double get scale => _clamp(_rw < _rh ? _rw : _rh);

  /// Font scale:
  ///  - portrait: gentle mean to reduce extremes;
  ///  - landscape: optionally follow base scale strictly.
  double get fontScale {
    final isLandscape = size.width > size.height;
    if (isLandscape && tightFontsInLandscape) return scale;
    final mean = (_rw + _rh) / 2;
    return _clamp(mean, lo: 0.95, hi: 1.10);
  }

  // Helpers
  double sx(double v) => v * scale; // spacing / radii / widths
  double sy(double v) => v * scale; // heights (semantic alias)
  double sp(double v) => v * fontScale; // font sizes

  double _clamp(double v, {double? lo, double? hi}) =>
      v.clamp(lo ?? minScale, hi ?? maxScale);
}
