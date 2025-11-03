import 'package:flutter/material.dart';
import 'package:sigma_notes/view/note/content/checklist_content_widget.dart';
import 'package:sigma_notes/view/note/content/content_divider.dart';
import 'package:sigma_notes/view/note/content/text_content_widget.dart';
import 'package:sigma_notes/view/note/content/audio_content_widget.dart';

import '../../../models/content/content_model.dart';

/// A stateless widget that renders different content
/// based on the [type] inside the provided [ContentModel].
class ContentWidget extends StatelessWidget {
  final String noteId;
  final ContentModel content;

  const ContentWidget({super.key, required this.content, required this.noteId});

  @override
  Widget build(BuildContext context) {
    switch (content.type) {
      case ContentType.text:
        return TextContentWidget(
          content as TextContent,
          noteId: noteId, // pass noteId here
        );
      case ContentType.checklist:
        return ChecklistContentWidget(
          content as ChecklistContent,
          noteId: noteId, // pass noteId here
          size: CheckListSize.normal,
        );
      case ContentType.image:
        return const SizedBox(); // TODO: Replace with Image widget and pass noteId
      case ContentType.audio:
        return AudioContentWidget(
          content as AudioContent,
          noteId: noteId, // pass noteId here
        );
      // case ContentType.video:
      //   return const SizedBox(); // TODO: Replace with Video player widget
      case ContentType.drawing:
        return const SizedBox(); // TODO: Replace with Drawing widget
      case ContentType.quote:
        return const SizedBox(); // TODO: Replace with Quote widget
      case ContentType.divider:
        return ContentDivider(
          content as DividerContent,
          noteId: noteId, // pass noteId here if needed
        );
      // TODO: do the same for other content types
      default:
        return const SizedBox(); // handle unsupported types
    }
  }
}
