// lib/providers/focus_content_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'focus_content_provider.g.dart';

/// Represents which content block is currently focused.
/// Stores its `contentId` and `noteId` (useful if you support multiple notes open).
@riverpod
class FocusedContentState extends _$FocusedContentState {
  @override
  String? build() => null; // no focused block by default

  /// Called when a block gains focus
  void focus(String contentId) {
    if (state != contentId) {
      state = contentId;
    }
  }

  /// Called when focus is removed from a block
  void unfocus(String contentId) {
    if (state == contentId) {
      state = null;
    }
  }

  /// Utility check
  bool isFocused(String contentId) => state == contentId;
}
