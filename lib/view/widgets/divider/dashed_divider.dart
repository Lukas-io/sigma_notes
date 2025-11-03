import 'package:flutter/material.dart';
import 'package:sigma_notes/core/colors.dart';

class DashedDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final Color color;
  final double dashWidth;
  final double dashSpacing;
  final double horizontalPadding;

  const DashedDivider({
    super.key,
    this.thickness = 1,
    this.height = 32,
    this.color = SigmaColors.gray,
    this.dashWidth = 10,
    this.dashSpacing = 6,
    this.horizontalPadding = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: CustomPaint(
        painter: _DashedLinePainter(
          color: color,
          dashWidth: dashWidth,
          dashSpacing: dashSpacing,
          thickness: thickness,
        ),
        size: Size(double.infinity, thickness),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final double dashWidth;
  final double dashSpacing;
  final double thickness;
  final Color color;

  _DashedLinePainter({
    required this.color,
    required this.dashWidth,
    required this.dashSpacing,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness;

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
