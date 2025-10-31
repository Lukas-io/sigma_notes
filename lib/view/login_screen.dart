import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_notes/core/router/routes.dart';
import 'package:sigma_notes/view/widgets/sigma_button.dart';
import 'package:sigma_notes/view/widgets/sigma_textfield.dart';

import '../core/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16),

          child: SafeArea(
            child: Column(
              children: [
                Text(
                  "sigma",
                  style: TextStyle(
                    color: SigmaColors.darkGreen,
                    fontSize: 52,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "A digital vault for wandering ideas🤸‍♂️",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 36),
                SigmaTextField(
                  label: "Username",
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                SigmaTextField(label: "Password", obscure: true),
                SizedBox(height: 24),
                SigmaButton(
                  child: Text(
                    "Start your Journey",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  onPressed: () {},
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () => context.go(SigmaRoutes.home),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: Text(
                      "Continue as a 👻",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
