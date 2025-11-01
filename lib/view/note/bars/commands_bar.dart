import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sigma_notes/core/colors.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/view/widgets/sigma_ink_well.dart';

import '../../../core/assets.dart';

class CommandsBar extends StatelessWidget {
  final NoteModel note;

  const CommandsBar(this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> commands = [
      Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          bottom: 8.0,
          top: 2,
        ),
        child: Row(
          spacing: 12,
          children: [
            Expanded(
              child: CommandsRowButton(
                title: 'Image',
                assetPath: SigmaAssets.soundWaveSvg,
              ),
            ),
            Expanded(
              child: CommandsRowButton(
                title: 'Voice',
                assetPath: SigmaAssets.soundWaveSvg,
              ),
            ),
            Expanded(
              child: CommandsRowButton(
                title: 'Share',
                assetPath: SigmaAssets.soundWaveSvg,
              ),
            ),
          ],
        ),
      ),
      CommandsListItem(title: 'Pin', leading: SigmaAssets.pinSvg),
      CommandsListItem(title: 'Add thumbnail', leading: SigmaAssets.pinSvg),
      CommandsListItem(
        title: 'Label',
        leading: SigmaAssets.pinSvg,
        disclosureLabel: "Work",
        isDisclosure: true,
      ),
      CommandsListItem(
        title: 'Send',
        leading: SigmaAssets.pinSvg,
        isDisclosure: true,
      ),
      CommandsListItem(title: 'Make a copy', leading: SigmaAssets.pinSvg),
      CommandsListItem(title: 'Lock note', leading: SigmaAssets.pinSvg),
      CommandsListItem(
        title: 'Delete note',
        leading: SigmaAssets.pinSvg,
        isDestructive: true,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 4, right: 4),
        child: Text(
          "Last edited ${note.formattedDateTime} by ${note.userId}",
          textAlign: TextAlign.center,
          style: TextStyle(color: SigmaColors.gray, fontSize: 12),
        ),
      ),
    ];

    return ListView.separated(
      itemCount: commands.length,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 16.0),

      itemBuilder: (context, index) => commands[index],
      separatorBuilder: (context, index) =>
          const Divider(color: SigmaColors.gray, thickness: 0.25),
    ).animate().fadeIn(duration: 1000.ms, curve: Curves.easeOut);
  }
}

class CommandsRowButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String assetPath;

  const CommandsRowButton({
    super.key,
    this.onTap,
    required this.title,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return SigmaInkwell(
      child: Container(
        padding: EdgeInsetsGeometry.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: SigmaColors.card,
          borderRadius: SmoothBorderRadius(
            cornerRadius: 12,
            cornerSmoothing: 1,
          ),
        ),
        child: Column(
          spacing: 4,
          children: [
            SvgPicture.asset(assetPath, width: 30, height: 30),
            Text(title),
          ],
        ),
      ),
    );
  }
}

class CommandsListItem extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String leading;
  final bool isDestructive;
  final bool isDisclosure;
  final String disclosureLabel;

  const CommandsListItem({
    super.key,
    this.onTap,
    required this.title,
    required this.leading,
    this.isDestructive = false,
    this.isDisclosure = false,
    this.disclosureLabel = "",
  });

  @override
  Widget build(BuildContext context) {
    return SigmaInkwell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 24),
        child: Row(
          spacing: 12,
          children: [
            SvgPicture.asset(
              leading,
              color: isDestructive ? CupertinoColors.destructiveRed : null,
              width: 18,
              height: 18,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isDestructive ? CupertinoColors.destructiveRed : null,
                ),
              ),
            ),
            Text(disclosureLabel, style: TextStyle(color: SigmaColors.gray)),
            if (isDisclosure)
              SvgPicture.asset(SigmaAssets.frontSvg, width: 18, height: 18),
          ],
        ),
      ),
    );
  }
}
