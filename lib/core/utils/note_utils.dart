import 'dart:math';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../models/content/content_type.dart';
import '../../models/funny_hints.dart';

class NoteUtils {
  static final _uuid = Uuid();

  /// Generates a new unique ID for a note
  static String newNoteId() => _uuid.v4();

  /// Returns a smart, human-readable time string for a given [dateTime].
  static String formatSmartDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 14) {
      return 'Last week';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      return DateFormat('MMM d, y').format(dateTime);
    }
  }

  /// Master function to get one random funny hint based on content type
  static String getFunnyHintForType(ContentType type) {
    final random = Random();

    List<String> hints;
    switch (type) {
      case ContentType.text:
        hints = textHints;
        break;
      case ContentType.checklist:
        hints = checklistHints;
        break;
      case ContentType.image:
        hints = imageHints;
        break;
      case ContentType.audio:
        hints = audioHints;
        break;
      case ContentType.video:
        hints = videoHints;
        break;
      case ContentType.drawing:
        hints = drawingHints;
        break;
      case ContentType.quote:
        hints = quoteHints;
        break;
      case ContentType.divider:
        hints = dividerHints;
        break;
      case ContentType.attachment:
        hints = attachmentHints;
        break;
      case ContentType.code:
        hints = codeHints;
        break;
      case ContentType.embed:
        hints = embedHints;
        break;
      case ContentType.table:
        hints = tableHints;
        break;
      case ContentType.tag:
        hints = tagHints;
        break;
      case ContentType.gallery:
        hints = galleryHints;
        break;
      case ContentType.location:
        hints = locationHints;
        break;
      case ContentType.timer:
        hints = timerHints;
        break;
      case ContentType.link:
        hints = linkHints;
        break;
      default:
        hints = ["Add something here."];
    }

    // Return one random hint
    return hints[random.nextInt(hints.length)];
  }
}
