import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/core/colors.dart';
import 'package:sigma_notes/view/widgets/sigma_ink_well.dart';
import 'package:sigma_notes/view/widgets/svg_button.dart';
import 'package:sprung/sprung.dart';

enum NoteBarType { minimal, standard, text, draw, layout, details }

class NoteBottomBar extends StatelessWidget {
  final NoteBarType type;

  const NoteBottomBar({super.key, this.type = NoteBarType.details});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.widthOf(context) - 32),
      child: Material(
        elevation: 30,
        color: SigmaColors.white.withOpacity(0),
        shadowColor: SigmaColors.white.withOpacity(0.2),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: SigmaColors.card),
            color: Colors.white,
            borderRadius: SmoothBorderRadius(
              cornerRadius: 12,
              cornerSmoothing: 1,
            ),
          ),

          child: AnimatedSize(
            duration: 800.ms,
            curve: Sprung(28),
            clipBehavior: Clip.none,
            child: AnimatedSwitcher(
              duration: 150.ms,
              switchInCurve: Sprung(28),
              switchOutCurve: Sprung(28),
              child: switch (type) {
                NoteBarType.standard => _StandardBar(),
                NoteBarType.text => _TextBar(),
                NoteBarType.draw => _DrawBar(),
                NoteBarType.layout => _LayoutBar(),
                NoteBarType.details => _DetailsBar(),
                NoteBarType.minimal => _MinimalBar(),
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------- Bar Widgets -------------------

class _StandardBar extends StatelessWidget {
  const _StandardBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.standardDrawSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.standardCheckSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.standardLayoutSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.standardTextSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.standardCommandSvg,
            filled: false,
          ),
        ],
      ).animate().fadeIn(duration: 1000.ms, curve: Curves.easeOut),
    );
  }
}

class _TextBar extends StatelessWidget {
  const _TextBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
        ],
      ).animate().fadeIn(duration: 1000.ms, curve: Curves.easeOut),
    );
  }
}

class _DrawBar extends StatelessWidget {
  const _DrawBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
        ],
      ).animate().fadeIn(duration: 1000.ms, curve: Curves.easeOut),
    );
  }
}

class _LayoutBar extends StatelessWidget {
  const _LayoutBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
        ],
      ).animate().fadeIn(duration: 1000.ms, curve: Curves.easeOut),
    );
  }
}

class _DetailsBar extends StatelessWidget {
  const _DetailsBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {},
            assetPath: SigmaAssets.detailsSvg,
            filled: false,
          ),
        ],
      ).animate().fadeIn(duration: 1000.ms, curve: Curves.easeOut),
    );
  }
}

class _MinimalBar extends StatelessWidget {
  const _MinimalBar();

  @override
  Widget build(BuildContext context) {
    return SigmaInkwell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Details", style: TextStyle()),
            SvgPicture.asset(SigmaAssets.detailsSvg, width: 16, height: 16),
          ],
        ).animate().fadeIn(duration: 1000.ms, curve: Curves.easeOut),
      ),
    );
  }
}
