import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sigma_notes/models/check_list_item.dart';

import '../../core/assets.dart';
import '../../core/colors.dart';

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

class NoteCheckListItem extends StatelessWidget {
  final CheckListItemModel model;
  final CheckListSize size;

  const NoteCheckListItem({
    super.key,
    required this.model,
    this.size = CheckListSize.small,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(size.padding),
      child: Row(
        spacing: size.spacing,
        children: [
          model.isChecked
              ? CircleAvatar(
                  radius: size.circleRadius - 0.5,
                  backgroundColor: SigmaColors.black,
                  child: Icon(
                    CupertinoIcons.checkmark_alt,
                    color: Colors.white,
                    size: size.iconSize,
                  ),
                )
              : SvgPicture.asset(
                  SigmaAssets.circleSvg,
                  width: size.circleRadius * 2,
                  height: size.circleRadius * 2,
                  colorFilter: ColorFilter.mode(
                    SigmaColors.gray,
                    BlendMode.srcIn,
                  ),
                ),
          // text
          Expanded(
            child: Text(
              model.title,
              maxLines: size != CheckListSize.small ? null : 1,
              overflow: size != CheckListSize.small
                  ? null
                  : TextOverflow.ellipsis,
              style: TextStyle(
                color: model.isChecked ? SigmaColors.black : SigmaColors.gray,
                fontSize: size.textSize,
                decoration: model.isChecked
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                height: 1.2,
                decorationThickness: 2,
                decorationColor: SigmaColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
