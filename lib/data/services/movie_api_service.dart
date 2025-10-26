import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../core/constants/api_constants.dart';
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
    try {
      final response = await _dio.get('/movie/popular');
      final results = response.data['results'] as List;
      return results.map((e) => Movie.fromJson(e)).toList();
    } catch (e) {
      // You can handle errors more gracefully here
      print('Error fetching popular movies: $e');
      return [];
    }
  }
}