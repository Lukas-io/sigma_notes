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
        final isLoginRoute = state.matchedLocation == SigmaRoutes.login;

        // Not logged in → go to login
        if (!isLoggedIn && !isLoginRoute) {
          return SigmaRoutes.login;
        }

        // Logged in → avoid login page
        if (isLoggedIn && isLoginRoute) {
          return SigmaRoutes.home;
        }

        return null;
      },
      routes: SigmaRoutes.allRoutes,
      errorBuilder: (context, state) => const ErrorScreen(),
    );
  }
}
