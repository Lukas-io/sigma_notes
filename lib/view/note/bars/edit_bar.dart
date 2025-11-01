import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/assets.dart';
import '../../widgets/svg_button.dart';

class EditBar extends StatelessWidget {
  const EditBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.standardDrawSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.standardCheckSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.standardLayoutSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.standardTextSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.standardCommandSvg,
            filled: false,
          ),
        ],
      ).animate().fadeIn(duration: 1000.ms, curve: Curves.easeOut),
    );
  }
}
