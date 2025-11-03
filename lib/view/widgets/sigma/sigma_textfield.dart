import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/core/colors.dart';

class SigmaTextField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final Function(String text)? onChanged;
  final Function(String? text)? onSubmitted;
  final Widget? prefixIcon;
  final bool obscure;
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
    this.obscure = false,
    this.keyboardType,
    this.errorText = "",
    this.textInputAction,
    this.counter,
    this.bottomSpacing = 12,
  });

  @override
  State<SigmaTextField> createState() => _SigmaTextFieldState();
}

class _SigmaTextFieldState extends State<SigmaTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscure;
  }

  void _toggleObscure() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  Widget? _suffixWidget() {
    if (widget.obscure) {
      return GestureDetector(
        onTap: _toggleObscure,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 12),
          child: SvgPicture.asset(
            _isObscured ? SigmaAssets.eyeClosedSvg : SigmaAssets.eyeOpenSvg,
          ),
        ),
      );
    }
    return widget.suffix;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.bottomSpacing),
      child: TextField(
        controller: widget.controller,
        obscureText: _isObscured,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        textInputAction: widget.textInputAction,
        maxLines: widget.maxLines,
        onSubmitted: widget.onSubmitted,
        style: const TextStyle(height: 1.3),
        decoration: InputDecoration(
          hintText: widget.label,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: SigmaColors.gray,
          ),
          fillColor: SigmaColors.card,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: SmoothBorderRadius(
              cornerRadius: 12,
              cornerSmoothing: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: SmoothBorderRadius(
              cornerRadius: 12,
              cornerSmoothing: 1,
            ),
          ),
          prefixIcon: widget.prefixIcon != null
              ? Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(child: widget.prefixIcon!),
                  ],
                )
              : null,
          prefixIconConstraints: BoxConstraints(
            maxHeight: 24,
            maxWidth: widget.prefixWidth ?? 48,
          ),
          suffixIcon: _suffixWidget(),
          suffixIconConstraints: const BoxConstraints(
            maxHeight: 24,
            maxWidth: 48,
          ),
          errorText: widget.errorText.isEmpty ? null : widget.errorText,
          constraints: const BoxConstraints(minHeight: 0),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          counter: widget.counter,
        ),
      ),
    );
  }
}
