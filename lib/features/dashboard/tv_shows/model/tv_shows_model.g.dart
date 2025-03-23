// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_shows_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TVShowModelAdapter extends TypeAdapter<TVShowModel> {
  @override
  final int typeId = 7;

  @override
  TVShowModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TVShowModel(
      id: fields[0] as int,
      name: fields[1] as String,
      posterPath: fields[2] as String,
      firstAirDate: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TVShowModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.posterPath)
      ..writeByte(3)
      ..write(obj.firstAirDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TVShowModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
