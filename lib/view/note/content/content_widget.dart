import 'package:flutter/material.dart';
import 'package:sigma_notes/view/note/content/checklist_content_widget.dart';
import 'package:sigma_notes/view/note/content/content_divider.dart';
import 'package:sigma_notes/view/note/content/text_content_widget.dart';
import 'package:sigma_notes/view/note/content/audio_content_widget.dart';

import '../../../models/content/content_model.dart';

/// A stateless widget that renders different content
/// based on the [type] inside the provided [ContentModel].
class ContentWidget extends StatelessWidget {
  final ContentModel content;

  const ContentWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    switch (content.type) {
      case ContentType.text:
        return TextContentWidget(content as TextContent);
      case ContentType.checklist:
        return ChecklistContentWidget(
          content as ChecklistContent,
          size: CheckListSize.normal,
        ); // TODO: Replace with Checklist widget
      case ContentType.image:
        return const SizedBox(); // TODO: Replace with Image widget
      case ContentType.audio:
        return AudioContentWidget(content as AudioContent);
      // case ContentType.video:
      //   return const SizedBox(); // TODO: Replace with Video player widget
      case ContentType.drawing:
        return const SizedBox(); // TODO: Replace with Drawing widget
      case ContentType.quote:
        return const SizedBox(); // TODO: Replace with Quote widget
      case ContentType.divider:
        return ContentDivider(content as DividerContent);
      // case ContentType.attachment:
      //   return const SizedBox(); // TODO: Replace with Attachment widget
      // case ContentType.code:
      //   return const SizedBox(); // TODO: Replace with Code widget
      // case ContentType.embed:
      //   return const SizedBox(); // TODO: Replace with Embed widget
      // case ContentType.table:
      //   return const SizedBox(); // TODO: Replace with Table widget
      // case ContentType.tag:
      //   return const SizedBox(); // TODO: Replace with Tag widget
      // case ContentType.gallery:
      //   return const SizedBox(); // TODO: Replace with Gallery widget
      // case ContentType.location:
      //   return const SizedBox(); // TODO: Replace with Location widget
      // case ContentType.timer:
      //   return const SizedBox(); // TODO: Replace with Timer widget
      // case ContentType.link:
      //   return const SizedBox(); // TODO: Replace with Link widget
      default:
        return const SizedBox(); // TODO: Handle unsupported or unknown content types}
    }
  }
}
