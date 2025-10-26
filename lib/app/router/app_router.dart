// lib/app/router/app_router.dart

import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart'; // <-- THIS LINE WAS MISSING
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/movie_detail_screen.dart';
import '../../presentation/screens/splash_screen.dart';

part 'app_router.gr.dart';

@singleton // Now Dart knows what this is!
@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: MovieDetailRoute.page),
      ];
}