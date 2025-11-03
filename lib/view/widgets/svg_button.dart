import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sigma_notes/core/colors.dart';
import 'package:sigma_notes/view/widgets/sigma_ink_well.dart';

class SvgButton extends StatelessWidget {
  final String assetPath;
  final double size;
  final double? iconSize;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool primary;
  final bool filled;
  final List<BoxShadow>? shadows;

  const SvgButton({
    super.key,
    required this.assetPath,
    this.size = 44,
    this.iconSize = 24,
    this.shadows,
    this.filled = true,
    this.onTap,
    this.backgroundColor,
    this.primary = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final icon = SvgPicture.asset(
      assetPath,
      width: iconSize,
      height: iconSize,
      colorFilter: ColorFilter.mode(
        iconColor ?? (primary ? SigmaColors.white : SigmaColors.black),
        BlendMode.srcIn,
      ),
    );

    return SigmaInkwell(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: !filled
          ? icon
          : Container(
              decoration: BoxDecoration(
                boxShadow:
                    shadows ??
                    [
                      if (primary)
                        BoxShadow(
                          spreadRadius: 12,
                          color: SigmaColors.black.withOpacity(0.2),
                          blurRadius: 28,
                        )
                      else
                        BoxShadow(
                          spreadRadius: 12,
                          color: SigmaColors.card.withOpacity(0.5),
                          blurRadius: 12,
                        ),
                    ],
                borderRadius: BorderRadius.circular(360),
              ),
              clipBehavior: Clip.none,
              child: CircleAvatar(
                radius: size / 2,

                backgroundColor:
                    backgroundColor ??
                    (primary ? SigmaColors.black : Colors.white),
                child: icon,
              ),
            ),
    );
  }
}
