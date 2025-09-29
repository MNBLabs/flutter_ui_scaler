# flutter_ui_scaler

![pub](https://img.shields.io/pub/v/flutter_ui_scaler)  
![points](https://img.shields.io/pub/points/flutter_ui_scaler?cacheSeconds=600)
![CI](https://github.com/MNBLabs/flutter_ui_scaler/actions/workflows/ci.yaml/badge.svg)
![License](https://img.shields.io/github/license/MNBLabs/flutter_ui_scaler)
Accurate, orientation-aware scaling for Flutter that keeps your UI **pixel-perfect across devices**.  
🎯 Match your Figma (or any design tool) frame exactly on phones and tablets.

---

## ✨ Why Use This Plugin?

Flutter’s `MediaQuery` scaling is **not design-accurate**.  
Different DPIs and aspect ratios distort layouts — especially in **landscape**, where text suddenly becomes huge.
60px in figma is not 60px on device! Not with flutter natively.

| Figma Design | With `flutter_ui_scaler` | Without (native scaling) |
|---|---|---|
| <img src="https://raw.githubusercontent.com/MNBLabs/flutter_ui_scaler/main/assets/figma_design.png" height="520"/> | <img src="https://raw.githubusercontent.com/MNBLabs/flutter_ui_scaler/main/assets/with_plugin.png" height="520"/> | <img src="https://raw.githubusercontent.com/MNBLabs/flutter_ui_scaler/main/assets/without_plugin.png" height="520"/> |

👉 Notice how proportions, text size, and padding stay **true to the design** with the plugin.

### Landscape Behaviour

| With | Without |
|---|---|
| <img src="https://raw.githubusercontent.com/MNBLabs/flutter_ui_scaler/main/assets/landsp_with_plugin.png" width="350"/> | <img src="https://raw.githubusercontent.com/MNBLabs/flutter_ui_scaler/main/assets/landsp_without_plugin.png" width="350"/> |

✅ Text scaling stays consistent  
❌ Native scaling causes bloated titles and mismatched spacing

---

## 📦 Installation

From terminal:

```bash
flutter pub add flutter_ui_scaler
```

Or add to pubspec.yaml:

```yaml
dependencies:
  flutter_ui_scaler: ^latest
```

Then import:

```dart
import 'package:flutter_ui_scaler/flutter_ui_scaler.dart';
```

---

## 🚀 Quick Start

```dart
return UiScaleScope(
  figmaW: 440,  // your design frame width
  figmaH: 956,  // your design frame height
  child: MaterialApp(home: MyApp()),
);
```

Inside widgets:

```dart
final ds = context.ds; // sugar for DesignScale.of(context)
double pad = ds.sx(16); // padding, radius, sizes
double titleSize = ds.sp(20); // font sizes
```

---

## ⚙️ CLI (Optional)

Team defaults can be set via CLI:

```bash
flutter_ui_scaler --set-des-res 440x956
flutter_ui_scaler --set-clamp 0.9..1.15
flutter_ui_scaler --show
```

This generates `.flutter_ui_scaler.yaml` for shared design settings.

---

## 🧠 API Overview

```dart
DesignScale.of(
  context,
  figmaW: 440,
  figmaH: 956,
  minScale: 0.9,
  maxScale: 1.15,
  tightFontsInLandscape: true,
);
```

- `sx` / `sy` — scaling for padding, widths, radii, heights.
- `sp` — scaling for fonts with smart landscape strategy.
- `UiScaleScope` — app-wide configuration.
- `context.ds` — shorthand for `DesignScale.of(context)`.

---

## 📐 Best Practices

- ✅ Use `sx` / `sy` for paddings, radii, widths, heights.
- ✅ Use `sp` only for text.
- 🚫 Don’t scale bitmap images.
- 🧪 Test on multiple screen sizes (e.g., small phones, tablets, landscape).

---

## 📝 Changelog

See [CHANGELOG.md](https://pub.dev/packages/flutter_ui_scaler/changelog).

---

## 📄 License

MIT © MNBLabs
