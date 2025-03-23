import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uip_tv/features/movie_details/model/details_mode.dart';
import 'package:uip_tv/provider/api_provider.dart';
import 'package:uip_tv/provider/local_store_provider.dart';
import 'package:uip_tv/utils/size_helper.dart';

class MovieDetailsScreenV2 extends StatefulWidget {
  const MovieDetailsScreenV2({Key? key}) : super(key: key);

  @override
  State<MovieDetailsScreenV2> createState() => _MovieDetailsScreenV2State();
}

class _MovieDetailsScreenV2State extends State<MovieDetailsScreenV2> {
  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiDataProvider>(context);
    // final localStoreProvider = Provider.of<LocalStoreProvider>(context);
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width > 600;

    if (apiProvider.issDetailsLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.red),
        ),
      );
    }

    if (apiProvider.errorsDetailsMessage != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Error: ${apiProvider.errorsDetailsMessage}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final movie = apiProvider.movieDetails;
    if (movie == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'No movie details available',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: apiProvider.issDetailsLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.red),
            )
          : apiProvider.errorsDetailsMessage != null
              ? Center(
                  child: Text(
                    'Error: ${apiProvider.errorsDetailsMessage}',
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(context, movie, isTablet),
                      _buildInfoSection(movie, isTablet),
                      _buildWatchSection(isTablet, movie),
                      _buildAboutSection(movie, isTablet),
                      _buildCastSection(movie, isTablet),
                      // SizedBox(height: isTablet ? 40 : 30),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeaderSection(
      BuildContext context, DetailsModel movie, bool isTablet) {
    final Size screenSize = MediaQuery.of(context).size;
    final double headerHeight = isTablet ? 500 : 350;

    String imageUrl = movie.localPosterPath ??
        'https://image.tmdb.org/t/p/original${movie.posterPath}';

    log("imageUrl $imageUrl");

    return Stack(
      children: [
        SizedBox(
          height: headerHeight,
          width: double.infinity,
          child: ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.15),
                ],
                stops: const [0.0, 0.3, 0.7, 0.9],
              ).createShader(rect);
            },
            blendMode: BlendMode.dstIn,
            child: movie.localPosterPath != null
                ? Image.file(
                    File(movie.localPosterPath!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[900],
                        child: Icon(Icons.broken_image,
                            size: isTablet ? 100 : 60, color: Colors.white54),
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ),

        // Movie info section
        Positioned(
          bottom: isTablet ? 20 : 15,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie poster thumbnail and info
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Movie poster
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: isTablet ? 150 : 100,
                      height: isTablet ? 225 : 150,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: movie.localPosterPath != null
                          ? Image.file(
                              File(movie.localPosterPath!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[800],
                                  child: Icon(Icons.image,
                                      color: Colors.white54,
                                      size: isTablet ? 48 : 32),
                                );
                              },
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                  SizedBox(width: isTablet ? 24 : 16),
                  // Movie title and metadata
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.originalTitle.toUpperCase(),
                          style: TextStyle(
                            fontSize: Sizer.headingText(context),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: isTablet ? 8 : 5),
                        Text(
                          '${movie.releaseDate.substring(0, 4)} | ${_formatAgeRating(movie)} | ${_formatRuntime(movie.runtime)} | ${_formatGenre(movie)}',
                          style: TextStyle(
                            fontSize: Sizer.normal2Text(context),
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: isTablet ? 20 : 15),
                        // Play and Download buttons
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.play_arrow,
                                  color: Colors.white),
                              label: Text(
                                'Play Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Sizer.normal2Text(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 20 : 16,
                                    vertical: isTablet ? 12 : 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white54),
                              ),
                              child: const Icon(Icons.download,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(DetailsModel movie, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: Sizer.inBetweenDistance(context),
      ),
      child: Text(
        movie.tagline,
        style: TextStyle(
          fontSize: Sizer.normal2Text(context),
          fontStyle: FontStyle.italic,
          color: Colors.white70,
        ),
      ),
    );
  }

  Widget _buildWatchSection(bool isTablet, DetailsModel movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Watch Trailer',
            style: TextStyle(
              fontSize: Sizer.headingText(context),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isTablet ? 16 : 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: isTablet ? 220 : 180,
              width: double.infinity,
              color: Colors.grey[900],
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Placeholder for trailer image
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                    child: movie.localPosterPath != null
                        ? Image.file(
                            File(movie.localPosterPath!),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[800],
                              );
                            },
                          )
                        : const SizedBox.shrink(),
                  ),
                  Container(
                    padding: EdgeInsets.all(isTablet ? 16 : 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: isTablet ? 40 : 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(DetailsModel movie, bool isTablet) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: isTablet ? 30 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About ${movie.originalTitle}',
            style: TextStyle(
              fontSize: Sizer.normal2Text(context),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Text(
            movie.overview,
            style: TextStyle(
              fontSize: Sizer.normal2Text(context),
              height: 1.5,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Text(
            'Starring: ${movie.cast.map((c) => c.originalName).join(', ')}',
            style: TextStyle(
              fontSize: Sizer.normal2Text(context),
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Creators: The Duffer Brothers',
            style: TextStyle(
              fontSize: Sizer.normal2Text(context),
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCastSection(DetailsModel movie, bool isTablet) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: isTablet ? 30 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Cast',
            style: TextStyle(
              fontSize: Sizer.headingText(context),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isTablet ? 16 : 12),
          SizedBox(
            height: Sizer.customHeight(context, 0.2),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movie.cast.length,
              itemBuilder: (context, index) {
                final cast = movie.cast[index];
                String imageUrl = cast.localProfilePath ??
                    'https://image.tmdb.org/t/p/w200${cast.profilePath}';

                log("castImage ${imageUrl}");
                /*
                 
                 Image.file(
                      File(cast.profilePath!)),
                 */
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Sizer.inBetweenDistance(context)),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: isTablet ? 40 : 30,
                        backgroundImage: FileImage(File(imageUrl)),
                        onBackgroundImageError: (exception, stackTrace) {},
                        backgroundColor: Colors.grey[800],
                        child: cast.profilePath.isEmpty
                            ? Icon(Icons.person,
                                size: isTablet ? 40 : 30, color: Colors.white54)
                            : null,
                      ),
                      SizedBox(height: isTablet ? 8 : 6),
                      SizedBox(
                        width: isTablet ? 80 : 60,
                        child: Text(
                          cast.originalName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Sizer.normal2Text(context),
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatRuntime(int minutes) {
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;
    return hours > 0
        ? '${hours}h ${remainingMinutes}m'
        : '${remainingMinutes}m';
  }

  String _formatAgeRating(DetailsModel movie) {
    // This would normally come from API data
    return '16+';
  }

  String _formatGenre(DetailsModel movie) {
    // This would normally come from API data
    return 'Sci-Fi';
  }
}
