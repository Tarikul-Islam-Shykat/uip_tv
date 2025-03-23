import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uip_tv/features/movie_details/model/details_mode.dart';
import 'package:uip_tv/provider/api_provider.dart';
import 'package:uip_tv/provider/local_store_provider.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiDataProvider>(context);
    final localStoreProvider = Provider.of<LocalStoreProvider>(context);
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width > 600;

    if (apiProvider.issDetailsLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (apiProvider.errorsDetailsMessage != null) {
      return Scaffold(
        body: Center(
          child: Text('Error: ${apiProvider.errorsDetailsMessage}'),
        ),
      );
    }

    final movie = apiProvider.movieDetails;
    if (movie == null) {
      return const Scaffold(
        body: Center(
          child: Text('No movie details available'),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, movie, isTablet),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? screenSize.width * 0.08 : 16.0,
              vertical: 16.0,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderInfo(movie),
                  SizedBox(height: isTablet ? 30 : 20),
                  _buildTrailerSection(isTablet),
                  SizedBox(height: isTablet ? 36 : 24),
                  _buildAboutSection(movie, isTablet),
                  SizedBox(height: isTablet ? 30 : 20),
                  _buildCastSection(movie, isTablet),
                ],
              ),
            ),
          ),
          // Add extra padding at the bottom for the FAB
          SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Play action
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Playing ${movie.originalTitle}')),
          );
        },
        label: Text(
          'Play Now',
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
          ),
        ),
        icon: Icon(Icons.play_arrow, size: isTablet ? 28 : 24),
        backgroundColor: Colors.red,
        extendedPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? 32 : 24,
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, DetailsModel movie, bool isTablet) {
    final Size screenSize = MediaQuery.of(context).size;
    final double expandedHeight = isTablet ? screenSize.height * 0.5 : 400;

    String imageUrl = movie.localPosterPath ??
        'https://image.tmdb.org/t/p/w500${movie.posterPath}';

    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background image with gradient overlay
            ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.0, 0.4, 0.95],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[900],
                    child: Icon(Icons.broken_image,
                        size: isTablet ? 100 : 60, color: Colors.white54),
                  );
                },
              ),
            ),
            // Blur effect for the top part
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: isTablet ? 200 : 150,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Movie poster and info overlay
            Positioned(
              bottom: 20,
              left: isTablet ? screenSize.width * 0.08 : 16,
              right: isTablet ? screenSize.width * 0.08 : 16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Movie poster
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      width: isTablet ? 150 : 100,
                      height: isTablet ? 225 : 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: isTablet ? 150 : 100,
                          height: isTablet ? 225 : 150,
                          color: Colors.grey[800],
                          child: Icon(Icons.image,
                              color: Colors.white54, size: isTablet ? 48 : 32),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: isTablet ? 24 : 16),
                  // Movie title and metadata
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.originalTitle,
                          style: TextStyle(
                            fontSize: isTablet ? 32 : 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: isTablet ? 8 : 4),
                        Text(
                          '${movie.releaseDate.substring(0, 4)} | ${_formatRuntime(movie.runtime)} | ${movie.originalLanguage.toUpperCase()}',
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(DetailsModel movie) {
    return Row(
      children: [
        // Download icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white38),
          ),
          child: const Icon(Icons.download, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildTrailerSection(bool isTablet) {
    return LayoutBuilder(builder: (context, constraints) {
      final double containerHeight = isTablet ? 300 : 200;
      final double iconSize = isTablet ? 48 : 32;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Watch Trailer',
            style: TextStyle(
              fontSize: isTablet ? 24 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Container(
            height: containerHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[850],
              image: DecorationImage(
                image: const AssetImage('assets/icons/fb.png'),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {},
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(0.8),
              ),
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: iconSize,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildAboutSection(DetailsModel movie, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: TextStyle(
            fontSize: isTablet ? 26 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: isTablet ? 12 : 8),
        Text(
          movie.tagline,
          style: TextStyle(
            fontSize: isTablet ? 20 : 16,
            fontStyle: FontStyle.italic,
            color: Colors.grey[400],
          ),
        ),
        SizedBox(height: isTablet ? 16 : 12),
        Text(
          movie.overview,
          style: TextStyle(
            fontSize: isTablet ? 18 : 15,
            height: 1.5,
          ),
        ),
        SizedBox(height: isTablet ? 16 : 12),
        Text(
          'Starring: ${movie.cast.map((c) => c.originalName).join(', ')}',
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildCastSection(DetailsModel movie, bool isTablet) {
    final double avatarRadius = isTablet ? 60 : 40;
    final double avatarSpacing = isTablet ? 24 : 16;
    final double containerHeight = isTablet ? 180 : 120;
    final double nameWidth = isTablet ? 120 : 80;
    final double fontSize = isTablet ? 14 : 12;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Cast',
          style: TextStyle(
            fontSize: isTablet ? 26 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: isTablet ? 24 : 16),
        SizedBox(
          height: containerHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movie.cast.length,
            itemBuilder: (context, index) {
              final cast = movie.cast[index];
              String imageUrl = cast.localProfilePath ??
                  'https://image.tmdb.org/t/p/w200${cast.profilePath}';

              return Padding(
                padding: EdgeInsets.only(right: avatarSpacing),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundImage: NetworkImage(imageUrl),
                      onBackgroundImageError: (exception, stackTrace) {},
                      backgroundColor: Colors.grey[800],
                      child: cast.profilePath.isEmpty
                          ? Icon(Icons.person,
                              size: avatarRadius, color: Colors.white54)
                          : null,
                    ),
                    SizedBox(height: isTablet ? 12 : 8),
                    SizedBox(
                      width: nameWidth,
                      child: Text(
                        cast.originalName,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: fontSize),
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
    );
  }

  String _formatRuntime(int minutes) {
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m';
  }
}
