import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../core/colors.dart';

class SigmaImage extends StatelessWidget {
  final String? assetPath; // for asset image
  final Uint8List? memoryBytes; // for in-memory image
  final BoxFit? fit;
  final double? width;
  final double? height;
  final AlignmentGeometry alignment;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? color;
  final BlendMode? colorBlendMode;
  final BorderRadiusGeometry? borderRadius;
  final FilterQuality filterQuality;
  final bool gaplessPlayback;

  const SigmaImage({
    super.key,
    this.assetPath,
    this.memoryBytes,
    this.fit,
    this.width = 100,
    this.height = 100,
    this.alignment = Alignment.center,
    this.placeholder,
    this.errorWidget,
    this.color,
    this.colorBlendMode,
    this.borderRadius,
    this.filterQuality = FilterQuality.low,
    this.gaplessPlayback = false,
  }) : assert(
         assetPath != null || memoryBytes != null,
         'Either assetPath or memoryBytes must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(spreadRadius: 8, color: SigmaColors.card, blurRadius: 12),
        // ],
        borderRadius: borderRadius,
      ),
      child: Builder(
        builder: (context) {
          Widget image;

          try {
            if (memoryBytes != null) {
              image = Image.memory(
                memoryBytes!,
                width: width,
                height: height,
                fit: fit,
                alignment: alignment,
                color: color,
                colorBlendMode: colorBlendMode,
                filterQuality: filterQuality,
                gaplessPlayback: gaplessPlayback,
              );
            } else if (assetPath != null) {
              image = Image.asset(
                assetPath!,
                width: width,
                height: height,
                fit: fit,
                alignment: alignment,
                color: color,
                colorBlendMode: colorBlendMode,
                filterQuality: filterQuality,
                gaplessPlayback: gaplessPlayback,
              );
            } else {
              throw Exception('No image source provided');
            }
          } catch (e) {
            image =
                errorWidget ??
                const Icon(Icons.broken_image, color: Colors.grey, size: 32);
          }

          return ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.zero,
            child: image,
          );
        },
      ),
    );
  }
}
