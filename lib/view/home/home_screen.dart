import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/core/router/routes.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/view/home/home_search_bar.dart';
import 'package:sigma_notes/view/home/note_list_view.dart';
import 'package:sigma_notes/view/profile/profile_screen.dart';
import 'package:sigma_notes/view/widgets/sigma_image.dart';
import 'package:sigma_notes/view/widgets/sigma_ink_well.dart';
import 'package:sigma_notes/view/widgets/svg_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        clipBehavior: Clip.none,
        title: Text(
          "My Notes",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        leadingWidth: 80,
        leading: SigmaInkwell(
          onTap: () => context.push(SigmaRoutes.profile),

          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Align(
              alignment: AlignmentGeometry.centerLeft,
              child: SigmaImage(
                assetPath: SigmaAssets.avatar1,
                fit: BoxFit.cover,
                height: 44,
                width: 44,
                borderRadius: BorderRadius.circular(360),
              ),
            ),
          ),
        ),
        actions: [
          SvgButton(assetPath: SigmaAssets.moreSvg),
          SizedBox(width: 16),
        ],
      ),
      floatingActionButton: SvgButton(
        assetPath: SigmaAssets.plusSvg,
        size: 52,
        primary: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsetsGeometry.symmetric(vertical: 12, horizontal: 16),
        child: SafeArea(
          child: Column(
            spacing: 16,
            children: [HomeSearchBar(), NoteListView(sampleNotes)],
          ),
        ),
      ),
    );
  }
}
