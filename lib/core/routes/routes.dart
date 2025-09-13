import 'package:flutter/material.dart';

import '../../screens/auth/view/login_view.dart';
import '../../screens/home/view/home_view.dart';
import '../../screens/register/view/register_view.dart';
import '../../screens/splash_view/view/splash_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';

  static final Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashView(),
    login: (context) => const LoginView(),
    home: (context) => const HomeView(),
    register: (context) => const RegisterView(),
    //RegisterView
  };
}
