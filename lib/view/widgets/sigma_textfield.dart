import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/core/colors.dart';

class SigmaTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final Function(String text)? onChanged;
  final Function(String? text)? onSubmitted;
  final Widget? prefixIcon;
  final bool? obscure;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final double bottomSpacing;
  final double? prefixWidth;
  final String errorText;
  final Widget? counter;
  final Widget? suffix;

  const SigmaTextField({
    super.key,
    required this.label,
    this.onChanged,
    this.controller,
    this.prefixIcon,
    this.prefixWidth,
    this.maxLines = 1,
    this.onSubmitted,
    this.suffix,
    this.obscure,
    this.keyboardType,
    this.errorText = "",
    this.textInputAction,
    this.counter,
    this.bottomSpacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    Widget? suffixWidget() {
      if (obscure != null) {
        return SvgPicture.asset(
          obscure! ? SigmaAssets.eyeClosedSvg : SigmaAssets.eyeOpenSvg,
        );
      }

      return suffix;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: TextField(
        controller: controller,
        obscureText: obscure ?? false,
        keyboardType: keyboardType,
        onChanged: onChanged,
        textInputAction: textInputAction,
        maxLines: maxLines,
        cursorColor: SigmaColors.black,
        style: TextStyle(height: 1.3),
        decoration: InputDecoration(
          suffixIcon: suffixWidget(),
          hintText: label,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: SigmaColors.gray,
          ),
          fillColor: SigmaColors.card,

          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: SmoothBorderRadius(
              cornerRadius: 10,
              cornerSmoothing: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: SmoothBorderRadius(
              cornerRadius: 10,
              cornerSmoothing: 1,
            ),
          ),
          prefixIcon: prefixIcon != null
              ? Row(
                  children: [
                    SizedBox(width: 8),
                    Expanded(child: prefixIcon!),
                  ],
                )
              : null,
          prefixIconConstraints: BoxConstraints(
            maxHeight: 24,
            maxWidth: prefixWidth ?? 48,
          ),
          suffixIconConstraints: BoxConstraints(maxHeight: 24, maxWidth: 48),

          errorText: errorText.isEmpty ? null : errorText,
          constraints: BoxConstraints(minHeight: 0),
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          counter: counter,

          // suffixIcon: Icon(CupertinoIcons.eye),
        ),
      ),
    );
  }
}
