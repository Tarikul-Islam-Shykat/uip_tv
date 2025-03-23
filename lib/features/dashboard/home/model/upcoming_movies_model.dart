import 'package:hive/hive.dart';

part 'upcoming_movies_model.g.dart';

@HiveType(typeId: 3)
class UpComingMovies {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String posterPath;

  @HiveField(3)
  final String releaseDate;

  UpComingMovies({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
  });

  factory UpComingMovies.fromJson(Map<String, dynamic> json) {
    return UpComingMovies(
      id: json['id'],
      title: json['title'],
      posterPath: "https://image.tmdb.org/t/p/w500${json['poster_path']}",
      releaseDate: json['release_date'],
    );
  }
}
