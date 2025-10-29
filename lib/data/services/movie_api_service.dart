import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../core/constants/api_constants.dart';
import '../../core/logger.dart'; 
import '../models/movie.dart';

@lazySingleton
class MovieApiService {
  final Dio _dio = Dio();

  MovieApiService() {
    _dio.options.baseUrl = ApiConstants.tmdbBaseUrl;
    _dio.options.queryParameters = {
      'api_key': ApiConstants.tmdbApiKey,
    };
  }

  Future<List<Movie>> getPopularMovies() async {
    log.i("Fetching popular movies..."); // Info log
    try {
      final response = await _dio.get('/movie/popular');
      final results = response.data['results'] as List;
      final movies = results.map((e) => Movie.fromJson(e)).toList();
      log.d("Successfully fetched ${movies.length} popular movies."); // Debug log
      return movies;
    } catch (e, s) {
      // Error log with error object and stack trace
      log.e("Error fetching popular movies", error: e, stackTrace: s);
      return [];
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    log.i("Fetching details for movie ID: $movieId"); // Info log
    try {
      final response = await _dio.get('/movie/$movieId');
      final movie = Movie.fromJson(response.data);
      log.d("Successfully fetched details for '${movie.title}'."); // Debug log
      return movie;
    } catch (e, s) {
      log.e("Error fetching details for movie ID: $movieId", error: e, stackTrace: s);
      throw Exception('Failed to load movie details');
    }
  }
}