import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_notes/core/router/routes.dart';
import '../../services/providers/auth_provider.dart';
import '../../view/widgets/error.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return SigmaRouter.router(ref);
});

class SigmaRouter {
  SigmaRouter._();

  static GoRouter router(Ref ref) {
    // Use a variable to hold the latest auth state
    AsyncValue? latestAuthState;

    // Listen for authProvider changes (instead of watch)
    ref.listen<AsyncValue>(authProvider, (previous, next) {
      latestAuthState = next;
    });

    return GoRouter(
      initialLocation: SigmaRoutes.root,
      debugLogDiagnostics: kDebugMode,
      routerNeglect: kIsWeb,

      // Use redirect to handle login/logout logic
      redirect: (context, state) {
        final auth = latestAuthState;

        // If we haven't gotten auth state yet → stay put
        if (auth == null || auth.isLoading) return null;

        final isLoggedIn = auth.value != null;

        // Define public routes (accessible without login)
        final publicRoutes = [SigmaRoutes.root, SigmaRoutes.login];

        final isPublicRoute = publicRoutes.contains(state.matchedLocation);

        // Not logged in → redirect to login
        if (!isLoggedIn && !isPublicRoute) {
          return SigmaRoutes.login;
        }

        // Logged in but trying to access login → go home
        if (isLoggedIn && state.matchedLocation == SigmaRoutes.login) {
          return SigmaRoutes.home;
        }

        // Otherwise, no redirect
        return null;
      },

      routes: SigmaRoutes.allRoutes,
      errorBuilder: (context, state) => const ErrorScreen(),
    );
  }
}
