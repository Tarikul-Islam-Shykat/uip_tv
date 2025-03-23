import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uip_tv/features/dashboard/home/model/continue_watching_model.dart';
import 'package:uip_tv/features/dashboard/home/model/genre_model.dart';
import 'package:uip_tv/features/dashboard/home/model/recommended_model.dart';
import 'package:uip_tv/features/dashboard/home/model/trending_movie_model.dart';
import 'package:uip_tv/features/dashboard/home/model/upcoming_movies_model.dart';
import 'package:uip_tv/features/dashboard/tv_shows/model/tv_shows_model.dart';
import 'package:uip_tv/features/movie_details/model/cast_model.dart';
import 'package:uip_tv/features/movie_details/model/details_mode.dart';
import 'package:uip_tv/provider/local_store_provider.dart';
import 'package:uip_tv/service/Image_download/image_download_service.dart';
import 'package:uip_tv/service/base_url.dart';
import 'package:uip_tv/service/internet_checker.dart';

class ApiDataProvider extends ChangeNotifier {
  final Dio _dio = Dio();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<Genre> _genres = [];
  List<Genre> get genres => _genres;
  Future<void> fetchGenres(
      BuildContext context, LocalStoreProvider localStore) async {
    log("fetchGenres ");
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    bool isConnected = await checkInternetConnection();
    if (isConnected) {
      const String url =
          "${ApiConstantData.baseUrl}genre/movie/list?api_key=${ApiConstantData.apiKey}";
      try {
        final response = await _dio.get(url);
        if (response.statusCode == 200) {
          List<Genre> fetchedGenres = (response.data['genres'] as List)
              .map((e) => Genre.fromJson(e))
              .toList();
          _genres = fetchedGenres;

          log("fetchedGenres $fetchedGenres");
          localStore.storeGenres(_genres);
        } else {
          _errorMessage = "Failed to fetch data!";
        }
      } on DioException catch (e) {
        _errorMessage = e.message ?? "Something went wrong!";
      } catch (e) {
        _errorMessage = "Unexpected error: $e";
      }
    } else {
      _genres = localStore.getGenres();
    }
    _isLoading = false;
    notifyListeners();
  }

  bool _isTrendingLoading = false;
  bool get isTrendingLoading => _isTrendingLoading;
  String? _errorTrendingMessage;
  String? get errorTrendingMessage => _errorTrendingMessage;
  List<TrendingMovieModel> _trendingMovies = [];
  List<TrendingMovieModel> get trendingMoviesres => _trendingMovies;
  Future<void> fetchTrendingMovies(
      BuildContext context, LocalStoreProvider localStore) async {
    _isTrendingLoading = true;
    _errorTrendingMessage = null;
    notifyListeners();
    bool isConnected = await checkInternetConnection();
    if (isConnected) {
      const String url =
          "${ApiConstantData.baseUrl}trending/movie/day?api_key=${ApiConstantData.apiKey}&language=en-US";
      try {
        final response = await _dio.get(url);
        if (response.statusCode == 200) {
          List<TrendingMovieModel> fetchedGenres =
              (response.data['results'] as List)
                  .map((e) => TrendingMovieModel.fromJson(e))
                  .toList();

          _trendingMovies = fetchedGenres;

          log("fetchTrendingMovies $fetchedGenres");
          localStore.storeTrendingMovies(_trendingMovies);
        } else {
          _errorTrendingMessage = "Failed to fetch data!";
        }
      } on DioException catch (e) {
        _errorTrendingMessage = e.message ?? "Something went wrong!";
      } catch (e) {
        _errorTrendingMessage = "Unexpected error: $e";
      }
    } else {
      _trendingMovies = localStore.getTrendingMovies();
    }
    _isTrendingLoading = false;
    notifyListeners();
  }

