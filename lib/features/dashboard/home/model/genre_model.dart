import 'package:hive/hive.dart';

part 'genre_model.g.dart'; // Required for Hive code generation

@HiveType(typeId: 0)
class Genre extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }
}
