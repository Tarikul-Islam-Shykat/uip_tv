import 'package:hive/hive.dart';
import 'package:intl/intl.dart'; // For date parsing if you need it

part 'cast_model.g.dart';

@HiveType(typeId: 8)
class CastModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String originalName;

  @HiveField(2)
  final String profilePath;

  @HiveField(3)
  final String? localProfilePath;

  @HiveField(4)
  final String character;

  CastModel({
    required this.id,
    required this.originalName,
    required this.profilePath,
    this.localProfilePath,
    required this.character,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      id: json['id'] ?? 0,
      originalName: json['original_name'] ?? '',
      profilePath: json['profile_path'] ?? '',
      localProfilePath: null, // Will be set after downloading
      character: json['character'] ?? '',
    );
  }

  // Create a copy with updated local profile path
  CastModel copyWith({String? localProfilePath}) {
    return CastModel(
      id: id,
      originalName: originalName,
      profilePath: profilePath,
      localProfilePath: localProfilePath ?? this.localProfilePath,
      character: character,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'original_name': originalName,
      'profile_path': profilePath,
      'local_profile_path': localProfilePath,
      'character': character,
    };
  }
}