  bool _isUpComingLoading = false;
  bool get isUpComingLoading => _isUpComingLoading;
  String? _errorUpComingMessage;
  String? get errorUpComingMessage => _errorUpComingMessage;
  List<UpComingMovies> _upComingMovies = [];
  List<UpComingMovies> get upComingMovies => _upComingMovies;
  Future<void> fetchUpComingMovies(
      BuildContext context, LocalStoreProvider localStore) async {
    _isUpComingLoading = true;
    _errorUpComingMessage = null;
    notifyListeners();
    bool isConnected = await checkInternetConnection();
    if (isConnected) {
      try {
        final response = await _dio.get(
          "${ApiConstantData.baseUrl}movie/upcoming",
          queryParameters: {
            'api_key': ApiConstantData.apiKey,
            'language': 'en-US',
            'page': 1,
          },
        );
        if (response.statusCode == 200) {
          List<UpComingMovies> fetchedUpcoming =
              (response.data['results'] as List)
                  .map((e) => UpComingMovies.fromJson(e))
                  .toList();

          _upComingMovies = fetchedUpcoming;

          log("fetchUpComingMovies $fetchedUpcoming");
          localStore.storeUpComingMovies(_upComingMovies);
        } else {
          _errorUpComingMessage = "Failed to fetch data!";
        }
      } on DioException catch (e) {
        _errorUpComingMessage = e.message ?? "Something went wrong!";
      } catch (e) {
        _errorUpComingMessage = "Unexpected error: $e";
      }
    } else {
      _upComingMovies = localStore.getUpcomingMovies();
    }
    _isUpComingLoading = false;
    notifyListeners();
  }

  bool _isRecommnedLoading = false;
  bool get isRecommnedLoading => _isRecommnedLoading;
  String? _errorRecommnedMessage;
  String? get errorRecommnedMessage => _errorRecommnedMessage;
  List<RecommendMoviesModel> _recommendMovies = [];
  List<RecommendMoviesModel> get recommendMovies => _recommendMovies;
  Future<void> fetchRecommendMovies(
      BuildContext context, LocalStoreProvider localStore) async {
    _isRecommnedLoading = true;
    _errorRecommnedMessage = null;
    notifyListeners();
    bool isConnected = await checkInternetConnection();
    if (isConnected) {
      const String url =
          "${ApiConstantData.baseUrl}movie/top_rated?api_key=${ApiConstantData.apiKey}&language=en-US&page=1";
      try {
        final response = await _dio.get(url);
        if (response.statusCode == 200) {
          List<RecommendMoviesModel> fetchedRecommendMovies =
              (response.data['results'] as List)
                  .map((e) => RecommendMoviesModel.fromJson(e))
                  .toList();

          _recommendMovies = fetchedRecommendMovies;

          log("fetchRecommendMovies $fetchedRecommendMovies");
          localStore.storeReCommendedMovies(_recommendMovies);
        } else {
          _errorRecommnedMessage = "Failed to fetch data!";
        }
      } on DioException catch (e) {
        _errorRecommnedMessage = e.message ?? "Something went wrong!";
      } catch (e) {
        _errorRecommnedMessage = "Unexpected error: $e";
      }
    } else {
      _recommendMovies = localStore.getGetRecommendedMovies();
    }
    _isRecommnedLoading = false;
    notifyListeners();
  }

  bool _isContinueLoading = false;
  bool get isContinueLoading => _isContinueLoading;
  String? _errorContinueMessage;
  String? get errorContinueMessage => _errorContinueMessage;
  List<ContinousMoviesModel> _continueMoviesList = [];
  List<ContinousMoviesModel> get continueMoviesList => _continueMoviesList;
  Future<void> fetchContinueGenres(
      BuildContext context, LocalStoreProvider localStore) async {
    _isContinueLoading = true;
    _errorContinueMessage = null;
    notifyListeners();
    bool isConnected = await checkInternetConnection();
    if (isConnected) {
      const String url =
          "${ApiConstantData.baseUrl}movie/now_playing?api_key=${ApiConstantData.apiKey}&language=en-US&page=1";
      try {
        final response = await _dio.get(url);
        if (response.statusCode == 200) {
          List<ContinousMoviesModel> fetchedCGenres =
              (response.data['results'] as List)
                  .map((e) => ContinousMoviesModel.fromJson(e))
                  .toList();

          _continueMoviesList = fetchedCGenres;

          log("fetchContinueGenres $fetchedCGenres");
          localStore.storeContinueMovies(_continueMoviesList);
        } else {
          _errorContinueMessage = "Failed to fetch data!";
        }
      } on DioException catch (e) {
        _errorContinueMessage = e.message ?? "Something went wrong!";
      } catch (e) {
        _errorContinueMessage = "Unexpected error: $e";
      }
    } else {
      _continueMoviesList = localStore.getGetContinueMovies();
    }
    _isContinueLoading = false;
    notifyListeners();
  }

