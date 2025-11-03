import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sigma_notes/view/note/bars/color_picker.dart';

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
          ColorPicker(),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.layoutHorizontalSvg, //horizontal
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.layoutVerticalSvg, //vertical
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.layoutBringFrontSvg, // bring top
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.layoutBringBackSvg, // bring bottom
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.deleteSvg, // delete
            filled: false,
            iconColor: CupertinoColors.destructiveRed,
          ),
        ],
      ).animate().fadeIn(duration: 600.ms, curve: Curves.easeOut),
    );
  }
}
