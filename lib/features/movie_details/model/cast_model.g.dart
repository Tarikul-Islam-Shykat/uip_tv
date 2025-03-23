// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cast_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CastModelAdapter extends TypeAdapter<CastModel> {
  @override
  final int typeId = 8;

  @override
  CastModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CastModel(
      id: fields[0] as int,
      originalName: fields[1] as String,
      profilePath: fields[2] as String,
      localProfilePath: fields[3] as String?,
      character: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CastModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.originalName)
      ..writeByte(2)
      ..write(obj.profilePath)
      ..writeByte(3)
      ..write(obj.localProfilePath)
      ..writeByte(4)
      ..write(obj.character);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CastModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
