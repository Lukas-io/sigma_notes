import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_notes/models/content/content_model.dart';
import 'package:sigma_notes/services/providers/note_mode_provider.dart';

import '../../../core/colors.dart';
import '../../../services/providers/note_editor_provider.dart';
import '../note_screen.dart';

class TextContentWidget extends ConsumerStatefulWidget {
  final TextContent content;
  final String noteId;

  const TextContentWidget(this.content, {super.key, required this.noteId});

  @override
  ConsumerState<TextContentWidget> createState() => _TextContentWidgetState();
}

class _TextContentWidgetState extends ConsumerState<TextContentWidget> {
  late final TextEditingController contentEditingController;
  String hintText = getFunnyHintForType(ContentType.text);

  late TextContent content;

  @override
  void initState() {
    content = widget.content;
    contentEditingController = TextEditingController(text: content.text.trim());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(noteModeStateProvider);

    return AnimatedSize(
      duration: Duration(milliseconds: 250),
      clipBehavior: Clip.none,
      curve: Curves.easeOut,
      alignment: AlignmentGeometry.topLeft,
      child: mode == NoteMode.view
          ? Align(
              alignment: AlignmentGeometry.topLeft,
              child: SelectableText(
                content.text,
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 0.3,
                  height: 1.3,

                  color: SigmaColors.black,
                ),
              ),
            )
          : TextField(
              controller: contentEditingController,
              maxLines: null,
              onChanged: (value) {
                content = content.copyWith(text: value);
                ref
                    .read(noteEditorProvider(widget.noteId).notifier)
                    .updateContent(content.id, content);
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsetsGeometry.symmetric(vertical: 0),

                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                hintStyle: TextStyle(color: SigmaColors.gray, fontSize: 16),
                hintText: hintText,
                isDense: true,
              ),
              style: TextStyle(
                color: SigmaColors.black,
                fontSize: 16,
                letterSpacing: 0.3,
                height: 1.3,
              ),
            ),
    );
  }
}
