import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uip_tv/features/movie_details/model/cast_model.dart'; // For date parsing if you need it

part 'details_mode.g.dart';

@HiveType(typeId: 12)
class DetailsModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String originalLanguage;

  @HiveField(2)
  final String originalTitle;

  @HiveField(3)
  final String overview;

  @HiveField(4)
  final String posterPath;

  @HiveField(5)
  final String? localPosterPath;

  @HiveField(6)
  final int runtime;

  @HiveField(7)
  final String releaseDate;

  @HiveField(8)
  final String tagline;

  @HiveField(9)
  final List<CastModel> cast;

  DetailsModel({
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    this.localPosterPath,
    required this.runtime,
    required this.releaseDate,
    required this.tagline,
    required this.cast,
  });

  factory DetailsModel.fromJson(
      Map<String, dynamic> json, List<CastModel> castList) {
    return DetailsModel(
      id: json['id'] ?? 0,
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      localPosterPath: null, // Will be set after downloading
      runtime: json['runtime'] ?? 0,
      releaseDate: json['release_date'] ?? '',
      tagline: json['tagline'] ?? '',
      cast: castList,
    );
  }

  // Create a copy with updated local poster path
  DetailsModel copyWith({String? localPosterPath}) {
    return DetailsModel(
      id: id,
      originalLanguage: originalLanguage,
      originalTitle: originalTitle,
      overview: overview,
      posterPath: posterPath,
      localPosterPath: localPosterPath ?? this.localPosterPath,
      runtime: runtime,
      releaseDate: releaseDate,
      tagline: tagline,
      cast: cast,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'overview': overview,
      'poster_path': posterPath,
      'local_poster_path': localPosterPath,
      'runtime': runtime,
      'release_date': releaseDate,
      'tagline': tagline,
      'cast': cast.map((castMember) => castMember.toJson()).toList(),
    };
  }
}
