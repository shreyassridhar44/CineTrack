import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/movie_detail_screen.dart';
import '../../presentation/screens/signup_screen.dart'; // <-- Import new screen
import '../../presentation/screens/splash_screen.dart';

part 'app_router.gr.dart';

@singleton
@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: MovieDetailRoute.page),
        AutoRoute(page: SignUpRoute.page), // <-- Add the new route
      ];
}