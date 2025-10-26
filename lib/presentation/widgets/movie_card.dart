import 'package:flutter/material.dart';
import '../../core/constants/api_constants.dart';
import '../../data/models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    // Handle cases where a movie might not have a poster
    final posterUrl = movie.posterPath != null
        ? '${ApiConstants.tmdbBaseImageUrl}${movie.posterPath}'
        : null;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: posterUrl != null
          ? Image.network(
              posterUrl,
              fit: BoxFit.cover,
              // Show a loading indicator while the image is loading
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              // Show an icon if the image fails to load
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.movie));
              },
            )
          : const Center(child: Icon(Icons.movie)), // Placeholder for no poster
    );
  }
}