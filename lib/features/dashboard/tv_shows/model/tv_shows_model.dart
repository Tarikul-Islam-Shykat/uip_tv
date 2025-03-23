import 'package:hive/hive.dart';

part 'tv_shows_model.g.dart';

@HiveType(typeId: 7)
class TVShowModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String posterPath;

  @HiveField(3)
  final String firstAirDate;

  TVShowModel({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.firstAirDate,
  });

  // Factory constructor to create TVShowModel from JSON
  factory TVShowModel.fromJson(Map<String, dynamic> json) {
    return TVShowModel(
      id: json['id'],
      name: json['name'],
      posterPath: "https://image.tmdb.org/t/p/w500${json['poster_path']}",
      firstAirDate: json['first_air_date'],
    );
  }

  // Method to convert TVShowModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'poster_path': posterPath,
      'first_air_date': firstAirDate,
    };
  }
}
