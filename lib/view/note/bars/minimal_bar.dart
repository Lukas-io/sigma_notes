import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/assets.dart';
import '../../../services/providers/note_bar_provider.dart';
import '../../widgets/sigma_ink_well.dart';
import '../note_bottom_bar.dart';

class MinimalBar extends ConsumerWidget {
  const MinimalBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SigmaInkwell(
      onTap: () {
        ref
            .read(noteBarTypeStateProvider.notifier)
            .setBarType(NoteBarType.commands);
      },
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
        ).animate().fadeIn(duration: 600.ms, curve: Curves.easeOut),
      ),
    );
  }
}
