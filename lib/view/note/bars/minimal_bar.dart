import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/assets.dart';
import '../../widgets/sigma_ink_well.dart';

class MinimalBar extends StatelessWidget {
  const MinimalBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SigmaInkwell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Commands", style: TextStyle()),
            
            SvgPicture.asset(
              SigmaAssets.standardCommandSvg,
              width: 16,
              height: 16,
            ),
          ],
        ).animate().fadeIn(duration: 1000.ms, curve: Curves.easeOut),
      ),
    );
  }
}
