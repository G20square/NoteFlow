// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteHiveModelAdapter extends TypeAdapter<NoteHiveModel> {
  @override
  final int typeId = 0;

  @override
  NoteHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteHiveModel()
      ..id = fields[0] as String
      ..userId = fields[1] as String
      ..title = fields[2] as String
      ..content = fields[3] as String
      ..imageUrls = (fields[4] as List).cast<String>()
      ..labelIds = (fields[5] as List).cast<String>()
      ..isPinned = fields[6] as bool
      ..isArchived = fields[7] as bool
      ..createdAt = fields[8] as String
      ..updatedAt = fields[9] as String
      ..colorIndex = fields[10] as int;
  }

  @override
  void write(BinaryWriter writer, NoteHiveModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.imageUrls)
      ..writeByte(5)
      ..write(obj.labelIds)
      ..writeByte(6)
      ..write(obj.isPinned)
      ..writeByte(7)
      ..write(obj.isArchived)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.colorIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
