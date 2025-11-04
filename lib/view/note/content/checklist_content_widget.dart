import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sigma_notes/core/utils/note_utils.dart';
import 'package:sigma_notes/models/content/checklist.dart';
import 'package:sigma_notes/models/content/content_model.dart';
import 'package:sigma_notes/view/widgets/sigma/sigma_ink_well.dart';

import '../../../core/assets.dart';
import '../../../core/colors.dart';
import '../../../services/providers/focus_content_provider.dart';
import '../../../services/providers/note_editor_provider.dart';
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

class ChecklistContentWidget extends ConsumerStatefulWidget {
  final ChecklistContent content;
  final CheckListSize size;
  final int? maxLength;
  final String noteId;

  const ChecklistContentWidget(
    this.content, {
    super.key,
    this.maxLength,
    required this.noteId,
    this.size = CheckListSize.small,
  });

  @override
  ConsumerState<ChecklistContentWidget> createState() =>
      _ChecklistContentWidgetState();
}

class _ChecklistContentWidgetState
    extends ConsumerState<ChecklistContentWidget> {
  late ChecklistContent content;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    content = widget.content;
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      final focusNotifier = ref.read(focusedContentStateProvider.notifier);
      if (_focusNode.hasFocus) {
        focusNotifier.focus(widget.content.id);
      } else {
        focusNotifier.unfocus(widget.content.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: content.items.map((item) {
        return ChecklistItemContentWidget(
          item,
          size: widget.size,
          onChanged: (updatedItem, saveNow) {
            // Replace the changed item in the list
            final updatedItems = content.items.map((i) {
              return i == item ? updatedItem : i;
            }).toList();

            // Create new updated content
            final updatedContent = content.copyWith(items: updatedItems);

            // // Update local state and notify provider
            // setState(() => content = updatedContent);
            ref
                .read(noteEditorProvider(widget.noteId).notifier)
                .updateContent(
                  content.id,
                  updatedContent,
                  showSaveNow: saveNow,
                );
          },
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}

class ChecklistItemContentWidget extends ConsumerStatefulWidget {
  final ChecklistItem item;
  final CheckListSize size;
  final Function(ChecklistItem item, bool saveNow)? onChanged;

  const ChecklistItemContentWidget(
    this.item, {
    super.key,
    this.size = CheckListSize.small,
    this.onChanged,
  });

  @override
  ConsumerState<ChecklistItemContentWidget> createState() =>
      _ChecklistItemContentWidgetState();
}

class _ChecklistItemContentWidgetState
    extends ConsumerState<ChecklistItemContentWidget> {
  late final TextEditingController contentEditingController;
  late final String hintText;
  late ChecklistItem item;
  late bool checked;

  @override
  void initState() {
    item = widget.item;
    checked = widget.item.checked;
    contentEditingController = TextEditingController(
      text: widget.item.text.trim(),
    );
    hintText = NoteUtils.getFunnyHintForType(ContentType.checklist);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(noteModeStateProvider);

    return IgnorePointer(
      ignoring: widget.size == CheckListSize.small,
      child: SigmaInkwell(
        onTap: widget.size == CheckListSize.small || mode == NoteMode.edit
            ? null
            : () {
                checked = !checked;

                if (widget.onChanged != null) {
                  item = item.copyWith(checked: checked);
                  widget.onChanged!(item, true);
                }
                setState(() {});
              },
        child: Padding(
          padding: EdgeInsets.all(widget.size.padding),
          child: Row(
            spacing: widget.size.spacing,
            children: [
              checked
                  ? CircleAvatar(
                      radius: widget.size.circleRadius,
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
                  child:
                      mode == NoteMode.view ||
                          widget.size == CheckListSize.small
                      ? Align(
                          alignment: AlignmentGeometry.topLeft,
                          child: Text(
                            item.text,
                            maxLines: widget.size != CheckListSize.small
                                ? null
                                : 1,

                            style: TextStyle(
                              overflow: widget.size != CheckListSize.small
                                  ? null
                                  : TextOverflow.ellipsis,
                              color: checked
                                  ? SigmaColors.gray
                                  : SigmaColors.black,
                              fontSize: widget.size.textSize,
                              decoration: checked
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
                          onChanged: (value) {
                            item = widget.item.copyWith(text: value);
                            if (widget.onChanged != null) {
                              widget.onChanged!(item, false);
                            }
                          },
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
                            hintText: hintText,
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
        ),
      ),
    );
  }
}
