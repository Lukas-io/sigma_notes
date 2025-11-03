import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/view/widgets/svg_button.dart';

import '../../core/router/routes.dart';
import '../../services/providers/auth_provider.dart';
import '../widgets/sigma_image.dart';
import '../widgets/sigma_ink_well.dart';

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRect(
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                SigmaInkwell(
                  onTap: () => context.push(SigmaRoutes.profile),

                  child: SigmaImage(
                    assetPath:
                        ref
                            .read(authProvider.notifier)
                            .getCurrentUser()
                            ?.profilePicture ??
                        SigmaAssets.avatar1,
                    fit: BoxFit.cover,
                    height: 44,
                    width: 44,
                    borderRadius: BorderRadius.circular(360),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "My Notes",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SvgButton(assetPath: SigmaAssets.moreSvg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
