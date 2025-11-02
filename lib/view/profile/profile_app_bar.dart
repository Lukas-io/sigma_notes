import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/view/widgets/svg_button.dart';

import '../../core/colors.dart';
import '../../core/router/routes.dart';
import '../widgets/sigma_image.dart';
import '../widgets/sigma_ink_well.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SafeArea(
        bottom: false,

        child: SizedBox(
          height: kToolbarHeight,

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),

            child: Row(
              children: [
                SvgButton(
                  assetPath: SigmaAssets.backSvg,
                  onTap: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    // child: Text(
                    //   "My Notes",
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.w600,
                    //     fontSize: 20,
                    //   ),
                    // ),
                  ),
                ),
                SvgButton(
                  assetPath: SigmaAssets.editSvg,
                  primary: true,
                  shadows: [
                    BoxShadow(
                      spreadRadius: 12,
                      color: SigmaColors.card.withOpacity(0.5),
                      blurRadius: 12,
                    ),
                  ],
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
