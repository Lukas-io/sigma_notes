import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_notes/core/router/router.dart';
import 'package:sigma_notes/core/theme.dart';

void main() {
  runApp(ProviderScope(child: const SigmaNotes()));
}

class SigmaNotes extends StatelessWidget {
  const SigmaNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme:SigmaTheme.appTheme,
     routerConfig: SigmaRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
