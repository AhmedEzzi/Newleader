import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_assets.dart';

class CustomImage extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final String? placeholderAsset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;

  const CustomImage({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.placeholderAsset = AppImages.placeHolder,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.borderRadius,
    this.errorWidget,
  }) : assert(imageUrl != null || assetPath != null, "Provide either an imageUrl or assetPath");

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(0),
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return _buildNetworkImage();
    } else if (assetPath != null && assetPath!.isNotEmpty) {
      return _buildAssetImage();
    }
    return _buildPlaceholder();
  }

  /// Builds network image, handling both raster and SVG formats.
  Widget _buildNetworkImage() {
    if (imageUrl!.endsWith('.svg')) {
      return SvgPicture.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholderBuilder: (context) => _buildPlaceholder(),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => errorWidget ??
            Icon(Icons.error, size: width != null ? width! / 2 : 40, color: Colors.red),
      );
    }
  }

  /// Builds asset image, handling both raster and SVG formats.
  Widget _buildAssetImage() {
    if (assetPath!.endsWith('.svg')) {  // Changed from .svgs to .svg
      return SvgPicture.asset(
        assetPath!,
        width: width,
        height: height,
        fit: fit,
      );
    } else {
      return Image.asset(
        assetPath!,
        width: width,
        height: height,
        fit: fit,
      );
    }
  }

  /// Builds a placeholder image.
  Widget _buildPlaceholder() {
    if (placeholderAsset!.endsWith('.svg')) {
      return SvgPicture.asset(
        AppIcons.filter,
        width: width,
        height: height,
        fit: BoxFit.contain,
      );
    } else {
      return Image.asset(
        placeholderAsset!,
        width: width,
        height: height,
        fit: BoxFit.contain,
      );
    }
  }
}
