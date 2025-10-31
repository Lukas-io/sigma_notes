import 'package:flutter/material.dart';
import 'package:sigma_notes/view/note/note_app_bar.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [NoteAppBar()])),
    );
  }
}
