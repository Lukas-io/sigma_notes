import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_notes/core/router/routes.dart';

import '../../view/widgets/error.dart';

class SigmaRouter {
  SigmaRouter._();

  static final router = GoRouter(
    initialLocation: SigmaRoutes.root,
    debugLogDiagnostics: kDebugMode,
    routerNeglect: kIsWeb,
    redirect: (context, state) {

      return null;
    },
    routes: SigmaRoutes.allRoutes,
    errorBuilder: (context, state) => const ErrorScreen(),
  );
}
