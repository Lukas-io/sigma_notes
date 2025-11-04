import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sigma_notes/core/colors.dart';
import 'package:sigma_notes/view/note/bars/color_picker.dart';
import 'package:sigma_notes/view/widgets/sigma/sigma_ink_well.dart';

import '../../../core/assets.dart';

enum TextEditOptionType { radio, select, button }

class TextEditingOption {
  final Widget? child;
  final String? assetPath;
  final VoidCallback? onPressed;
  final bool isActive;
  final int flex;

  const TextEditingOption({
    this.child,
    this.assetPath,
    this.onPressed,
    this.flex = 1,
    required this.isActive,
  });
}

class TextBar extends StatelessWidget {
  const TextBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        spacing: 12,
        children: [
          Row(
            spacing: 12,
            children: [
              Expanded(
                flex: 3,
                child: TextEditOptionsWidget([
                  TextEditingOption(
                    isActive: false,
                    flex: 2,
                    child: Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          SigmaAssets.textHighlighterSvg,
                          width: 24,
                          height: 24,
                        ),
                        Text("Highlighter"),
                      ],
                    ),
                  ),
                  TextEditingOption(isActive: false, child: ColorPicker()),
                ]),
              ),
              Expanded(
                flex: 1,
                child: TextEditOptionsWidget([
                  TextEditingOption(
                    isActive: false,
                    assetPath: SigmaAssets.soundWaveSvg,
                  ),
                ]),
              ),
              Expanded(
                flex: 1,
                child: TextEditOptionsWidget([
                  TextEditingOption(
                    isActive: false,
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: SigmaColors.black,
                          width: 1.25,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        SigmaAssets.checkMarkSvg,
                        color: SigmaColors.black,
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
          Row(
            spacing: 12,
            children: [
              Expanded(
                flex: 2,
                child: TextEditOptionsWidget([
                  TextEditingOption(
                    isActive: false,
                    assetPath: SigmaAssets.textBoldSvg,
                  ),
                  TextEditingOption(
                    isActive: false,
                    assetPath: SigmaAssets.textItalicSvg,
                  ),
                  TextEditingOption(
                    isActive: false,
                    assetPath: SigmaAssets.textStrikethroughSvg,
                  ),
                  TextEditingOption(
                    isActive: false,
                    assetPath: SigmaAssets.textUnderlineSvg,
                  ),
                ]),
              ),

              Expanded(
                flex: 1,
                child: TextEditOptionsWidget([
                  TextEditingOption(
                    isActive: false,
                    assetPath: SigmaAssets.textBulletSvg,
                  ),
                  TextEditingOption(
                    isActive: false,
                    assetPath: SigmaAssets.textQuoteSvg,
                  ),
                ]),
              ),
            ],
          ),

          TextEditOptionsWidget([
            TextEditingOption(
              isActive: false,
              assetPath: SigmaAssets.textHeading1Svg,
            ),
            TextEditingOption(
              isActive: false,
              assetPath: SigmaAssets.textHeading2Svg,
            ),
            TextEditingOption(
              isActive: false,
              assetPath: SigmaAssets.textHeading3Svg,
            ),
          ]),
        ],
      ).animate().fadeIn(duration: 600.ms, curve: Curves.easeOut),
    );
  }
}

class TextEditOptionsWidget extends StatelessWidget {
  final TextEditOptionType type;
  final List<TextEditingOption> options;

  const TextEditOptionsWidget(
    this.options, {
    super.key,
    this.type = TextEditOptionType.button,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: EdgeInsetsGeometry.symmetric(),
      decoration: BoxDecoration(
        borderRadius: SmoothBorderRadius(cornerRadius: 12, cornerSmoothing: 1),
        color: SigmaColors.card,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            options
                .map<Widget>(
                  (option) => Expanded(
                    flex: option.flex,
                    child: SigmaInkwell(
                      onTap: option.onPressed,
                      child: Container(
                        alignment: AlignmentGeometry.center,
                        color: option.isActive ? SigmaColors.black : null,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child:
                            option.child ??
                            SvgPicture.asset(
                              option.assetPath ?? SigmaAssets.maximizeSvg,
                              width: 24,
                              height: 24,
                            ),
                      ),
                    ),
                  ),
                )
                // insert a divider between each item
                .expand(
                  (widget) => [
                    widget,
                    Container(
                      width: 0.3,
                      height: double.infinity,

                      color: Colors.grey,
                    ),
                  ],
                )
                .toList()
              ..removeLast(), // remove the trailing divider at the end
      ),
    );
  }
}
