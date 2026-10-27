import 'package:flutter/material.dart';

import '../models/models.dart';
import '../pages/edit_profile_page.dart';
import '../pages/not_found_page.dart';
import '../pages/profile_page.dart';
import '../pages/project_detail_page.dart';
import '../pages/splash_page.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.splash:
        return _build(const SplashPage(), settings);

      case AppRoutes.profile:
        return _build(const ProfilePage(), settings);

      case AppRoutes.projectDetail:
        if (args is Project) {
          return _build(ProjectDetailPage(project: args), settings);
        }
        return _build(const NotFoundPage(), settings);

      case AppRoutes.editProfile:
        if (args is Profile) {
          return _build<Profile?>(EditProfilePage(profile: args), settings);
        }
        return _build(const NotFoundPage(), settings);

      default:
        return _build(const NotFoundPage(), settings);
    }
  }

  static MaterialPageRoute<T> _build<T>(Widget page, RouteSettings settings) =>
      MaterialPageRoute<T>(builder: (_) => page, settings: settings);
}
