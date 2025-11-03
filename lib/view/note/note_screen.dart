import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_notes/services/providers/note_mode_provider.dart';
import 'package:sigma_notes/view/note/note_app_bar.dart';
import 'package:sigma_notes/view/note/note_bottom_bar.dart';
import 'package:sigma_notes/view/note/note_screen_content.dart';
import 'package:sigma_notes/services/providers/note_bar_provider.dart';

import '../../core/colors.dart';
import '../../services/providers/note_editor_provider.dart';

enum NoteMode { view, edit }

class NoteScreen extends ConsumerStatefulWidget {
  final String id;
  final NoteMode mode;

  const NoteScreen(this.id, {super.key, this.mode = NoteMode.view});

  @override
  ConsumerState<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends ConsumerState<NoteScreen> {
  @override
  void initState() {
    super.initState();

    // Schedule after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(noteModeStateProvider.notifier).setMode(widget.mode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final noteAsync = ref.watch(noteEditorProvider(widget.id));
    final barType = ref.watch(noteBarTypeStateProvider);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: AlignmentGeometry.topCenter,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,

                  child: noteAsync.when(
                    data: (note) => Align(
                      alignment: AlignmentGeometry.topLeft,
                      child: NoteScreenContent(note, key: ValueKey(note.id)),
                    ),
                    loading: () => const Center(
                      key: ValueKey('note-content-loading'),
                      child: CircularProgressIndicator.adaptive(
                        strokeWidth: 2.5,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    error: (e, st) {
                      log('Error loading note: $e');
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(
                          key: ValueKey('note-content-error'),
                          child: Text('Error loading note: $e'),
                        ),
                      );
                    },
                  ),
                ),
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
                NoteAppBar(widget.id),
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
                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: barType != NoteBarType.commands,

                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      opacity: barType != NoteBarType.commands ? 0.0 : 1,
                      curve: Curves.easeOut,
                      child: GestureDetector(
                        onTap: () {
                          ref
                              .read(noteBarTypeStateProvider.notifier)
                              .setBarType(
                                ref.read(noteModeStateProvider) == NoteMode.view
                                    ? NoteBarType.minimal
                                    : NoteBarType.edit,
                              );
                        },
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaY: 6, sigmaX: 6),
                          child: Container(
                            color: SigmaColors.black.withOpacity(0.35),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  child: SafeArea(child: NoteBottomBar(widget.id)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
