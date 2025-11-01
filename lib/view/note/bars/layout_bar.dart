import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/assets.dart';
import '../../widgets/svg_button.dart';

class LayoutBar extends StatelessWidget {
  const LayoutBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
        ],
      ).animate().fadeIn(duration: 1000.ms, curve: Curves.easeOut),
    );
  }
}
