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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Watchlist'),
        centerTitle: true,
        actions: [
          IconButton(
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_outline,
                  size: 80,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(height: 20),
                Text(
                  'Your watchlist is empty',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Add movies from the "Popular" tab to see them here.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12.0),
          itemCount: controller.watchlistMovies.value.length,
          itemBuilder: (context, index) {
            final movie = controller.watchlistMovies.value[index];
            final posterUrl = movie.posterPath != null
                ? '${ApiConstants.tmdbBaseImageUrl}${movie.posterPath}'
                : null;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: ListTile(
                // The style (shape, etc.) is controlled by main.dart
                tileColor: theme.colorScheme.surfaceVariant,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: posterUrl != null
                      ? Image.network(
                          posterUrl,
                          width: 50,
                          height: 75,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 50,
                          height: 75,
                          color: theme.colorScheme.onSurface.withOpacity(0.1),
                          child: const Icon(Icons.movie_creation_outlined),
                        ),
                ),
                title: Text(movie.title, style: theme.textTheme.titleMedium),
                subtitle: Text(
                  movie.overview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
                onTap: () {
                  AutoRouter.of(context).push(MovieDetailRoute(movieId: movie.id));
                },
              ),
            );
          },
        );
      }),
    );
  }
}