import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_notes/services/providers/note_mode_provider.dart';
import 'package:sigma_notes/view/note/note_screen.dart';

import '../../../core/colors.dart';

class TitleWidget extends ConsumerStatefulWidget {
  final String title;

  const TitleWidget(this.title, {super.key});

  @override
  ConsumerState<TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends ConsumerState<TitleWidget> {
  late final TextEditingController titleEditingController;

  @override
  void initState() {
    super.initState();
    titleEditingController = TextEditingController(text: widget.title.trim());
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(noteModeStateProvider);
    return Column(
      children: [
        AnimatedSize(
          duration: Duration(milliseconds: 250),
          clipBehavior: Clip.none,
          curve: Curves.easeOut,
          alignment: AlignmentGeometry.topLeft,
          child: mode == NoteMode.view
              ? Align(
                  alignment: AlignmentGeometry.topLeft,
                  child: SelectableText(
                    widget.title.trim(),
                    style: TextStyle(
                      color: SigmaColors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                      height: 1.3,
                    ),
                  ),
                )
              : TextField(
                  controller: titleEditingController,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    contentPadding: EdgeInsetsGeometry.symmetric(vertical: 0),

                    hintStyle: TextStyle(
                      color: SigmaColors.gray,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                    hintText: "Title",
                    isDense: true,
                  ),
                  style: TextStyle(
                    color: SigmaColors.black,
                    letterSpacing: 0.3,

                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
        ),
        AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: mode == NoteMode.view ? 0 : 1,
          curve: Curves.easeOut,

          child: Divider(height: 8, thickness: 0.6),
        ),
      ],
    );
  }
}
