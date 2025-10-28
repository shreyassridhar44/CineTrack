import 'package:injectable/injectable.dart';
import 'package:signals/signals.dart';
import '../../data/models/movie.dart';
import '../../data/services/movie_api_service.dart';
import '../../data/services/watchlist_service.dart';

@injectable
class MovieDetailController {
  final MovieApiService _apiService;
  final WatchlistService _watchlistService;

  MovieDetailController(this._apiService, this._watchlistService);

  // --- State Signals ---
  final movie = signal<Movie?>(null);
  final isLoading = signal(false);
  final isInWatchlist = signal(false);

  // --- Logic ---
  Future<void> fetchMovieDetails(int movieId) async {
    isLoading.value = true;
    try {
      // Fetch movie data from the API
      final fetchedMovie = await _apiService.getMovieDetails(movieId);
      movie.value = fetchedMovie;

      // Listen to the watchlist stream to see if this movie is included
      _watchlistService.getWatchlistStream().listen((watchlistIds) {
        isInWatchlist.value = watchlistIds.contains(movieId);
      });
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }

  void toggleWatchlistStatus() {
  final currentMovie = movie.value; // Get the full movie object
  if (currentMovie == null) return;

  if (isInWatchlist.value) {
    _watchlistService.removeFromWatchlist(currentMovie.id);
  } else {
    // Pass the entire movie object now
    _watchlistService.addToWatchlist(currentMovie);
  }
}
}