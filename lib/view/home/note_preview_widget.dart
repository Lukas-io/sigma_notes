import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/core/colors.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/view/note/note_screen.dart';
import 'package:sigma_notes/view/widgets/sigma_image.dart';
import 'package:sigma_notes/view/widgets/sigma_ink_well.dart';
import 'package:sigma_notes/view/widgets/svg_button.dart';

class NotePreviewWidget extends StatelessWidget {
  final NoteModel note;

  const NotePreviewWidget(this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    return SigmaInkwell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoteScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 12,
            cornerSmoothing: 1,
          ),
          color: Colors.white,
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            // Locked Notes
            NotePreviewContent(note),
          ],
        ),
      ),
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
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.asset(SigmaAssets.avatar2).image,
              fit: BoxFit.cover,
              opacity: 0.2,
            ),
          ),
          height: 120,
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12),
            child: Row(
              spacing: 6,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 12,
                              child: SigmaImage(
                                assetPath: SigmaAssets.avatar1,
                                borderRadius: BorderRadius.circular(360),
                                width: 22,
                                height: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
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
                  if (false)
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
        children: [
          checkListItem(true, "Book and confirm the delivery"),
          checkListItem(false, "Arrange the decorations"),
        ],
      ),
    );
  }

  Widget checkListItem(bool isChecked, String title) {
    return Row(
      spacing: 6,
      children: [
        isChecked
            ? CircleAvatar(
                radius: 7,
                backgroundColor: SigmaColors.black,
                child: Icon(
                  CupertinoIcons.checkmark_alt,
                  color: Colors.white,
                  size: 10,
                ),
              )
            : SvgPicture.asset(
                SigmaAssets.circleSvg,
                width: 14,
                height: 14,

                colorFilter: ColorFilter.mode(
                  SigmaColors.gray,
                  BlendMode.srcIn,
                ),
              ),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isChecked ? SigmaColors.black : SigmaColors.gray,
              fontSize: 12,
              decoration: isChecked
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              decorationThickness: 2,
              decorationColor: SigmaColors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class NotePreviewChips extends StatelessWidget {
  final NoteModel note;

  const NotePreviewChips(this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        children: [
          //TODO: Tags....
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
              colorFilter: ColorFilter.mode(SigmaColors.white, BlendMode.srcIn),
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
          Container(
            decoration: BoxDecoration(
              color: SigmaColors.card,
              borderRadius: SmoothBorderRadius(
                cornerRadius: 8,
                cornerSmoothing: 1,
              ),
            ),
            padding: EdgeInsetsGeometry.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              "Work",
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
