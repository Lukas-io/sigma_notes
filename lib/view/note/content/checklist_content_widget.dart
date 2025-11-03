import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sigma_notes/models/content/checklist.dart';

import '../../../core/assets.dart';
import '../../../core/colors.dart';
import '../../../services/providers/note_mode_provider.dart';
import '../note_screen.dart';

enum CheckListSize {
  small(spacing: 6, circleRadius: 7, iconSize: 10, textSize: 13, padding: 0),
  normal(spacing: 12, circleRadius: 10, iconSize: 14, textSize: 16, padding: 2),
  large(spacing: 12, circleRadius: 10, iconSize: 12, textSize: 18, padding: 4);

  final double spacing;
  final double circleRadius;
  final double iconSize;
  final double padding;
  final double textSize;

  const CheckListSize({
    required this.spacing,
    required this.circleRadius,
    required this.padding,
    required this.iconSize,
    required this.textSize,
  });
}

class ChecklistContentWidget extends StatelessWidget {
  final ChecklistContent content;
  final CheckListSize size;
  final int? maxLength;

  const ChecklistContentWidget(
    this.content, {
    super.key,
    this.maxLength,
    this.size = CheckListSize.small,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: content.items.map((item) {
        return ChecklistItemContentWidget(item, size: size);
      }).toList(),
    );
  }
}

class ChecklistItemContentWidget extends ConsumerStatefulWidget {
  final ChecklistItem item;
  final CheckListSize size;

  const ChecklistItemContentWidget(
    this.item, {
    super.key,
    this.size = CheckListSize.small,
  });

  @override
  ConsumerState<ChecklistItemContentWidget> createState() =>
      _ChecklistItemContentWidgetState();
}

class _ChecklistItemContentWidgetState
    extends ConsumerState<ChecklistItemContentWidget> {
  late final TextEditingController contentEditingController;

  @override
  void initState() {
    contentEditingController = TextEditingController(
      text: widget.item.text.trim(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(noteModeStateProvider);

    return Padding(
      padding: EdgeInsets.all(widget.size.padding),
      child: Row(
        spacing: widget.size.spacing,
        children: [
          widget.item.checked
              ? CircleAvatar(
                  radius: widget.size.circleRadius - 0.5,
                  backgroundColor: SigmaColors.black,
                  child: Icon(
                    CupertinoIcons.checkmark_alt,
                    color: Colors.white,
                    size: widget.size.iconSize,
                  ),
                )
              : SvgPicture.asset(
                  SigmaAssets.circleSvg,
                  width: widget.size.circleRadius * 2,
                  height: widget.size.circleRadius * 2,
                  colorFilter: ColorFilter.mode(
                    SigmaColors.gray,
                    BlendMode.srcIn,
                  ),
                ),
          // text
          Expanded(
            child: AnimatedSize(
              duration: Duration(milliseconds: 250),
              clipBehavior: Clip.none,
              curve: Curves.easeOut,
              alignment: AlignmentGeometry.topLeft,
              child: mode == NoteMode.view
                  ? Align(
                      alignment: AlignmentGeometry.topLeft,
                      child: SelectableText(
                        widget.item.text,
                        maxLines: widget.size != CheckListSize.small ? null : 1,

                        style: TextStyle(
                          overflow: widget.size != CheckListSize.small
                              ? null
                              : TextOverflow.ellipsis,
                          color: widget.item.checked
                              ? SigmaColors.black
                              : SigmaColors.gray,
                          fontSize: widget.size.textSize,
                          decoration: widget.item.checked
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          height: 1.2,
                          letterSpacing: 0.3,

                          decorationThickness: 2,
                          decorationColor: SigmaColors.black,
                        ),
                      ),
                    )
                  : TextField(
                      controller: contentEditingController,
                      maxLines: null,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsetsGeometry.symmetric(
                          vertical: 0,
                        ),

                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        hintStyle: TextStyle(
                          color: SigmaColors.gray,
                          fontSize: 16,
                        ),
                        hintText: "task vibes only",
                        isDense: true,
                      ),
                      style: TextStyle(
                        color: SigmaColors.black,
                        fontSize: widget.size.textSize,
                        letterSpacing: 0.3,
                        height: 1.2,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
