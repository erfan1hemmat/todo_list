// import 'package:todo_list/features/todos/domain/entities/todo.dart';
// import 'package:todo_list/features/todos/domain/repositories/todo_repository.dart';

// class InMemoryTodoRepository implements TodoRepository {
//   final List<Todo> _todos = [];

//   @override
//   Future<List<Todo>> getTodos() async => List.unmodifiable(_todos);

//   @override
//   Future<void> addTodo(Todo todo) async => _todos.add(todo);

//   @override
//   Future<void> updateTodo(Todo todo) async {
//     final i = _todos.indexWhere((t) => t.id == todo.id);
//     if (i >= 0) _todos[i] = todo;
//   }

//   @override
//   Future<void> deleteTodo(String id) async => _todos.removeWhere((t) => t.id == id);
// }
