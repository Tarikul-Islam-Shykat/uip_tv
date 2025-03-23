import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uip_tv/di/service_locator.dart';
import 'package:uip_tv/features/auth/view/login_screen.dart';
import 'package:uip_tv/features/dashboard/dashboard.dart';
import 'package:uip_tv/features/dashboard/home/model/continue_watching_model.dart';
import 'package:uip_tv/features/dashboard/home/model/genre_model.dart';
import 'package:uip_tv/features/dashboard/home/model/recommended_model.dart';
import 'package:uip_tv/features/dashboard/home/model/trending_movie_model.dart';
import 'package:uip_tv/features/dashboard/home/model/upcoming_movies_model.dart';
import 'package:uip_tv/features/dashboard/tv_shows/model/tv_shows_model.dart';
import 'package:uip_tv/features/movie_details/model/cast_model.dart';
import 'package:uip_tv/features/movie_details/model/details_mode.dart';
import 'package:uip_tv/features/splash/splash_screen.dart';
import 'package:uip_tv/provider/api_provider.dart';
import 'package:uip_tv/provider/local_store_provider.dart';
import 'package:uip_tv/provider/operation_provider.dart';
import 'package:uip_tv/utils/colors.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  setupLocator();

  await Hive.initFlutter();
  Hive.registerAdapter(GenreAdapter());
  await Hive.openBox<Genre>('genre');

  Hive.registerAdapter(TrendingMovieModelAdapter());
  await Hive.openBox<TrendingMovieModel>('trendingMovies');

  Hive.registerAdapter(UpComingMoviesAdapter());
  await Hive.openBox<UpComingMovies>('upComingMovies');

  Hive.registerAdapter(RecommendMoviesModelAdapter());
  await Hive.openBox<RecommendMoviesModel>('recommendedMovies');

  Hive.registerAdapter(ContinousMoviesModelAdapter());
  await Hive.openBox<ContinousMoviesModel>('continueMovies');

  Hive.registerAdapter(TVShowModelAdapter());
  await Hive.openBox<TVShowModel>('tvShowsMovies');

  Hive.registerAdapter(CastModelAdapter());
  await Hive.openBox<CastModel>('castMovies');

  Hive.registerAdapter(DetailsModelAdapter());
  await Hive.openBox<DetailsModel>('detailsMovies');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<ApiDataProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<LocalStoreProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<AuthOperationProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          scaffoldBackgroundColor: AppPallete.backgroundColor),
      home: const SplashScreen(),
    );
  }
}
