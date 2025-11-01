import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_notes/core/colors.dart';
import 'package:sigma_notes/core/router/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) context.go(SigmaRoutes.login);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SigmaColors.lightGreenBackground,
      body: Center(
        child: Text(
          "sigma",
          style: TextStyle(
            color: SigmaColors.darkGreen,
            fontSize: 52,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
