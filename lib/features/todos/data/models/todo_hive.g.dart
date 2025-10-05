// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoHiveAdapter extends TypeAdapter<TodoHive> {
  @override
  final int typeId = 0;

  @override
  TodoHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoHive(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      isDone: fields[3] as bool,
      difficulty: fields[4] as int,
      dueDate: fields[5] as DateTime?,
      createdAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TodoHive obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.isDone)
      ..writeByte(4)
      ..write(obj.difficulty)
      ..writeByte(5)
      ..write(obj.dueDate)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
