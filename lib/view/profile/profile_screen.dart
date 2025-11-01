import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sigma_notes/view/profile/device_info_widget.dart';
import 'package:sigma_notes/view/widgets/sigma_ink_well.dart';

import '../../core/assets.dart';
import '../../core/colors.dart';
import '../widgets/sigma_image.dart';
import '../widgets/svg_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              Text(
                "@SigmaLover",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              Container(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 6,
                    cornerSmoothing: 1,
                  ),
                  color: SigmaColors.black,
                ),
                child: Text(
                  "Ghost 👻",
                  style: TextStyle(
                    color: SigmaColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
