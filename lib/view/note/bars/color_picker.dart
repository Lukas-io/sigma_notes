import 'package:flutter/material.dart';
import 'package:sigma_notes/core/colors.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.all(1.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: SigmaColors.black, width: 1),
      ),
      child: CircleAvatar(backgroundColor: Colors.blue, radius: 10),
    );
  }
}

/// A set of classy, balanced color shades based on basic colors.
/// Suitable for text, drawings, and accents.
final List<Color> classyPalette = [
  SigmaColors.black,
  const Color(0xFF4A90E2), // Elegant Blue — calm & modern
  const Color(0xFFE57373), // Soft Coral — gentle red tone
  const Color(0xFF81C784), // Fresh Green — natural, optimistic
  const Color(0xFFFDD835), // Warm Gold — energetic but refined
  const Color(0xFFBA68C8), // Royal Purple — creative & thoughtful
  const Color(0xFF7986CB), // Slate Indigo — sophisticated cool tone
  const Color(0xFFFFB74D), // Amber Glow — cozy & inviting
];
