import 'package:todo_list/features/todos/domain/entities/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<void> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
}
