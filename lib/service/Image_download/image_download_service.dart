import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uip_tv/features/movie_details/model/cast_model.dart';
import 'dart:developer';

import 'package:uip_tv/features/movie_details/model/details_mode.dart';

class ImageDownloadService {
  // Base URLs for TMDB images
  static const String _posterBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String _profileBaseUrl = 'https://image.tmdb.org/t/p/w200';
  
  // Download movie poster and cast profile images
  static Future<DetailsModel> downloadMovieImages(DetailsModel movie) async {
    try {
      // Create directory for storing images if it doesn't exist
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${appDir.path}/movie_images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      
      // Download movie poster if available
      DetailsModel updatedMovie = movie;
      if (movie.posterPath.isNotEmpty) {
        final posterUrl = '$_posterBaseUrl${movie.posterPath}';
        final localPosterPath = await _downloadImage(
          posterUrl, 
          '${imagesDir.path}/poster_${movie.id}.jpg'
        );
        
        if (localPosterPath != null) {
          updatedMovie = movie.copyWith(localPosterPath: localPosterPath);
        }
      }
      
      // Download cast profile images
      List<CastModel> updatedCast = [];
      for (var castMember in movie.cast) {
        if (castMember.profilePath.isNotEmpty) {
          final profileUrl = '$_profileBaseUrl${castMember.profilePath}';
          final localProfilePath = await _downloadImage(
            profileUrl, 
            '${imagesDir.path}/profile_${castMember.id}.jpg'
          );
          
          if (localProfilePath != null) {
            updatedCast.add(castMember.copyWith(localProfilePath: localProfilePath));
          } else {
            updatedCast.add(castMember);
          }
        } else {
          updatedCast.add(castMember);
        }
      }
      
      // Create a new movie with updated cast
      final movieWithImages = DetailsModel(
        id: updatedMovie.id,
        originalLanguage: updatedMovie.originalLanguage,
        originalTitle: updatedMovie.originalTitle,
        overview: updatedMovie.overview,
        posterPath: updatedMovie.posterPath,
        localPosterPath: updatedMovie.localPosterPath,
        runtime: updatedMovie.runtime,
        releaseDate: updatedMovie.releaseDate,
        tagline: updatedMovie.tagline,
        cast: updatedCast,
      );
      
      return movieWithImages;
    } catch (e) {
      log('Error downloading images: $e');
      return movie; // Return original movie if download fails
    }
  }
  
  // Helper method to download an image and save it to local storage
  static Future<String?> _downloadImage(String url, String localPath) async {
    try {
      // Download file using cache manager
      final file = await DefaultCacheManager().getSingleFile(url);
      
      // Save file to permanent location
      final savedFile = File(localPath);
      if (!await savedFile.exists()) {
        await file.copy(localPath);
      }
      
      return localPath;
    } catch (e) {
      log('Error downloading image $url: $e');
      return null;
    }
  }
}