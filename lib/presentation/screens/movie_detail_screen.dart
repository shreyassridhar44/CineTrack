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
    final theme = Theme.of(context);

    return Scaffold(
      body: Watch((context) {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Icon(
                  Icons.error_outline,
                  size: 60,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 20),
                Text(
                  controller.errorMessage.value!,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
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

        final posterUrl = movie.posterPath != null
            ? '${ApiConstants.tmdbBaseImageUrl}${movie.posterPath}'
            : null;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 350.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 56, vertical: 16),
                centerTitle: true,
                title: Text(
                  movie.title,
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (posterUrl != null)
                      Image.network(
                        posterUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, e, s) => Container(color: theme.colorScheme.surfaceVariant),
                      )
                    else
                      Container(color: theme.colorScheme.surfaceVariant),
                    // Add a scrim for better title readability
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, 0.5),
                          end: Alignment(0.0, 0.0),
                          colors: <Color>[
                            Color(0x60000000),
                            Color(0x00000000),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Add to Watchlist Button ---
                      ElevatedButton.icon(
                        onPressed: controller.toggleWatchlistStatus,
                        icon: Icon(
                          controller.isInWatchlist.value
                              ? Icons.check_circle
                              : Icons.add_circle_outline,
                        ),
                        label: Text(
                          controller.isInWatchlist.value
                              ? 'In Your Watchlist'
                              : 'Add to Watchlist',
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: controller.isInWatchlist.value
                              ? const Color(0xFF2E7D32) // A nice green
                              : theme.colorScheme.primary,
                          foregroundColor: controller.isInWatchlist.value
                              ? Colors.white
                              : theme.colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // --- Rating & Release Date ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDetailChip(
                            context,
                            icon: Icons.star_rate_rounded,
                            iconColor: Colors.amber,
                            label: '${movie.voteAverage.toStringAsFixed(1)} / 10 Rating',
                          ),
                          if (movie.releaseDate != null)
                             _buildDetailChip(
                              context,
                              icon: Icons.calendar_today,
                              iconColor: theme.colorScheme.tertiary,
                              label: 'Released: ${movie.releaseDate!}',
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // --- Overview ---
                      Text('Overview', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Text(
                        movie.overview.isEmpty
                            ? 'No overview available for this movie.'
                            : movie.overview,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
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

  // Helper widget for detail "chips"
  Widget _buildDetailChip(BuildContext context, {required IconData icon, required Color iconColor, required String label}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Text(label, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}