  bool _isTvShowLoading = false;
  bool get isTvShowLoading => _isTvShowLoading;
  String? _errorTvShowMessage;
  String? get errorTvShowMessage => _errorTvShowMessage;
  List<TVShowModel> _tvShowList = [];
  List<TVShowModel> get tvShowList => _tvShowList;
  Future<void> fetchTvShow(
      BuildContext context, LocalStoreProvider localStore) async {
    _isTvShowLoading = true;
    _errorTvShowMessage = null;
    notifyListeners();
    bool isConnected = await checkInternetConnection();
    if (isConnected) {
      const String url =
          "${ApiConstantData.baseUrl}trending/tv/week?api_key=${ApiConstantData.apiKey}";
      try {
        final response = await _dio.get(url);
        if (response.statusCode == 200) {
          List<TVShowModel> fetchedTVShow = (response.data['results'] as List)
              .map((e) => TVShowModel.fromJson(e))
              .toList();
          _tvShowList = fetchedTVShow;
          log("fetchedGenres $fetchedTVShow");
          localStore.storeTVMovies(_tvShowList);
        } else {
          _errorTvShowMessage = "Failed to fetch data!";
        }
      } on DioException catch (e) {
        _errorTvShowMessage = e.message ?? "Something went wrong!";
      } catch (e) {
        _errorTvShowMessage = "Unexpected error: $e";
      }
    } else {
      _tvShowList = localStore.getGetTvMovies();
    }
    _isTvShowLoading = false;
    notifyListeners();
  }

  bool _isLsDetailsoading = false;
  bool get issDetailsLoading => _isLsDetailsoading;

  String? _errorsDetailsMessage;
  String? get errorsDetailsMessage => _errorsDetailsMessage;

  DetailsModel? _movieDetails;
  DetailsModel? get movieDetails => _movieDetails;

  Future<void> fetchMovieWithCast(
      int movieId, BuildContext context, LocalStoreProvider localStore) async {
    _isLsDetailsoading = true;
    _errorsDetailsMessage = null;
    notifyListeners();

    bool isConnected = await checkInternetConnection();

    if (isConnected) {
      try {
        // Fetch movie details
        final String detailsUrl =
            "${ApiConstantData.baseUrl}movie/$movieId?api_key=${ApiConstantData.apiKey}&language=en-US";
        final detailsResponse = await _dio.get(detailsUrl);

        final String castUrl =
            "${ApiConstantData.baseUrl}movie/$movieId/credits?api_key=${ApiConstantData.apiKey}&language=en-US";
        final castResponse = await _dio.get(castUrl);

        if (detailsResponse.statusCode == 200 &&
            castResponse.statusCode == 200) {
          List<CastModel> castList = [];
          List castData = castResponse.data['cast'] as List;

          int castCount = castData.length > 3 ? 3 : castData.length;
          for (int i = 0; i < castCount; i++) {
            castList.add(CastModel.fromJson(castData[i]));
          }

          DetailsModel movie =
              DetailsModel.fromJson(detailsResponse.data, castList);

          _movieDetails = await ImageDownloadService.downloadMovieImages(movie);

          // Store data locally
          localStore.storeMovieDetails(_movieDetails!);

          log("Movie details fetched successfully: ${_movieDetails!.originalTitle}");
        } else {
          _errorsDetailsMessage = "Failed to fetch data!";
        }
      } on DioException catch (e) {
        _errorsDetailsMessage = e.message ?? "Something went wrong!";
        log("DIO Error: $_errorMessage");
      } catch (e) {
        _errorsDetailsMessage = "Unexpected error: $e";
        log("Error: $_errorMessage");
      }
    } else {
      // Load from local storage
      _movieDetails = localStore.getMovieDetails(movieId);
      if (_movieDetails == null) {
        _errorsDetailsMessage =
            "No internet connection and no local data available";
      }
    }

    _isLsDetailsoading = false;
    notifyListeners();
  }

  bool _isConnected = false;
  bool get isConnected => _isConnected;
  checkInterner() async {
    _isConnected = await checkInternetConnection();
    notifyListeners();
  }
}
