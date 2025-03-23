// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upcoming_movies_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UpComingMoviesAdapter extends TypeAdapter<UpComingMovies> {
  @override
  final int typeId = 3;

  @override
  UpComingMovies read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UpComingMovies(
      id: fields[0] as int,
      title: fields[1] as String,
      posterPath: fields[2] as String,
      releaseDate: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UpComingMovies obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.posterPath)
      ..writeByte(3)
      ..write(obj.releaseDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpComingMoviesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
