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
      appBar: AppBar(
        title: const Text('CineTrack - Popular Movies'),
        centerTitle: true,
        // We removed 'backgroundColor: Colors.black' - The theme now handles it.
        actions: [
          IconButton(
            // Changed icon from 'person' to 'settings'
            icon: const Icon(Icons.settings),
            onPressed: () {
              AutoRouter.of(context).push(const ProfileRoute());
            },
          ),
        ],
      ),
      body: Watch((context) {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value != null) {
          return Center(child: Text(controller.errorMessage.value!));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
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