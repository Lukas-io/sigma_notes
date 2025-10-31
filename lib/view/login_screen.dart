import 'package:flutter/material.dart';

import '../core/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsGeometry.symmetric(vertical: 12, horizontal: 16),
          child: Column(

            children: [
            Text("sigma", style: TextStyle(color: SigmaColors.darkGreen, fontSize: 52, fontWeight: FontWeight.w800)),
            Text("A digital vault for wandering ideas", style: TextStyle(color: SigmaColors.darkGreen, fontSize: 52, fontWeight: FontWeight.w800)),
              TextField(),
              TextField()
          ],),
        ),
      ),
    );
  }
}
