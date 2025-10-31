import 'package:go_router/go_router.dart';

import '../../view/home_screen.dart';
import '../../view/login_screen.dart';
import '../../view/splash_screen.dart';


class SigmaRoutes {
  SigmaRoutes._();

  static const String root = "/";

  static const String login = "/login";

  static const String home = "/home";

  static bool isAuth(String route) {
    return route == root ||
        route == login;
  }

  static final List<RouteBase> allRoutes = [
    GoRoute(path: root, builder: (context, state) => const SplashScreen()),

    GoRoute(path: login, builder: (context, state) => const LoginScreen()),

    GoRoute(path: home, builder: (context, state) => const HomeScreen()),
  ];
}
