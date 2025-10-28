import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import '../../app/di/injection.dart';
import '../../core/constants/api_constants.dart';
import '../controllers/movie_detail_controller.dart';

@RoutePage()
class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final controller = getIt<MovieDetailController>();

  @override
  void initState() {
    super.initState();
    controller.fetchMovieDetails(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Watch((context) {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // --- New: Check for an error first ---
        if (controller.errorMessage.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchMovieDetails(widget.movieId),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        final movie = controller.movie.value;
        if (movie == null) {
          return const Center(child: Text('Movie not found.'));
        }

        // --- The rest of the UI is the same ---
        final posterUrl = movie.posterPath != null
            ? '${ApiConstants.tmdbBaseImageUrl}${movie.posterPath}'
            : null;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(movie.title, style: const TextStyle(fontSize: 16)),
                background: posterUrl != null
                    ? Image.network(posterUrl, fit: BoxFit.cover)
                    : Container(color: Colors.grey),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton.icon(
                        onPressed: controller.toggleWatchlistStatus,
                        icon: Icon(
                          controller.isInWatchlist.value ? Icons.check : Icons.add,
                        ),
                        label: Text(
                          controller.isInWatchlist.value
                              ? 'In Watchlist'
                              : 'Add to Watchlist',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.isInWatchlist.value
                              ? Colors.green
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 8),
                          Text(
                            '${movie.voteAverage.toStringAsFixed(1)} / 10',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('Overview',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(movie.overview,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        );
      }),
    );
  }
}