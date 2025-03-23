// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trending_movie_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrendingMovieModelAdapter extends TypeAdapter<TrendingMovieModel> {
  @override
  final int typeId = 1;

  @override
  TrendingMovieModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrendingMovieModel(
      id: fields[0] as int,
      title: fields[1] as String,
      posterPath: fields[2] as String,
      overview: fields[3] as String?,
      voteAverage: fields[4] as double?,
      releaseDate: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TrendingMovieModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.posterPath)
      ..writeByte(3)
      ..write(obj.overview)
      ..writeByte(4)
      ..write(obj.voteAverage)
      ..writeByte(5)
      ..write(obj.releaseDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrendingMovieModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
