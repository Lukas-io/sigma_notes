import 'package:flutter/material.dart';

class SigmaInkwell extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;
  final double pressedOpacity;
  final Curve curve;
  final HitTestBehavior behavior;

  const SigmaInkwell({
    super.key,
    required this.child,
    this.onTap,
    this.duration = const Duration(milliseconds: 120),
    this.pressedOpacity = 0.65,
    this.curve = Curves.easeOut,
    this.behavior = HitTestBehavior.translucent,
  });

  @override
  State<SigmaInkwell> createState() => _SigmaInkwellState();
}

class _SigmaInkwellState extends State<SigmaInkwell> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsetsGeometry.all(1),
        child: AnimatedOpacity(
          duration: widget.duration,
          opacity: _isPressed ? widget.pressedOpacity : 1.0,
          curve: widget.curve,
          child: widget.child,
        ),
      ),
    );
  }
}
