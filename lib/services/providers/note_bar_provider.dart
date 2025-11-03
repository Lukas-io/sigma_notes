import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sigma_notes/services/providers/note_mode_provider.dart';
import 'package:sigma_notes/view/note/note_bottom_bar.dart';

import '../../view/note/note_screen.dart';

part 'note_bar_provider.g.dart';

@riverpod
class NoteBarTypeState extends _$NoteBarTypeState {
  @override
  NoteBarType build() {
    // Default to edit mode
    return NoteBarType.edit;
  }

  void setBarType(NoteBarType type) {
    if (type == NoteBarType.commands) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    final mode = ref.read(noteModeStateProvider);
    print(mode);
    if (mode == NoteMode.edit && type == NoteBarType.minimal) {
      print("hello");
      state = NoteBarType.edit;
    } else if (mode == NoteMode.view && (type != NoteBarType.commands)) {
      state = NoteBarType.minimal;
    } else {
      state = type;
    }
  }
}
