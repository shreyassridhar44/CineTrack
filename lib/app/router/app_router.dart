import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/movie_detail_screen.dart';
import '../../presentation/screens/popular_movies_screen.dart'; // Import popular
import '../../presentation/screens/signup_screen.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/watchlist_screen.dart'; // Import watchlist
import '../../presentation/screens/profile_screen.dart';

part 'app_router.gr.dart';

@singleton
@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: SignUpRoute.page),
        AutoRoute(page: MovieDetailRoute.page),
        AutoRoute(page: ProfileRoute.page),

        // This is the new part for tab navigation
        AutoRoute(
          page: HomeRoute.page,
          children: [
            AutoRoute(page: PopularMoviesRoute.page, initial: true),
            AutoRoute(page: WatchlistRoute.page),
          ],
        ),
      ];
}