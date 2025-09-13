import 'package:flutter/material.dart';

import '../../screens/auth/view/login_view.dart';
import '../../screens/splash_view/view/splash_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';
  static const String login = '/login';

  static final Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashView(),
    // home: (context) => const HomeScreen(),
    login: (context) => const LoginView(),
  };
}
