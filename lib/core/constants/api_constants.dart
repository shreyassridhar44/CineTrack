import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // Read the API key from the loaded .env file
  static final String tmdbApiKey = dotenv.env['TMDB_API_KEY']!;

  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbBaseImageUrl = 'https://image.tmdb.org/t/p/w500';
}