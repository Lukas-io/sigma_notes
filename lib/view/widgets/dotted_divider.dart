import 'package:flutter/material.dart';
import 'package:sigma_notes/core/colors.dart';

class DottedDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final Color color;
  final double dashWidth;
  final double dashSpacing;
  final double horizontalPadding;

  const DottedDivider({
    super.key,
    this.thickness = 0.8,
    this.height = 32,
    this.color = SigmaColors.gray,
    this.dashWidth = 8,
    this.dashSpacing = 6,
    this.horizontalPadding = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: AlignmentGeometry.center,
      padding: EdgeInsetsGeometry.symmetric(horizontal: horizontalPadding),
      child: CustomPaint(
        painter: _DottedLinePainter(
          color: color,
          dashWidth: dashWidth,
          dashSpacing: dashSpacing,
        ),
        size: Size(double.infinity, thickness),
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final double dashWidth;
  final double dashSpacing;
  final Color color;

  _DottedLinePainter({
    required this.color,
    required this.dashWidth,
    required this.dashSpacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.height
      ..strokeCap = StrokeCap.round;

    double startX = 0;
    final y = size.height / 2;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y), paint);
      startX += dashWidth + dashSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
