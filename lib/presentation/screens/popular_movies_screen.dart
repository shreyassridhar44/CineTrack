import 'package:auto_route/auto_route.dart';
import 'package:cinetrack/app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import '../../app/di/injection.dart';
import '../controllers/home_controller.dart';
import '../widgets/movie_card.dart';

@RoutePage(name: 'PopularMoviesRoute')
class PopularMoviesScreen extends StatefulWidget {
  const PopularMoviesScreen({super.key});

  @override
  State<PopularMoviesScreen> createState() => _PopularMoviesScreenState();
}

class _PopularMoviesScreenState extends State<PopularMoviesScreen> {
  final controller = getIt<HomeController>();

  @override
  void initState() {
    super.initState();
    controller.fetchPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The AppBar style is now controlled by main.dart
      appBar: AppBar(
        title: const Text('CineTrack - Popular Movies'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              AutoRouter.of(context).push(const ProfileRoute());
            },
          ),
        ],
      ),
      body: Watch((context) {
        if (controller.errorMessage.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.signal_wifi_off,
                  size: 60,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(height: 20),
                Text(
                  controller.errorMessage.value!,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchPopularMovies,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        if (controller.isLoading.value && controller.movies.value.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68, // Adjusted for the new card style
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: controller.movies.value.length,
          itemBuilder: (context, index) {
            final movie = controller.movies.value[index];
            return MovieCard(movie: movie);
          },
        );
      }),
    );
  }
}