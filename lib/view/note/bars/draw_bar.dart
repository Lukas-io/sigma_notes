import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sigma_notes/view/note/bars/color_picker.dart';

import '../../../core/assets.dart';
import '../../widgets/svg_button.dart';

class DrawBar extends StatelessWidget {
  const DrawBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ColorPicker(),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.brushSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.editSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.drawPenSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.eraserSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.maximizeSvg,
            filled: false,
          ),
        ],
      ).animate().fadeIn(duration: 600.ms, curve: Curves.easeOut),
    );
  }
}
