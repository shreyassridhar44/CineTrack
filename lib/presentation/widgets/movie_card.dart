import 'package:auto_route/auto_route.dart';
import 'package:cinetrack/app/router/app_router.dart';
import 'package:flutter/material.dart';
import '../../core/constants/api_constants.dart';
import '../../data/models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final posterUrl = movie.posterPath != null
        ? '${ApiConstants.tmdbBaseImageUrl}${movie.posterPath}'
        : null;

    return GestureDetector(
      onTap: () {
        AutoRouter.of(context).push(MovieDetailRoute(movieId: movie.id));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: posterUrl != null
            ? Image.network(
                posterUrl, // <-- THIS is the required positional argument
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.movie));
                },
              )
            : const Center(child: Icon(Icons.movie)),
      ),
    );
  }
}