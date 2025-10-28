import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:signals/signals.dart';
import '../../data/models/movie.dart';
import '../../data/services/movie_api_service.dart';
import '../../data/services/watchlist_service.dart';

@injectable
class WatchlistController {
  final WatchlistService _watchlistService;
  final MovieApiService _apiService;
  StreamSubscription? _watchlistSubscription;

  WatchlistController(this._watchlistService, this._apiService);

  // --- State Signals ---
  final watchlistMovies = signal<List<Movie>>([]);
  final isLoading = signal(true); // Start as true

  // --- Logic ---
  void listenToWatchlistChanges() {
    // Cancel any previous subscription
    _watchlistSubscription?.cancel();

    // Listen to the stream of movie IDs from Firestore
    _watchlistSubscription =
        _watchlistService.getWatchlistStream().listen((movieIds) async {
      isLoading.value = true;
      if (movieIds.isEmpty) {
        watchlistMovies.value = [];
        isLoading.value = false;
        return;
      }

      try {
        // Fetch all movie details in parallel for efficiency
        final movies = await Future.wait(
          movieIds.map((id) => _apiService.getMovieDetails(id)),
        );
        watchlistMovies.value = movies;
      } catch (e) {
        // Handle potential errors during API fetch
        print("Error fetching watchlist movie details: $e");
      } finally {
        isLoading.value = false;
      }
    });
  }

  // Method to clean up the listener when the screen is disposed
  void dispose() {
    _watchlistSubscription?.cancel();
  }
}