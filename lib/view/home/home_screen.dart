import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/view/home/home_app_bar.dart';
import 'package:sigma_notes/view/home/home_search_bar.dart';
import 'package:sigma_notes/view/home/note_list_view.dart';
import 'package:sigma_notes/view/note/note_screen.dart';
import 'package:sigma_notes/view/widgets/svg_button.dart';

import '../../core/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: OpenContainer(
        closedElevation: 8,
        transitionType: ContainerTransitionType.fadeThrough,

        closedShape: const CircleBorder(),
        transitionDuration: const Duration(milliseconds: 450),
        closedColor: SigmaColors.white,
        openColor: SigmaColors.white,

        closedBuilder: (context, openContainer) => SvgButton(
          assetPath: SigmaAssets.plusSvg,
          size: 52,
          primary: true,
          onTap: openContainer,
        ),
        openBuilder: (context, _) => NoteScreen(
          NoteModel(
            id: 7,
            title: "Untitled document",
            content: "",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            userId: "user_id_123",
          ),
        ),
      ),
      body: Stack(
        alignment: AlignmentGeometry.topCenter,
        children: [
          SingleChildScrollView(
            padding: EdgeInsetsGeometry.symmetric(
              vertical: 12 + kToolbarHeight,
              horizontal: 16,
            ),
            child: SafeArea(
              child: Column(
                spacing: 16,
                children: [HomeSearchBar(), NoteListView(sampleNotes)],
              ),
            ),
          ),

          // Top gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        SigmaColors.white,
                        SigmaColors.white.withOpacity(0.85),
                        SigmaColors.white.withOpacity(0.75),
                        SigmaColors.white.withOpacity(0.5),
                        SigmaColors.white.withOpacity(0),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,

                    child: SizedBox(height: kToolbarHeight),
                  ),
                ),
              ),
            ),
          ),
          HomeAppBar(),
          // Bottom gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 2.5, sigmaX: 2.5),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        SigmaColors.white.withOpacity(1),
                        SigmaColors.white.withOpacity(0),
                      ],
                    ),
                  ),
                  child: SafeArea(top: false, child: SizedBox(height: 10)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
