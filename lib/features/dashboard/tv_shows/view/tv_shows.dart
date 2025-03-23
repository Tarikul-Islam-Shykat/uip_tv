import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uip_tv/features/dashboard/home/model/continue_watching_model.dart';
import 'package:uip_tv/features/dashboard/home/model/recommended_model.dart';
import 'package:uip_tv/features/dashboard/home/model/trending_movie_model.dart';
import 'package:uip_tv/features/dashboard/home/model/upcoming_movies_model.dart';
import 'package:uip_tv/features/dashboard/tv_shows/model/tv_shows_model.dart';
import 'package:uip_tv/features/movie_details/view/movie_details_v3.dart';
import 'package:uip_tv/features/movie_details/view/movie_full_details.dart';
import 'package:uip_tv/provider/api_provider.dart';
import 'package:uip_tv/provider/local_store_provider.dart';
import 'package:uip_tv/utils/size_helper.dart';
import 'package:uip_tv/utils/transitions.dart';

class TVShowsScreen extends StatefulWidget {
  const TVShowsScreen({Key? key}) : super(key: key);

  @override
  State<TVShowsScreen> createState() => _TVShowsScreenState();
}

class _TVShowsScreenState extends State<TVShowsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final apiProvider = Provider.of<ApiDataProvider>(context, listen: false);
      final localStore =
          Provider.of<LocalStoreProvider>(context, listen: false);
      apiProvider.fetchTrendingMovies(context, localStore);
      apiProvider.fetchTvShow(context, localStore);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ApiDataProvider, LocalStoreProvider>(
        builder: (context, apiProvider, localStore, child) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Sizer.deviceDefaultPadding(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Sizer.inBetweenMaxDistance(context),
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
                  if (apiProvider.isTrendingLoading)
                    const CircularProgressIndicator(),
                  if (apiProvider.errorTrendingMessage != null)
                    Text(apiProvider.errorTrendingMessage!,
                        style: const TextStyle(color: Colors.red)),
                  Column(
                    mainAxisSize:
                        MainAxisSize.min, // Prevents infinite height issue
                    children: [
                      SizedBox(
                        height: Sizer.customHeight(context,
                            0.2), // Ensure a finite height for the list
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: apiProvider.trendingMoviesres.length,
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
                      Expanded(
                        child: Text(
                          'Upcoming Movies & TV Show',
                          style: TextStyle(
                            fontSize: Sizer.headingText(context),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.visible, // Ensures text wraps
                          softWrap: true,
                        ),
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
                  if (apiProvider.isTvShowLoading)
                    const CircularProgressIndicator(),
                  if (apiProvider.errorTvShowMessage != null)
                    Text(apiProvider.errorTvShowMessage!,
                        style: const TextStyle(color: Colors.red)),
                  Column(
                    mainAxisSize:
                        MainAxisSize.min, // Prevents infinite height issue
                    children: [
                      SizedBox(
                        height: Sizer.customHeight(
                            context, 0.5), // Adjust height as needed
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 columns per row
                            crossAxisSpacing: 8.0, // Space between columns
                            mainAxisSpacing: 8.0, // Space between rows
                            childAspectRatio:
                                0.7, // Adjust this to fit image proportions
                          ),
                          itemCount: apiProvider.tvShowList.length,
                          itemBuilder: (context, index) {
                            return _buildTvMovieCard(
                                apiProvider.tvShowList[index],
                                apiProvider,
                                context,
                                localStore);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMovieCard(TrendingMovieModel movie, ApiDataProvider ap,
      BuildContext context, LocalStoreProvider local) {
    log("tapped  ${movie.posterPath}");

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

  Widget _buildTvMovieCard(TVShowModel movie, ApiDataProvider ap,
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
              movie.name,
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

  Widget _buildUpRecommendMovieCard(RecommendMoviesModel movie) {
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
    );
  }

  int calculateDaysLeft(String releaseDate) {
    DateTime releaseDateTime = DateFormat('yyyy-MM-dd').parse(releaseDate);
    DateTime currentDate = DateTime.now();
    Duration difference = releaseDateTime.difference(currentDate);
    return difference.inDays;
  }
}

Widget _buildTVShowCard(ContinousMoviesModel show) {
  return Container(
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
  );
}
