import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/core/colors.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/view/widgets/sigma_ink_well.dart';

class NoteScreenEditContent extends StatefulWidget {
  final NoteModel note;

  const NoteScreenEditContent(this.note, {super.key});

  @override
  State<NoteScreenEditContent> createState() => _NoteScreenEditContentState();
}

class _NoteScreenEditContentState extends State<NoteScreenEditContent> {
  late final TextEditingController titleEditingController;
  late final TextEditingController contentEditingController;

  @override
  void initState() {
    titleEditingController = TextEditingController(
      text: widget.note.title.trim(),
    );
    contentEditingController = TextEditingController(
      text: widget.note.content.trim(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 16),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: kToolbarHeight),
            TextField(
              controller: titleEditingController,
              maxLines: null,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: SigmaColors.gray, width: 0.5),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: SigmaColors.black, width: 0.5),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: SigmaColors.gray, width: 0.5),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: SigmaColors.gray, width: 0.5),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: SigmaColors.gray, width: 0.5),
                ),
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: SigmaColors.gray.withOpacity(0.3),
                    width: 0.5,
                  ),
                ),
                hintStyle: TextStyle(
                  color: SigmaColors.gray,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
                hintText: "Title",
                isDense: true,
              ),
              style: TextStyle(
                color: SigmaColors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
            SizedBox(height: 4),
            if (widget.note.label == null || (widget.note.label ?? "").isEmpty)
              SigmaInkwell(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4,
                    children: [
                      SvgPicture.asset(
                        SigmaAssets.plusSvg,
                        color: SigmaColors.gray,
                        height: 12,
                        width: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          "Add label",
                          style: TextStyle(
                            color: SigmaColors.gray,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            decorationColor: SigmaColors.gray,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Text(
                "${widget.note.label}",
                style: TextStyle(
                  color: SigmaColors.gray,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                  decorationColor: SigmaColors.gray,
                  height: 1.3,
                ),
              ),
            SizedBox(height: 20),
            TextField(
              controller: contentEditingController,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                hintStyle: TextStyle(color: SigmaColors.gray, fontSize: 16),
                hintText: "type some shit here",
                isDense: true,
              ),
              style: TextStyle(color: SigmaColors.black, fontSize: 16),
            ),

            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
