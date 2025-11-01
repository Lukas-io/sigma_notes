import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sigma_notes/view/profile/device_info_widget.dart';
import 'package:sigma_notes/view/widgets/sigma_ink_well.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/assets.dart';
import '../../core/colors.dart';
import '../../core/router/routes.dart';
import '../../services/providers/auth_provider.dart';
import '../../models/user.dart';
import '../widgets/sigma_image.dart';
import '../widgets/svg_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the auth provider for user data
    final userAsync = ref.watch(authProvider);
    
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        elevation: 3,

        actions: [
          SvgButton(
            assetPath: SigmaAssets.editSvg,
            primary: true,
            shadows: [
              BoxShadow(
                spreadRadius: 12,
                color: SigmaColors.card.withOpacity(0.5),
                blurRadius: 12,
              ),
            ],
            onTap: () {},
          ),
          SizedBox(width: 16),
        ],
        surfaceTintColor: SigmaColors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: AlignmentGeometry.centerLeft,
            child: SvgButton(
              assetPath: SigmaAssets.backSvg,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 12),
        child: SafeArea(
          child: Column(
            children: [
              SigmaImage(
                assetPath: SigmaAssets.avatar1,
                fit: BoxFit.cover,
                height: 150,
                width: 150,
                borderRadius: BorderRadius.circular(360),
              ),
              SizedBox(height: 12),
              // Display username or email
              userAsync.when(
                data: (user) {
                  if (user != null) {
                    return Text(
                      user.username.isNotEmpty ? "@${user.username}" : user.email,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    );
                  }
                  return Text(
                    "@UnknownUser",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  );
                },
                loading: () => Text(
                  "Loading...",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
                error: (error, stack) => Text(
                  "Error loading user",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.red),
                ),
              ),
              // Conditionally show the Ghost tag
              userAsync.when(
                data: (user) {
                  if (user != null && user.isGuest) {
                    return Container(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 6,
                          cornerSmoothing: 1,
                        ),
                        color: SigmaColors.card,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            SigmaAssets.ghostSvg,
                            color: SigmaColors.black,
                            width: 18,
                            height: 18,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              "Ghost",
                              style: TextStyle(
                                color: SigmaColors.black,
                                fontWeight: FontWeight.w500,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
                loading: () => SizedBox.shrink(),
                error: (error, stack) => SizedBox.shrink(),
              ),
              SizedBox(height: 32),

              SigmaInkwell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Claim Account", style: TextStyle()),
                      Spacer(),
                      SvgPicture.asset(SigmaAssets.frontSvg),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 8,
                color: SigmaColors.gray,
                thickness: 0.2,
                endIndent: 4,
                indent: 4,
              ),

              SigmaInkwell(
                onTap: () async {
                  // Call logout from AuthProvider
                  await ref.read(authProvider.notifier).logout();
                  // Navigate to login screen
                  if (context.mounted) {
                    context.go(SigmaRoutes.login);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Log out",
                        style: TextStyle(color: CupertinoColors.destructiveRed),
                      ),
                      Spacer(),
                      SvgPicture.asset(
                        SigmaAssets.logoutSvg,
                        color: CupertinoColors.destructiveRed,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),
              //Device info
              DeviceInfoWidget(),
            ],
          ),
        ),
      ),
    );
  }
}