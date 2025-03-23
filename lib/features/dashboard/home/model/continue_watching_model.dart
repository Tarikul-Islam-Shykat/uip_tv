import 'package:hive/hive.dart';
import 'package:intl/intl.dart'; // For date parsing if you need it

part 'continue_watching_model.g.dart';

@HiveType(typeId: 5)
class ContinousMoviesModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String posterPath;

  @HiveField(2)
  final String title;

  ContinousMoviesModel({
    required this.id,
    required this.posterPath,
    required this.title,
  });

  factory ContinousMoviesModel.fromJson(Map<String, dynamic> json) {
    return ContinousMoviesModel(
      id: json['id'],
      posterPath:
          "https://image.tmdb.org/t/p/w500${json['poster_path']}", // Full URL
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poster_path': posterPath,
      'title': title,
    };
  }

  String getFullPosterUrl() {
    return "https://image.tmdb.org/t/p/w500$posterPath";
  }
}
