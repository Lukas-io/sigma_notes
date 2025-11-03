import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sigma_notes/services/providers/note_mode_provider.dart';

import '../../../core/assets.dart';
import '../../../core/colors.dart';
import '../../widgets/sigma/sigma_ink_well.dart';
import '../note_screen.dart';

class LabelWidget extends ConsumerWidget {
  final String? label;
  final String updatedDate;

  const LabelWidget({
    super.key,
    required this.label,
    required this.updatedDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(noteModeStateProvider);

    Widget labelWidget() {
      if (label == null || (label ?? "").isEmpty) {
        return SigmaInkwell(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              SvgPicture.asset(
                SigmaAssets.plusSvg,
                color: SigmaColors.gray,
                height: 12,
                width: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  "Add label",
                  style: TextStyle(
                    color: SigmaColors.gray,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                    decorationColor: SigmaColors.gray,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Text(
            "$label",
            style: TextStyle(
              color: SigmaColors.gray,
              fontSize: 12,
              decoration: mode == NoteMode.view
                  ? null
                  : TextDecoration.underline,
              decorationColor: SigmaColors.gray,
              height: 1.3,
            ),
          ),
        );
      }
    }

    return Row(
      children: [
        labelWidget(),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: mode == NoteMode.view
              ? Text(
                  "｜ $updatedDate",
                  key: Key("label-updated-date-show"),
                  style: TextStyle(
                    color: SigmaColors.gray,
                    fontSize: 12,
                    height: 1.3,
                  ),
                )
              : SizedBox.shrink(key: Key("label-updated-date-hide")),
        ),
      ],
    );
  }
}
