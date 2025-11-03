import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sigma_notes/view/note/note_bottom_bar.dart';
import 'package:sigma_notes/view/note/note_screen.dart';

import 'note_bar_provider.dart';

part 'note_mode_provider.g.dart';

@riverpod
class NoteModeState extends _$NoteModeState {
  @override
  NoteMode build() {
    // Default to edit mode
    return NoteMode.edit;
  }

  void setMode(NoteMode mode) {
    state = mode;

    final barTypeNotifier = ref.read(noteBarTypeStateProvider.notifier);
    barTypeNotifier.setBarType(
      mode == NoteMode.view ? NoteBarType.minimal : NoteBarType.edit,
    );
  }
}
