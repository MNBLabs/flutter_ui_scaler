import 'package:flutter/material.dart';
import 'design_scale.dart';

/// App-wide provider for [DesignScale]. Wrap your app once.
///
/// Example:
/// ```dart
/// UiScaleScope(
///   figmaW: 440, figmaH: 956,
///   child: MaterialApp(...),
/// )
/// ```
class UiScaleScope extends InheritedWidget {
  /// Creates a scope providing a [DesignScale] configuration.
  const UiScaleScope({
    super.key,
    required this.figmaW,
    required this.figmaH,
    this.minScale = 0.90,
    this.maxScale = 1.15,
    this.tightFontsInLandscape = true,
    required super.child,
  });

  /// Design frame width/height used by your layouts.
  final double figmaW, figmaH;

  /// Global clamps for scale.
  final double minScale, maxScale;

  /// If true, fonts use base scale in landscape.
  final bool tightFontsInLandscape;

  @override
  bool updateShouldNotify(covariant UiScaleScope oldWidget) =>
      figmaW != oldWidget.figmaW ||
      figmaH != oldWidget.figmaH ||
      minScale != oldWidget.minScale ||
      maxScale != oldWidget.maxScale ||
      tightFontsInLandscape != oldWidget.tightFontsInLandscape;

  /// Resolve a [DesignScale] bound to the current [BuildContext].
  static DesignScale of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<UiScaleScope>();
    if (scope == null) {
      // Fallback to defaults if not wrapped.
      return DesignScale.of(context);
    }
    return DesignScale.of(
      context,
      figmaW: scope.figmaW,
      figmaH: scope.figmaH,
      minScale: scope.minScale,
      maxScale: scope.maxScale,
      tightFontsInLandscape: scope.tightFontsInLandscape,
    );
  }
}

/// Sugar: `context.ds` → [DesignScale].
extension UiScaleBuildContextX on BuildContext {
  /// Convenience getter for [DesignScale] from [UiScaleScope].
  DesignScale get ds => UiScaleScope.of(this);
}
