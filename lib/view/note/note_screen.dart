import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/view/note/note_app_bar.dart';
import 'package:sigma_notes/view/note/note_bottom_bar.dart';
import 'package:sigma_notes/view/note/note_screen_content.dart';
import 'package:sigma_notes/view/note/note_screen_edit_content.dart';
import 'package:sigma_notes/view/widgets/sigma_ink_well.dart';

import '../../core/colors.dart';

enum NoteMode { view, edit }

class NoteScreen extends StatelessWidget {
  final NoteModel note;
  final NoteMode mode;

  const NoteScreen(this.note, {super.key, this.mode = NoteMode.edit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: AlignmentGeometry.topCenter,
              children: [
                if (mode == NoteMode.view) NoteScreenContent(note),
                if (mode == NoteMode.edit) NoteScreenEditContent(note),

                // Top gradient
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 2.5, sigmaX: 2.5),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              SigmaColors.white,
                              SigmaColors.white.withOpacity(0.85),
                              SigmaColors.white.withOpacity(0.75),
                              SigmaColors.white.withOpacity(0.5),
                              SigmaColors.white.withOpacity(0),
                            ],
                          ),
                        ),
                        child: SafeArea(
                          bottom: false,

                          child: SizedBox(height: kToolbarHeight),
                        ),
                      ),
                    ),
                  ),
                ),
                NoteAppBar(),
                // Bottom gradient
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 2, sigmaX: 2),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              SigmaColors.white.withOpacity(1),
                              SigmaColors.white.withOpacity(0),
                            ],
                          ),
                        ),
                        child: SafeArea(
                          top: false,
                          child: SizedBox(height: 40),
                        ),
                      ),
                    ),
                  ),
                ),
                if (NoteBarType.commands == true)
                  Positioned.fill(
                    child: SigmaInkwell(
                      onTap: () {},

                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaY: 6, sigmaX: 6),
                        child: Container(
                          color: SigmaColors.black.withOpacity(0.35),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 8,
                  child: SafeArea(child: NoteBottomBar(note)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
