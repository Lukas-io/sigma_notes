import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

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
}
