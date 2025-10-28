import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import '../../app/di/injection.dart';
import '../controllers/home_controller.dart';
import '../widgets/movie_card.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        backgroundColor: Colors.black,
        centerTitle: true,
        // The 'actions' property containing the button has been removed.
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