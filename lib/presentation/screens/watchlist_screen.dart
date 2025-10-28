import 'package:auto_route/auto_route.dart';
import 'package:cinetrack/app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import '../../app/di/injection.dart';
import '../../core/constants/api_constants.dart';
import '../controllers/watchlist_controller.dart';

@RoutePage()
class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final controller = getIt<WatchlistController>();

  @override
  void initState() {
    super.initState();
    controller.listenToWatchlistChanges();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Watchlist'),
        actions: [
          IconButton(
            // Changed icon from 'person' to 'settings'
            icon: const Icon(Icons.settings),
            onPressed: () {
              AutoRouter.of(context).push(const ProfileRoute());
            },
          ),
        ],
      ),
      body: Watch((context) {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.watchlistMovies.value.isEmpty) {
          return const Center(
            child: Text('Your watchlist is empty. Add some movies!'),
          );
        }
        return ListView.builder(
          itemCount: controller.watchlistMovies.value.length,
          itemBuilder: (context, index) {
            final movie = controller.watchlistMovies.value[index];
            final posterUrl = movie.posterPath != null
                ? '${ApiConstants.tmdbBaseImageUrl}${movie.posterPath}'
                : null;
            return ListTile(
              leading: posterUrl != null
                  ? Image.network(posterUrl, width: 50, fit: BoxFit.cover)
                  : const Icon(Icons.movie),
              title: Text(movie.title),
              subtitle: Text(
                movie.overview,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                AutoRouter.of(context)
                    .push(MovieDetailRoute(movieId: movie.id));
              },
            );
          },
        );
      }),
    );
  }
}