import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:todo_list/features/todos/data/repositories/hive_todo_repository.dart';
import 'package:todo_list/features/todos/domain/entities/todo.dart';

final todoRepoProvider = Provider<HiveTodoRepository>(
  (ref) => throw UnimplementedError(),
);

// notifier provider
final todoListProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  final repo = ref.watch(todoRepoProvider);
  return TodoNotifier(repo);
});

class TodoNotifier extends StateNotifier<List<Todo>> {
  final HiveTodoRepository repository;
  TodoNotifier(this.repository) : super([]) {
    load(); // ⬅️ اینجا اضافه شد
  }

  Future<void> load() async {
    final todos = await repository.getTodos();
    todos.sort(_sortTodos); // مرتب‌سازی
    state = todos;
  }

  int _sortTodos(Todo a, Todo b) {
    // اولویت: Hard > Medium > Easy
    int difficultyCompare = b.difficulty.index.compareTo(a.difficulty.index);
    if (difficultyCompare != 0) return difficultyCompare;

    // بعد اولویت تاریخ نزدیک‌تر
    if (a.dueDate != null && b.dueDate != null) {
      return a.dueDate!.compareTo(b.dueDate!);
    } else if (a.dueDate != null) {
      return -1; // a قبل از b
    } else if (b.dueDate != null) {
      return 1; // b قبل از a
    }
    return 0;
  }

  Future<void> add(Todo t) async {
    await repository.addTodo(t);
    final todos = await repository.getTodos();
    todos.sort(_sortTodos); // ⬅️ مرتب‌سازی
    state = todos;
  }

  Future<void> toggle(String id) async {
    final t = state.firstWhere((e) => e.id == id);
    final updated = t.copyWith(isDone: !t.isDone);
    await repository.updateTodo(updated);
    final todos = await repository.getTodos();
    todos.sort(_sortTodos); // ⬅️ مرتب‌سازی
    state = todos;
  }

  Future<void> remove(String id) async {
    await repository.deleteTodo(id);
    final todos = await repository.getTodos();
    todos.sort(_sortTodos); // ⬅️ مرتب‌سازی
    state = todos;
  }
}
