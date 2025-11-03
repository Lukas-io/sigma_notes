import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sigma_notes/models/collaborator.dart';
import 'package:sigma_notes/view/widgets/sigma/sigma_image.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sprung/sprung.dart';

class CollaboratorWidget extends StatelessWidget {
  final List<Collaborator> collaborators;
  final double size;

  const CollaboratorWidget({
    super.key,
    this.size = 20,
    this.collaborators = const [],
  });

  @override
  Widget build(BuildContext context) {
    final double avatarRadius = 0.6 * size;
    final double avatarSize = size;
    final double overlap = size / 4;

    return SizedBox(
      width: avatarSize + 2 * (avatarSize - overlap), // total width
      height: avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentGeometry.centerLeft,
        children: [
          Positioned(
            left: 0,
            child:
                CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: avatarRadius,
                      child: SigmaImage(
                        assetPath: SigmaAssets.avatar1,
                        borderRadius: BorderRadius.circular(360),
                        width: avatarSize,
                        height: avatarSize,
                      ),
                    )
                    .animate()
                    .then(delay: 200.ms)
                    .slideX(begin: 1, curve: Sprung(32), duration: 750.ms)
                    .fade(duration: 400.ms, curve: Curves.easeOut)
                    .blur(
                      begin: Offset(5, 5),
                      end: Offset.zero,
                      curve: Curves.easeOut,
                    ),
          ),
          Positioned(
            left: avatarSize - overlap,
            child:
                CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: avatarRadius,
                      child: SigmaImage(
                        assetPath: SigmaAssets.avatar2,
                        borderRadius: BorderRadius.circular(360),
                        width: avatarSize,
                        height: avatarSize,
                      ),
                    )
                    .animate()
                    .then(delay: 300.ms)
                    .slideX(begin: 1, curve: Sprung(32), duration: 900.ms)
                    .fade(duration: 400.ms, curve: Curves.easeOut)
                    .blur(
                      begin: Offset(5, 5),
                      end: Offset.zero,
                      curve: Curves.easeOut,
                    ),
          ),
          Positioned(
            left: 2 * (avatarSize - overlap),
            child:
                CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: avatarRadius,
                      child: SigmaImage(
                        assetPath: SigmaAssets.avatar3,
                        borderRadius: BorderRadius.circular(360),
                        width: avatarSize,
                        height: avatarSize,
                      ),
                    )
                    .animate()
                    .then(delay: 400.ms)
                    .slideX(begin: 1, curve: Sprung(32), duration: 1200.ms)
                    .fade(duration: 400.ms, curve: Curves.easeOut)
                    .blur(
                      begin: Offset(5, 5),
                      end: Offset.zero,
                      curve: Curves.easeOut,
                    ),
          ),
        ],
      ),
    );
  }
}
