import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_notes/core/utils/username_generator.dart';
import 'package:sigma_notes/models/collaborator.dart';
import 'package:sigma_notes/services/providers/note_editor_provider.dart';
import 'package:sigma_notes/view/widgets/sigma/sigma_image.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sprung/sprung.dart';

class CollaboratorWidget extends ConsumerWidget {
  // final List<Collaborator> collaborators;
  final double size;
  final String noteId;

  const CollaboratorWidget({
    super.key,
    this.size = 20,
    required this.noteId,
    // required this.collaborators,
  });

  @override
  Widget build(BuildContext context, ref) {
    final double avatarRadius = 0.6 * size;
    final double avatarSize = size;
    final double overlap = size / 4;

    final collabs =
        ref.watch(noteEditorProvider(noteId)).value?.collaborators ?? [];

    // Take last 3 collaborators and reverse so the latest is first
    final recentCollabs = collabs.length <= 3
        ? collabs.reversed.toList()
        : collabs.sublist(collabs.length - 3).reversed.toList();
    return SizedBox(
      width:
          avatarSize + 2 * (avatarSize - overlap) * (recentCollabs.length / 3),
      // total width for 3 avatars
      height: avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: List.generate(recentCollabs.length, (index) {
          final collab = recentCollabs[index];

          return Positioned(
            left: index * (avatarSize - overlap),
            child:
                CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: avatarRadius,
                      child: SigmaImage(
                        assetPath: collab.profileImageUrl,
                        borderRadius: BorderRadius.circular(360),
                        width: avatarSize,
                        height: avatarSize,
                      ),
                    )
                    .animate()
                    .then(delay: (200 + index * 100).ms)
                    .slideX(
                      begin: 1,
                      curve: Sprung(32),
                      duration: (750 + index * 150).ms,
                    )
                    .fade(duration: 400.ms, curve: Curves.easeOut)
                    .blur(
                      begin: const Offset(5, 5),
                      end: Offset.zero,
                      curve: Curves.easeOut,
                    ),
          );
        }),
      ),
    );
  }
}
