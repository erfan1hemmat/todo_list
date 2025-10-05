// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'todo_hive.g.dart';

@HiveType(typeId: 0)
class TodoHive extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final bool isDone;

  @HiveField(4)
  final int difficulty;

  @HiveField(5)
  final DateTime? dueDate;

  @HiveField(6) // اضافه کردن فیلد جدید
  final DateTime? createdAt; // این فیلد جدید است

  TodoHive({
    required this.id,
    required this.title,
    this.description,
    this.isDone = false,
    required this.difficulty,
    this.dueDate,
    this.createdAt, // اضافه کردن به سازنده
  });
}
