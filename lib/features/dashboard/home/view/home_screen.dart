import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uip_tv/features/dashboard/home/model/continue_watching_model.dart';
import 'package:uip_tv/features/dashboard/home/model/recommended_model.dart';
import 'package:uip_tv/features/dashboard/home/model/trending_movie_model.dart';
import 'package:uip_tv/features/dashboard/home/model/upcoming_movies_model.dart';
import 'package:uip_tv/features/movie_details/view/movie_details_v3.dart';
import 'package:uip_tv/provider/api_provider.dart';
import 'package:uip_tv/provider/local_store_provider.dart';
import 'package:uip_tv/utils/gradient_image.dart';
import 'package:uip_tv/utils/size_helper.dart';
import 'package:uip_tv/utils/transitions.dart';

// Data Models - You can replace these with Hive models later
class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String? subtitle;
  final double? progress; // For continue watching

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    this.subtitle,
    this.progress,
  });
}

class TvShow {
  final String id;
  final String title;
  final String posterUrl;
  final int season;
  final int episode;

  TvShow({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.season,
    required this.episode,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final apiProvider = Provider.of<ApiDataProvider>(context, listen: false);
      final localStore =
          Provider.of<LocalStoreProvider>(context, listen: false);

      apiProvider.fetchGenres(context, localStore);
      apiProvider.fetchTrendingMovies(context, localStore);
      apiProvider.fetchUpComingMovies(context, localStore);
      apiProvider.fetchRecommendMovies(context, localStore);
      apiProvider.fetchContinueGenres(context, localStore);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Movie featuredMovie = Movie(
      id: 'featured1',
      title: 'UNCHARTED',
      posterUrl: 'https://picsum.photos/800/400?random=9',
    );
    return Consumer2<ApiDataProvider, LocalStoreProvider>(
        builder: (context, apiProvider, localStore, child) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Sizer.deviceDefaultPadding(context)),
              child: Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: Sizer.inBetweenDistance(context),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello Rafsan',
                            style: TextStyle(
                                fontSize: Sizer.normal2Text(context),
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          Text(
                            'Let\'s watch today',
                            style: TextStyle(
                                fontSize: Sizer.normalText(context),
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                      GradientBorderAvatar(
                        imagePath: 'assets/images/user.png',
                        size: Sizer.customHeight(
                            context, 0.05), // Adjust size as needed
                      ),
                    ],
                  ),
                  SizedBox(height: Sizer.inBetweenDistance(context)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: Sizer.inBetweenDistance(context)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categories',
                        style: TextStyle(
                            fontSize: Sizer.headingText(context),
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'See More',
                          style: TextStyle(
                              fontSize: Sizer.normal2Text(context),
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (apiProvider.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: LinearProgressIndicator(),
                    ),
                  if (apiProvider.errorMessage != null)
                    Text(apiProvider.errorMessage!,
                        style: const TextStyle(color: Colors.red)),
                  Column(
                    mainAxisSize:
                        MainAxisSize.min, // Prevents infinite height issue
                    children: [
                      SizedBox(
                        height: 40, // Ensure a finite height for the list
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: apiProvider.genres.length,
                          itemBuilder: (context, index) {
                            return _buildCategoryChip(
                                apiProvider.genres[index].name);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Sizer.inBetweenDistance(context),
                  ),
                  _buildFeaturedMovieBanner(featuredMovie),
                  SizedBox(
                    height: Sizer.inBetweenDistance(context),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Trending Movies',
                        style: TextStyle(
                            fontSize: Sizer.headingText(context),
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'See More',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Sizer.inBetweenMinimalDistance(context),
                  ),

                  apiProvider.isTrendingLoading
                      ? const LinearProgressIndicator()
                      : apiProvider.errorTrendingMessage != null
                          ? Text(apiProvider.errorTrendingMessage!,
                              style: const TextStyle(color: Colors.red))
                          : Column(
                              mainAxisSize: MainAxisSize
                                  .min, // Prevents infinite height issue
                              children: [
                                SizedBox(
                                  height: Sizer.customHeight(context,
                                      0.2), // Ensure a finite height for the list
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        apiProvider.trendingMoviesres.length,
                                    itemBuilder: (context, index) {
                                      return _buildMovieCard(
                                          apiProvider.trendingMoviesres[index],
                                          apiProvider,
                                          context,
                                          localStore);
                                    },
                                  ),
                                ),
                              ],
                            ),
                  SizedBox(
                    height: Sizer.inBetweenMaxDistance(context),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Continue Watching',
                        style: TextStyle(
                            fontSize: Sizer.headingText(context),
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'See More',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Sizer.inBetweenMinimalDistance(context),
                  ),

                  apiProvider.isContinueLoading
                      ? const LinearProgressIndicator()
                      : apiProvider.errorContinueMessage != null
                          ? Text(apiProvider.errorContinueMessage!,
                              style: const TextStyle(color: Colors.red))
                          : Column(
                              mainAxisSize: MainAxisSize
                                  .min, // Prevents infinite height issue
                              children: [
                                SizedBox(
                                  height: Sizer.customHeight(context,
                                      0.2), // Ensure a finite height for the list
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        apiProvider.continueMoviesList.length,
                                    itemBuilder: (context, index) {
                                      return _buildTVShowCard(
                                          apiProvider.continueMoviesList[index],
                                          apiProvider,
                                          context,
                                          localStore);
                                    },
                                  ),
                                ),
                              ],
                            ),
                  // if (apiProvider.isContinueLoading)
                  //   const CircularProgressIndicator(),
                  // if (apiProvider.errorContinueMessage != null)
                  //   Text(apiProvider.errorContinueMessage!,
                  //       style: const TextStyle(color: Colors.red)),
                  // Column(
                  //   mainAxisSize:
                  //       MainAxisSize.min, // Prevents infinite height issue
                  //   children: [
                  //     SizedBox(
                  //       height: Sizer.customHeight(context,
                  //           0.2), // Ensure a finite height for the list
                  //       child: ListView.builder(
                  //         scrollDirection: Axis.horizontal,
                  //         itemCount: apiProvider.continueMoviesList.length,
                  //         itemBuilder: (context, index) {
                  //           return _buildTVShowCard(
                  //               apiProvider.continueMoviesList[index],
                  //               apiProvider,
                  //               context,
                  //               localStore);
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: Sizer.inBetweenMaxDistance(context),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recommended For You',
                        style: TextStyle(
                            fontSize: Sizer.headingText(context),
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'See More',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Sizer.inBetweenMinimalDistance(context),
                  ),
                  apiProvider.isRecommnedLoading
                      ? LinearProgressIndicator()
                      : apiProvider.errorRecommnedMessage != null
                          ? Text(apiProvider.errorRecommnedMessage!,
                              style: const TextStyle(color: Colors.red))
                          : Column(
                              mainAxisSize: MainAxisSize
                                  .min, // Prevents infinite height issue
                              children: [
                                SizedBox(
                                  height: Sizer.customHeight(context,
                                      0.2), // Ensure a finite height for the list
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        apiProvider.recommendMovies.length,
                                    itemBuilder: (context, index) {
                                      return _buildUpRecommendMovieCard(
                                          apiProvider.recommendMovies[index],
                                          apiProvider,
                                          localStore);
                                    },
                                  ),
                                ),
                              ],
                            ),

                  // if (apiProvider.isRecommnedLoading)
                  //   const CircularProgressIndicator(),
                  // if (apiProvider.errorRecommnedMessage != null)
                  //   Text(apiProvider.errorRecommnedMessage!,
                  //       style: const TextStyle(color: Colors.red)),
                  // Column(
                  //   mainAxisSize:
                  //       MainAxisSize.min, // Prevents infinite height issue
                  //   children: [
                  //     SizedBox(
                  //       height: Sizer.customHeight(context,
                  //           0.2), // Ensure a finite height for the list
                  //       child: ListView.builder(
                  //         scrollDirection: Axis.horizontal,
                  //         itemCount: apiProvider.recommendMovies.length,
                  //         itemBuilder: (context, index) {
                  //           return _buildUpRecommendMovieCard(
                  //               apiProvider.recommendMovies[index],
                  //               apiProvider,
                  //               localStore);
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildFeaturedMovieBanner(Movie movie) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 180,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              movie.posterUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/placeholder.jpg',
                  fit: BoxFit.cover,
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Wolverine",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildFeaturedMovieBanner(Movie movie) {
  //   return ClipRRect(
  //     borderRadius: BorderRadius.circular(12),
  //     child: Container(
  //       height: 180,
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //         image: DecorationImage(
  //           image: NetworkImage(movie.posterUrl),
  //           fit: BoxFit.cover,
  //           colorFilter: ColorFilter.mode(
  //             Colors.black.withOpacity(0.3),
  //             BlendMode.darken,
  //           ),
  //         ),
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Align(
  //           alignment: Alignment.bottomLeft,
  //           child: Text(
  //             movie.title,
  //             style: const TextStyle(
  //               color: Colors.white,
  //               fontSize: 26,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildCategoryChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }

  Widget _buildMovieCard(TrendingMovieModel movie, ApiDataProvider ap,
      BuildContext context, LocalStoreProvider local) {
    return GestureDetector(
      onTap: () async {
        transition().navigateWithSlideTransition(
            context, const MovieDetailsScreenV2(),
            transitionDirection: TransitionDirection.right);
        await ap.fetchMovieWithCast(movie.id, context, local);
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expanded(
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(8),
            //     child: Image.network(
            //       movie.posterPath,
            //       fit: BoxFit.cover,
            //       width: double.infinity,
            //     ),
            //   ),
            // ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/placeholder.jpg',
                  image: movie.posterPath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  imageErrorBuilder: (context, error, stackTrace) {
                    // Handle image load errors here
                    return Image.asset('assets/images/placeholder.jpg',
                        fit: BoxFit.cover);
                  },
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              movie.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpComingMovieCard(UpComingMovies movie) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Expanded(
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(8),
          //     child: Image.network(
          //       movie.posterPath,
          //       fit: BoxFit.cover,
          //       width: double.infinity,
          //     ),
          //   ),
          // ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/placeholder.jpg',
                image: movie.posterPath,
                fit: BoxFit.cover,
                width: double.infinity,
                imageErrorBuilder: (context, error, stackTrace) {
                  // Handle image load errors here
                  return Image.asset('assets/images/placeholder.jpg',
                      fit: BoxFit.cover);
                },
              ),
            ),
          ),
          const SizedBox(height: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                movie.releaseDate,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "${calculateDaysLeft(movie.releaseDate)} Days Left",
                style: const TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpRecommendMovieCard(RecommendMoviesModel movie,
      ApiDataProvider ap, LocalStoreProvider local) {
    return GestureDetector(
      onTap: () async {
        transition().navigateWithSlideTransition(
            context, const MovieDetailsScreenV2(),
            transitionDirection: TransitionDirection.right);
        await ap.fetchMovieWithCast(movie.id, context, local);
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expanded(
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(8),
            //     child: Image.network(
            //       movie.posterPath,
            //       fit: BoxFit.cover,
            //       width: double.infinity,
            //     ),
            //   ),
            // ),

            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/placeholder.jpg',
                  image: movie.posterPath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  imageErrorBuilder: (context, error, stackTrace) {
                    // Handle image load errors here
                    return Image.asset('assets/images/placeholder.jpg',
                        fit: BoxFit.cover);
                  },
                ),
              ),
            ),
            const SizedBox(height: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      movie.voteAverage.toString(),
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 15,
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int calculateDaysLeft(String releaseDate) {
    DateTime releaseDateTime = DateFormat('yyyy-MM-dd').parse(releaseDate);
    DateTime currentDate = DateTime.now();
    Duration difference = releaseDateTime.difference(currentDate);
    return difference.inDays;
  }
}

Widget _buildTVShowCard(ContinousMoviesModel show, ApiDataProvider ap,
    BuildContext context, LocalStoreProvider local) {
  return GestureDetector(
    onTap: () async {
      transition().navigateWithSlideTransition(
          context, const MovieDetailsScreenV2(),
          transitionDirection: TransitionDirection.right);
      await ap.fetchMovieWithCast(show.id, context, local);
    },
    child: Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Expanded(
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(8),
          //     child: Image.network(
          //       show.posterPath,
          //       fit: BoxFit.cover,
          //       width: double.infinity,
          //     ),
          //   ),
          // ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/placeholder.jpg',
                image: show.posterPath,
                fit: BoxFit.cover,
                width: double.infinity,
                imageErrorBuilder: (context, error, stackTrace) {
                  // Handle image load errors here
                  return Image.asset('assets/images/placeholder.jpg',
                      fit: BoxFit.cover);
                },
              ),
            ),
          ),

          const SizedBox(height: 6),
          Text(
            show.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
