import 'package:flutter/material.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/view/widgets/svg_button.dart';

class NoteAppBar extends StatelessWidget {
  const NoteAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [SvgButton(assetPath: SigmaAssets.backSvg)]),
    );
  }
}
