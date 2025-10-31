import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; 
import 'package:injectable/injectable.dart';
import '../../core/constants/api_constants.dart';
import '../../core/logger.dart';
import '../models/movie.dart';

@lazySingleton
class MovieApiService {
  final Dio _dio = Dio();

  MovieApiService() {
    _dio.options.baseUrl = ApiConstants.tmdbBaseUrl;

    // --- SECURITY FIX ---
    // Only add the API key as a query parameter IF we are NOT on the web.
    // On the web, the proxy function handles the key.
    if (!kIsWeb) {
      _dio.options.queryParameters = {
        'api_key': ApiConstants.tmdbApiKey,
      };
    }
  }

  Future<List<Movie>> getPopularMovies() async {
    log.i("Fetching popular movies...");
    try {
      final response = await _dio.get('/movie/popular');
      final results = response.data['results'] as List;
      final movies = results.map((e) => Movie.fromJson(e)).toList();
      log.d("Successfully fetched ${movies.length} popular movies.");
      return movies;
    } catch (e, s) {
      log.e("Error fetching popular movies", error: e, stackTrace: s);
      return [];
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    log.i("Fetching details for movie ID: $movieId");
    try {
      final response = await _dio.get('/movie/$movieId');
      final movie = Movie.fromJson(response.data);
      log.d("Successfully fetched details for '${movie.title}'.");
      return movie;
    } catch (e, s) {
      log.e("Error fetching details for movie ID: $movieId", error: e, stackTrace: s);
      throw Exception('Failed to load movie details');
    }
  }
}