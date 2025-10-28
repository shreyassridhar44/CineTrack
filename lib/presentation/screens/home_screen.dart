import 'package:auto_route/auto_route.dart';
import 'package:cinetrack/app/router/app_router.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      // List of routes that will be shown as tabs
      routes: const [
        PopularMoviesRoute(),
        WatchlistRoute(),
      ],
      builder: (context, child) {
        // Obtain the TabsRouter to control the active tab
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: (index) {
              // Switch tab on tap
              tabsRouter.setActiveIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.movie),
                label: 'Popular',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: 'Watchlist',
              ),
            ],
          ),
        );
      },
    );
  }
}