import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_notes/core/router/router.dart';
import 'package:sigma_notes/core/theme.dart';

void main() {
  runApp(ProviderScope(child: const SigmaNotes()));
}

class SigmaNotes extends ConsumerWidget {
  const SigmaNotes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Sigma Notes',
      theme: SigmaTheme.appTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
