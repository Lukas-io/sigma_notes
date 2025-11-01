import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_notes/core/router/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/providers/auth_provider.dart';
import '../../view/widgets/error.dart';

class SigmaRouter {
  SigmaRouter._();

  static GoRouter router(WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return GoRouter(
      initialLocation: SigmaRoutes.root,
      debugLogDiagnostics: kDebugMode,
      routerNeglect: kIsWeb,
      redirect: (context, state) {
        final isLoggedIn = authState.value != null;
        final isLoginRoute =
            state.matchedLocation == SigmaRoutes.login; // your login route path

        // Not logged in trying to access protected route
        if (!isLoggedIn && !isLoginRoute) {
          return SigmaRoutes.login;
        }

        // Logged in but on login screen
        if (isLoggedIn && isLoginRoute) {
          return SigmaRoutes.home; // your notes route path
        }

        return null;
      },
      routes: SigmaRoutes.allRoutes,
      errorBuilder: (context, state) => const ErrorScreen(),
    );
  }
}
