// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'continue_watching_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContinousMoviesModelAdapter extends TypeAdapter<ContinousMoviesModel> {
  @override
  final int typeId = 5;

  @override
  ContinousMoviesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContinousMoviesModel(
      id: fields[0] as int,
      posterPath: fields[1] as String,
      title: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ContinousMoviesModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.posterPath)
      ..writeByte(2)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContinousMoviesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
