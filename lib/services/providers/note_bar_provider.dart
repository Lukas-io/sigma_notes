import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sigma_notes/view/note/note_bottom_bar.dart';

part 'note_bar_provider.g.dart';

@riverpod
class NoteBarTypeState extends _$NoteBarTypeState {
  @override
  NoteBarType build() {
    // Default to edit mode
    return NoteBarType.edit;
  }

  void setBarType(NoteBarType type) {
    state = type;
  }
}
