import 'package:flutter/material.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/view/note/note_app_bar.dart';
import 'package:sigma_notes/view/note/note_screen_content.dart';

import '../../core/colors.dart';

class NoteScreen extends StatelessWidget {
  final NoteModel note;

  const NoteScreen(this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentGeometry.topCenter,
        children: [
          NoteScreenContent(note),

          // Top gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    SigmaColors.white,
                    SigmaColors.white.withOpacity(0.9),
                    SigmaColors.white.withOpacity(0.8),
                    SigmaColors.white.withOpacity(0.25),
                  ],
                ),
              ),
              child: SafeArea(child: SizedBox(height: kToolbarHeight - 30)),
            ),
          ),
          NoteAppBar(),
          // Bottom gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [SigmaColors.white, SigmaColors.white.withOpacity(0)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
