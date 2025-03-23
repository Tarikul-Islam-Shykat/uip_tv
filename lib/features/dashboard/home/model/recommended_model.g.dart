// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommended_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecommendMoviesModelAdapter extends TypeAdapter<RecommendMoviesModel> {
  @override
  final int typeId = 4;

  @override
  RecommendMoviesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecommendMoviesModel(
      id: fields[0] as int,
      posterPath: fields[1] as String,
      title: fields[2] as String,
      voteAverage: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RecommendMoviesModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.posterPath)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.voteAverage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendMoviesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
