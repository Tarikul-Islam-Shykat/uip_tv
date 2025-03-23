import 'package:hive/hive.dart';
import 'package:intl/intl.dart'; // For date parsing if you need it

part 'recommended_model.g.dart';

@HiveType(typeId: 4)
class RecommendMoviesModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String posterPath;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final double voteAverage;

  RecommendMoviesModel({
    required this.id,
    required this.posterPath,
    required this.title,
    required this.voteAverage,
  });

  // Factory constructor for creating a new RecommendMoviesModel instance from a JSON map
  factory RecommendMoviesModel.fromJson(Map<String, dynamic> json) {
    return RecommendMoviesModel(
      id: json['id'],
      posterPath: "https://image.tmdb.org/t/p/w500${json['poster_path']}", // Full URL
      title: json['title'],
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Method to convert RecommendMoviesModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poster_path': posterPath,
      'title': title,
      'vote_average': voteAverage,
    };
  }

  // Method to return the full poster URL (if needed for easier use)
  String getFullPosterUrl() {
    return "https://image.tmdb.org/t/p/w500$posterPath";
  }
}
