import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_notes/core/router/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/providers/auth_provider.dart';
import '../../view/widgets/error.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return SigmaRouter.router(ref);
});

class SigmaRouter {
  SigmaRouter._();

  static GoRouter router(Ref ref) {
    final authState = ref.watch(authProvider);

    return GoRouter(
      initialLocation: SigmaRoutes.root,
      debugLogDiagnostics: kDebugMode,
      routerNeglect: kIsWeb,
      redirect: (context, state) {
        // Wait for authProvider to finish loading before redirecting
        final auth = authState;

        // If still loading, do not redirect anywhere
        if (auth.isLoading) return null;

        final isLoggedIn = auth.value != null;
        // Define public routes (accessible without login)
        final publicRoutes = [SigmaRoutes.root, SigmaRoutes.login];

        final isPublicRoute = publicRoutes.contains(state.matchedLocation);

        // Not logged in → block access to protected routes
        if (!isLoggedIn && !isPublicRoute) {
          return SigmaRoutes.login;
        }
        if (isLoggedIn && (state.matchedLocation == SigmaRoutes.login)) {
          return SigmaRoutes.home;
        }

        return null;
      },
      routes: SigmaRoutes.allRoutes,
      errorBuilder: (context, state) => const ErrorScreen(),
    );
  }
}
