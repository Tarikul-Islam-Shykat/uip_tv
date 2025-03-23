import 'package:hive/hive.dart';

part 'trending_movie_model.g.dart';

@HiveType(typeId: 1)
class TrendingMovieModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String posterPath;

  @HiveField(3)
  final String? overview;

  @HiveField(4)
  final double? voteAverage;

  @HiveField(5)
  final String releaseDate;

  TrendingMovieModel({
    required this.id,
    required this.title,
    required this.posterPath,
    this.overview,
    this.voteAverage,
    required this.releaseDate,
  });

  factory TrendingMovieModel.fromJson(Map<String, dynamic> json) {
    return TrendingMovieModel(
      id: json['id'],
      title: json['title'],
      posterPath: "https://image.tmdb.org/t/p/w500${json['poster_path']}",
      overview: json['overview'],
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      releaseDate: json['release_date'] ?? '',
    );
  }
}
