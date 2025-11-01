import 'dart:developer';
import 'dart:ui';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/core/colors.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/view/note/note_screen.dart';
import 'package:sigma_notes/view/widgets/collaborator_widget.dart';
import 'package:sigma_notes/view/widgets/svg_button.dart';
import 'package:animations/animations.dart';

import '../../services/providers/biometrics_provider.dart';
import '../note/note_check_list_item.dart';

class NotePreviewWidget extends ConsumerStatefulWidget {
  final NoteModel note;

  const NotePreviewWidget(this.note, {super.key});

  @override
  ConsumerState<NotePreviewWidget> createState() => _NotePreviewWidgetState();
}

class _NotePreviewWidgetState extends ConsumerState<NotePreviewWidget> {
  @override
  Widget build(BuildContext context) {
    final note = widget.note;
    return OpenContainer(
      transitionDuration: Duration(milliseconds: 300),
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (context, _) => NoteScreen(note),
      closedElevation: 1,
      openShape: const SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius.all(
          SmoothRadius(cornerRadius: 12, cornerSmoothing: 1),
        ),
      ),
      openColor: SigmaColors.white,
      openElevation: 0,
      closedShape: const SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius.all(
          SmoothRadius(cornerRadius: 12, cornerSmoothing: 1),
        ),
      ),
      closedColor: SigmaColors.white,
      closedBuilder: (context, openContainer) {
        return GestureDetector(
          onTap: () async {
            if (note.locked) {
              // Read LocalAuthentication directly - it's keepAlive so won't dispose
              final auth = ref.read(localAuthProvider);

              // Use the service directly - no provider lifecycle issues
              final result = await BiometricService.authenticate(
                auth: auth,
                localizedReason: 'Unlock your Note',
              );

              // Check if widget is still mounted after async gap
              if (!mounted) return;

              log(result.toString());
              if (result.success) {
                openContainer();
              }
            } else {
              openContainer();
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: SmoothBorderRadius.all(
                SmoothRadius(cornerRadius: 12, cornerSmoothing: 1),
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                NotePreviewContent(note),
                if (note.locked)
                  //Locked Notes
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        color: SigmaColors.white.withOpacity(0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 4,
                          children: [
                            SvgPicture.asset(
                              SigmaAssets.lockSvg,
                              width: 40,
                              height: 40,
                            ),
                            Text(
                              "Locked",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NotePreviewContent extends StatelessWidget {
  final NoteModel note;

  const NotePreviewContent(this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: note.imagePath == null
              ? null
              : BoxDecoration(
                  image: DecorationImage(
                    image: Image.asset(note.imagePath!).image,
                    fit: BoxFit.cover,
                    opacity: 0.2,
                  ),
                ),
          height: note.imagePath == null ? null : 120,
          alignment: Alignment.topCenter,
          child: !(note.collaborators || note.isPinned)
              ? SizedBox(height: 4)
              : Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    right: 12.0,
                    top: 12,
                  ),
                  child: Row(
                    spacing: 6,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            if (note.collaborators)
                              Expanded(child: CollaboratorWidget()),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2.0,
                              ),
                              child: SvgButton(
                                assetPath: SigmaAssets.pinSvg,
                                filled: false,
                                iconSize: 20,
                                iconColor: SigmaColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SvgButton(
                        assetPath: SigmaAssets.moreVerticalSvg,
                        filled: false,
                        iconSize: 20,
                        iconColor: SigmaColors.gray,
                        onTap: () {
                          print("object");
                        },
                      ),
                    ],
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: SigmaColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (!(note.isPinned || note.collaborators))
                    Transform.translate(
                      offset: Offset(8, 0),

                      child: SvgButton(
                        assetPath: SigmaAssets.moreVerticalSvg,
                        filled: false,
                        iconSize: 20,
                        iconColor: SigmaColors.gray,
                        onTap: () {
                          print("object");
                        },
                      ),
                    ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                note.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: SigmaColors.gray,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              NoteCheckList(note),
              Text(".....", style: TextStyle(height: 1)),
              NotePreviewChips(note),
              SizedBox(height: 12),
              Text(
                note.formattedDate,
                style: TextStyle(
                  color: SigmaColors.gray,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NoteCheckList extends StatelessWidget {
  final NoteModel note;

  const NoteCheckList(this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        spacing: 4,
        children: note.checkList
            .map((model) => NoteCheckListItem(model: model))
            .toList(),
      ),
    );
  }
}

class NotePreviewChips extends StatelessWidget {
  final NoteModel note;

  const NotePreviewChips(this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    if (note.voiceNotes.isEmpty && note.label == null) return SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        children: [
          //TODO: Tags....
          if (note.voiceNotes.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: SigmaColors.black,
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 8,
                  cornerSmoothing: 1,
                ),
              ),
              padding: EdgeInsetsGeometry.all(4),
              child: SvgPicture.asset(
                SigmaAssets.soundWaveSvg,
                height: 18,
                width: 18,
                colorFilter: ColorFilter.mode(
                  SigmaColors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          // Container(
          //   decoration: BoxDecoration(
          //     color: SigmaColors.black,
          //     borderRadius: SmoothBorderRadius(
          //       cornerRadius: 8,
          //       cornerSmoothing: 1,
          //     ),
          //   ),
          //   padding: EdgeInsetsGeometry.symmetric(horizontal: 12, vertical: 6),
          //   child: Text(
          //     "Personal",
          //     style: TextStyle(
          //       fontSize: 10,
          //       color: SigmaColors.white,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
          if (note.label != null)
            Container(
              decoration: BoxDecoration(
                color: SigmaColors.card,
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 8,
                  cornerSmoothing: 1,
                ),
              ),
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              child: Text(
                note.label!,
                style: TextStyle(
                  fontSize: 10,
                  color: SigmaColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
