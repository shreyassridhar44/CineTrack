import 'package:injectable/injectable.dart';
import 'package:signals/signals.dart';
import '../../data/models/movie.dart';
import '../../data/services/movie_api_service.dart';

@injectable
class HomeController {
  final MovieApiService _apiService;

  // Constructor injection: GetIt will provide the api service instance.
  HomeController(this._apiService);

  // --- State Signals ---
  // A signal to hold the list of popular movies.
  final movies = signal<List<Movie>>([]);
  // A signal to track the loading state.
  final isLoading = signal(false);
  // A signal to hold any potential error messages.
  final errorMessage = signal<String?>(null);

  // --- Logic ---
  Future<void> fetchPopularMovies() async {
    try {
      isLoading.value = true;
      errorMessage.value = null; // Clear previous errors
      final fetchedMovies = await _apiService.getPopularMovies();
      movies.value = fetchedMovies;
    } catch (e) {
      errorMessage.value = "Failed to load movies. Please try again.";
    } finally {
      isLoading.value = false;
    }
  }
}