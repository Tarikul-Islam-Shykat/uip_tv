import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uip_tv/features/dashboard/home/model/continue_watching_model.dart';
import 'package:uip_tv/features/dashboard/home/model/genre_model.dart';
import 'package:uip_tv/features/dashboard/home/model/recommended_model.dart';
import 'package:uip_tv/features/dashboard/home/model/trending_movie_model.dart';
import 'package:uip_tv/features/dashboard/home/model/upcoming_movies_model.dart';
import 'package:uip_tv/features/dashboard/tv_shows/model/tv_shows_model.dart';
import 'package:uip_tv/features/movie_details/model/details_mode.dart';

class LocalStoreProvider extends ChangeNotifier {
  Box<Genre> genreBox = Hive.box<Genre>('genre');
  Box<TrendingMovieModel> trendingMoviesBox =
      Hive.box<TrendingMovieModel>('trendingMovies');
  Box<UpComingMovies> upcomingMoviesBox =
      Hive.box<UpComingMovies>('upComingMovies');
  Box<RecommendMoviesModel> recommendedMoviesBox =
      Hive.box<RecommendMoviesModel>('recommendedMovies');

  Box<ContinousMoviesModel> continueMoviesBox =
      Hive.box<ContinousMoviesModel>('continueMovies');

  Box<TVShowModel> tvShowsMoviesBox = Hive.box<TVShowModel>('tvShowsMovies');

  Box<DetailsModel> moviesBox = Hive.box<DetailsModel>('detailsMovies');

  void storeGenres(List<Genre> genres) {
    genreBox.clear(); // Remove old data
    for (var genre in genres) {
      genreBox.put(genre.id, genre);
    }
    notifyListeners();
  }

  List<Genre> getGenres() {
    return genreBox.values.toList();
  }

  void storeTrendingMovies(List<TrendingMovieModel> trendingMovieList) {
    trendingMoviesBox.clear(); // Remove old data
    for (var trendingMovies in trendingMovieList) {
      trendingMoviesBox.put(trendingMovies.id, trendingMovies);
    }
    notifyListeners();
  }

  List<TrendingMovieModel> getTrendingMovies() {
    return trendingMoviesBox.values.toList();
  }

  void storeUpComingMovies(List<UpComingMovies> upComingMovieList) {
    upcomingMoviesBox.clear(); // Remove old data
    for (var upCmiongMovies in upComingMovieList) {
      upcomingMoviesBox.put(upCmiongMovies.id, upCmiongMovies);
    }
    notifyListeners();
  }

  List<UpComingMovies> getUpcomingMovies() {
    return upcomingMoviesBox.values.toList();
  }

  void storeReCommendedMovies(List<RecommendMoviesModel> recommnededMovieList) {
    recommendedMoviesBox.clear(); // Remove old data
    for (var recommnededMovie in recommnededMovieList) {
      recommendedMoviesBox.put(recommnededMovie.id, recommnededMovie);
    }
    notifyListeners();
  }

  List<RecommendMoviesModel> getGetRecommendedMovies() {
    return recommendedMoviesBox.values.toList();
  }

  void storeContinueMovies(List<ContinousMoviesModel> continueMovieList) {
    continueMoviesBox.clear(); // Remove old data
    for (var continueMovie in continueMovieList) {
      continueMoviesBox.put(continueMovie.id, continueMovie);
    }
    notifyListeners();
  }

  List<ContinousMoviesModel> getGetContinueMovies() {
    return continueMoviesBox.values.toList();
  }

  void storeTVMovies(List<TVShowModel> tvShowMovieList) {
    tvShowsMoviesBox.clear(); // Remove old data
    for (var tvShowMovie in tvShowMovieList) {
      tvShowsMoviesBox.put(tvShowMovie.id, tvShowMovie);
    }
    notifyListeners();
  }

  List<TVShowModel> getGetTvMovies() {
    return tvShowsMoviesBox.values.toList();
  }

  void storeMovieDetails(DetailsModel movie) {
    moviesBox.put(movie.id, movie);
    notifyListeners();
  }

  DetailsModel? getMovieDetails(int movieId) {
    return moviesBox.get(movieId);
  }

  // Get all stored movies
  List<DetailsModel> getAllMovies() {
    return moviesBox.values.toList();
  }

  // Clear all stored movies
  void clearAllMovies() {
    moviesBox.clear();
  }

  // Delete a specific movie
  void deleteMovie(int movieId) {
    moviesBox.delete(movieId);
    notifyListeners();
  }
}
