import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:sigma_notes/core/colors.dart';

class SigmaButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Widget? icon;
  final double width;
  final double? height;

  final EdgeInsets padding;
  final Color backgroundColor;
  final double bottomSpacing;
  final ButtonStyle? style;
  final bool isEnabled;
  final bool isLoading;

  const SigmaButton({
    super.key,
    required this.child,
    this.onPressed,
    this.icon,
    this.style,
    this.height,
    this.backgroundColor = SigmaColors.primary,
    this.width = double.infinity,
    this.bottomSpacing = 12,

    this.isEnabled = true,
    this.isLoading = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: TextButton(
        onPressed: isEnabled
            ? !isLoading
                  ? onPressed
                  : () {}
            : null,
        style:
            style ??
            TextButton.styleFrom(
              minimumSize: Size(width, 24),
              padding: padding,
              backgroundColor: backgroundColor,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 10,
                  cornerSmoothing: 1,
                ),
              ),
              disabledBackgroundColor: backgroundColor.withOpacity(0.75),
              maximumSize: height != null ? Size.fromHeight(height!) : null,
              foregroundColor: SigmaColors.white,
              disabledForegroundColor: SigmaColors.white,
            ),

        child: AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
          clipBehavior: Clip.none,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeOut,

            child: isLoading
                ? SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: SigmaColors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [if (icon != null) icon!, child],
                  ),
          ),
        ),
      ),
    );
  }
}
