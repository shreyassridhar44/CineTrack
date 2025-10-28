// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cinetrack/app/router/app_router.dart' as _i697;
import 'package:cinetrack/data/services/auth_service.dart' as _i350;
import 'package:cinetrack/data/services/movie_api_service.dart' as _i27;
import 'package:cinetrack/data/services/watchlist_service.dart' as _i24;
import 'package:cinetrack/presentation/controllers/auth_controller.dart'
    as _i623;
import 'package:cinetrack/presentation/controllers/home_controller.dart'
    as _i595;
import 'package:cinetrack/presentation/controllers/movie_detail_controller.dart'
    as _i646;
import 'package:cinetrack/presentation/controllers/profile_controller.dart'
    as _i384;
import 'package:cinetrack/presentation/controllers/theme_controller.dart'
    as _i330;
import 'package:cinetrack/presentation/controllers/watchlist_controller.dart'
    as _i80;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i697.AppRouter>(() => _i697.AppRouter());
    gh.singletonAsync<_i330.ThemeController>(
        () => _i330.ThemeController.create());
    gh.lazySingleton<_i350.AuthService>(() => _i350.AuthService());
    gh.lazySingleton<_i27.MovieApiService>(() => _i27.MovieApiService());
    gh.lazySingleton<_i24.WatchlistService>(() => _i24.WatchlistService());
    gh.factory<_i595.HomeController>(
        () => _i595.HomeController(gh<_i27.MovieApiService>()));
    gh.factory<_i646.MovieDetailController>(() => _i646.MovieDetailController(
          gh<_i27.MovieApiService>(),
          gh<_i24.WatchlistService>(),
        ));
    gh.factory<_i80.WatchlistController>(() => _i80.WatchlistController(
          gh<_i24.WatchlistService>(),
          gh<_i27.MovieApiService>(),
        ));
    gh.factory<_i623.AuthController>(
        () => _i623.AuthController(gh<_i350.AuthService>()));
    gh.factory<_i384.ProfileController>(
        () => _i384.ProfileController(gh<_i350.AuthService>()));
    return this;
  }
}
