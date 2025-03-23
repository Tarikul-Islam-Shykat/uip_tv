import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uip_tv/features/dashboard/downloads/view/download_details.dart';
import 'package:uip_tv/features/movie_details/view/movie_details_v3.dart';
import 'package:uip_tv/features/movie_details/view/movie_full_details.dart';
import 'dart:io';
import 'package:uip_tv/provider/local_store_provider.dart';
import 'package:uip_tv/utils/colors.dart';
import 'package:uip_tv/utils/size_helper.dart';
import '../../../movie_details/model/details_mode.dart';

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPallete.backgroundColor,
        title: const Text(
          'Your Downloads',
          style: TextStyle(color: Colors.white),
        ),
        actions: const [],
      ),
      body: Consumer<LocalStoreProvider>(
        builder: (context, provider, child) {
          final movies = provider.getAllMovies();
          if (movies.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.download_done_rounded,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No downloaded movies',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your downloaded movies will appear here',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return _buildMovieCard(context, movie, provider);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMovieCard(
      BuildContext context, DetailsModel movie, LocalStoreProvider provider) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DownloadDetailsScreen(movie: movie),
          ),
        );
      },
      onLongPress: () {
        _showDeleteDialog(context, movie, provider);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildPosterImage(movie),
          ),
          Text(
            movie.originalTitle,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Sizer.normal2Text(context),
                color: Colors.white),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.grey[600]),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "Downloaded",
                    style: TextStyle(
                        fontSize: Sizer.normal2Text(context),
                        color: Colors.grey[300]),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: Sizer.customHeight(context, 0.02),
                  color: Colors.red,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  _showDeleteDialog(context, movie, provider);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPosterImage(DetailsModel movie) {
    // If we have a local image path, use it
    if (movie.localPosterPath != null && movie.localPosterPath!.isNotEmpty) {
      return Image.file(
        File(movie.localPosterPath!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
      );
    } else {
      return _buildFallbackImage();
    }
  }

  Widget _buildFallbackImage() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.movie,
          size: 50,
          color: Colors.grey,
        ),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, DetailsModel movie, LocalStoreProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Download'),
        content: Text(
            'Are you sure you want to delete "${movie.originalTitle}" from downloads?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteMovie(movie.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('${movie.originalTitle} removed from downloads')),
              );
            },
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Downloads'),
        content: const Text(
            'Are you sure you want to delete all downloaded movies?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              final provider =
                  Provider.of<LocalStoreProvider>(context, listen: false);
              provider.clearAllMovies();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All downloads removed')),
              );
            },
            child: const Text('CLEAR ALL'),
          ),
        ],
      ),
    );
  }
}
