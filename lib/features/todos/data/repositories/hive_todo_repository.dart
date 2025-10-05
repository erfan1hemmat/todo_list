import 'package:hive/hive.dart';
import 'package:todo_list/features/todos/data/models/todo_hive.dart';
import 'package:todo_list/features/todos/domain/entities/todo.dart';

class HiveTodoRepository {
  static const String boxName = 'todo';
  late final Box<TodoHive> _box;

  Future<void> init() async {
    _box = await Hive.openBox<TodoHive>(boxName);
  }

  Todo _fromHive(TodoHive h) {
    return Todo(
      id: h.id,
      title: h.title,
      description: h.description,
      isDone: h.isDone,
      difficulty: TodoDifficulty.values[h.difficulty],
      dueDate: h.dueDate,
      createdAt: h.createdAt ?? DateTime.now(), // اضافه کردن این خط
    );
  }

  TodoHive _toHive(Todo t) {
    return TodoHive(
      id: t.id,
      title: t.title,
      description: t.description,
      isDone: t.isDone,
      difficulty: t.difficulty.index,
      dueDate: t.dueDate,
      createdAt: t.createdAt, // اضافه کردن این خط
    );
  }

  Future<List<Todo>> getTodos() async {
    return _box.values.map(_fromHive).toList();
  }

  Future<void> addTodo(Todo todo) async {
    await _box.put(todo.id, _toHive(todo));
  }

  Future<void> updateTodo(Todo todo) async {
    await _box.put(todo.id, _toHive(todo));
  }

  Future<void> deleteTodo(String id) async {
    await _box.delete(id);
  }
}
