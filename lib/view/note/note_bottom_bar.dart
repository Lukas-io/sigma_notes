import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sigma_notes/core/colors.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sprung/sprung.dart';

import 'bars/commands_bar.dart';
import 'bars/draw_bar.dart';
import 'bars/layout_bar.dart';
import 'bars/minimal_bar.dart';
import 'bars/edit_bar.dart';
import 'bars/text_bar.dart';

enum NoteBarType { minimal, edit, text, draw, layout, commands }

class NoteBottomBar extends StatelessWidget {
  final NoteBarType type;
  final NoteModel note;

  const NoteBottomBar(this.note, {super.key, this.type = NoteBarType.edit});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.widthOf(context) - 32),
      child: Material(
        elevation: 75,
        color: SigmaColors.white.withOpacity(0),
        shadowColor: SigmaColors.gray.withOpacity(0.25),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: SigmaColors.card),
            color: Colors.white,
            borderRadius: SmoothBorderRadius(
              cornerRadius: 16,
              cornerSmoothing: 1,
            ),
          ),

          child: AnimatedSize(
            duration: 800.ms,
            curve: Sprung(28),
            child: AnimatedSwitcher(
              duration: 150.ms,
              switchInCurve: Sprung(28),
              switchOutCurve: Sprung(28),
              child: switch (type) {
                NoteBarType.edit => EditBar(),
                NoteBarType.text => TextBar(),
                NoteBarType.draw => DrawBar(),
                NoteBarType.layout => LayoutBar(),
                NoteBarType.commands => CommandsBar(note),
                NoteBarType.minimal => MinimalBar(),
              },
            ),
          ),
        ),
      ),
    );
  }
}
