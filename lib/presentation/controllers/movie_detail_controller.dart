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
  final errorMessage = signal<String?>(null); // <-- Add error signal

  // --- Logic ---
  Future<void> fetchMovieDetails(int movieId) async {
    isLoading.value = true;
    errorMessage.value = null; // Clear previous errors
    try {
      final fetchedMovie = await _apiService.getMovieDetails(movieId);
      movie.value = fetchedMovie;

      _watchlistService.getWatchlistStream().listen((watchlistIds) {
        isInWatchlist.value = watchlistIds.contains(movieId);
      });
    } catch (e) {
      errorMessage.value = "Failed to load movie details."; // Set error
    } finally {
      isLoading.value = false;
    }
  }

  void toggleWatchlistStatus() {
    final currentMovie = movie.value;
    if (currentMovie == null) return;

    if (isInWatchlist.value) {
      _watchlistService.removeFromWatchlist(currentMovie.id);
    } else {
      _watchlistService.addToWatchlist(currentMovie);
    }
  }
}