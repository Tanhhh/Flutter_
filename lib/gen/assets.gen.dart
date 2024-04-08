/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Back-arrow.png
  AssetGenImage get backArrow =>
      const AssetGenImage('assets/images/Back-arrow.png');

  /// File path: assets/images/Cart icon.png
  AssetGenImage get cartIcon =>
      const AssetGenImage('assets/images/Cart icon.png');

  /// File path: assets/images/EnvelopeSimple.png
  AssetGenImage get envelopeSimple =>
      const AssetGenImage('assets/images/EnvelopeSimple.png');

  /// File path: assets/images/Fashion.png
  AssetGenImage get fashion => const AssetGenImage('assets/images/Fashion.png');

  /// File path: assets/images/Full View.png
  AssetGenImage get fullView =>
      const AssetGenImage('assets/images/Full View.png');

  /// File path: assets/images/Grid View.png
  AssetGenImage get gridView =>
      const AssetGenImage('assets/images/Grid View.png');

  /// File path: assets/images/Lock.png
  AssetGenImage get lock => const AssetGenImage('assets/images/Lock.png');

  /// File path: assets/images/Menu.png
  AssetGenImage get menu => const AssetGenImage('assets/images/Menu.png');

  /// File path: assets/images/Search Icon.png
  AssetGenImage get searchIcon =>
      const AssetGenImage('assets/images/Search Icon.png');

  /// File path: assets/images/Shopping-bag.png
  AssetGenImage get shoppingBag =>
      const AssetGenImage('assets/images/Shopping-bag.png');

  /// File path: assets/images/c3.png
  AssetGenImage get c3 => const AssetGenImage('assets/images/c3.png');

  /// File path: assets/images/fav.png
  AssetGenImage get fav => const AssetGenImage('assets/images/fav.png');

  /// File path: assets/images/hoodie 1.png
  AssetGenImage get hoodie1 =>
      const AssetGenImage('assets/images/hoodie 1.png');

  /// File path: assets/images/icon.png
  AssetGenImage get icon => const AssetGenImage('assets/images/icon.png');

  /// File path: assets/images/jacket 1.png
  AssetGenImage get jacket1 =>
      const AssetGenImage('assets/images/jacket 1.png');

  /// File path: assets/images/jeans 2.png
  AssetGenImage get jeans2 => const AssetGenImage('assets/images/jeans 2.png');

  /// File path: assets/images/sort-tool.png
  AssetGenImage get sortTool =>
      const AssetGenImage('assets/images/sort-tool.png');

  /// File path: assets/images/splash-v1.jpg
  AssetGenImage get splashV1 =>
      const AssetGenImage('assets/images/splash-v1.jpg');

  /// File path: assets/images/splash.jpg
  AssetGenImage get splash => const AssetGenImage('assets/images/splash.jpg');

  /// File path: assets/images/v-lg.png
  AssetGenImage get vLg => const AssetGenImage('assets/images/v-lg.png');

  /// File path: assets/images/vector.png
  AssetGenImage get vector => const AssetGenImage('assets/images/vector.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        backArrow,
        cartIcon,
        envelopeSimple,
        fashion,
        fullView,
        gridView,
        lock,
        menu,
        searchIcon,
        shoppingBag,
        c3,
        fav,
        hoodie1,
        icon,
        jacket1,
        jeans2,
        sortTool,
        splashV1,
        splash,
        vLg,
        vector
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
