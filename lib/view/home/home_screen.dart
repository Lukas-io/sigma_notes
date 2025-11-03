import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/models/content/content_model.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/view/home/home_app_bar.dart';
import 'package:sigma_notes/view/home/home_search_bar.dart';
import 'package:sigma_notes/view/home/note_list_view.dart';
import 'package:sigma_notes/view/note/note_screen.dart';
import 'package:sigma_notes/view/widgets/svg_button.dart';
import 'package:uuid/uuid.dart';

import '../../core/colors.dart';
import '../../services/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            title: "Untitled",
            contents: [TextContent(order: 0, text: "")],
            collaborators: [],
            userId:
                ref.read(authProvider.notifier).getCurrentUser()?.id ??
                Uuid().v4(),
          ),
          mode: NoteMode.edit,
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
                children: [
                  HomeSearchBar(onChanged: (query) {}),
                  NoteListView(),
                ],
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
