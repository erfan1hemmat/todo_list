enum TodoDifficulty { easy, medium, hard }

class Todo {
  final String id;
  final String title;
  final String? description;
  final bool isDone;
  final DateTime? dueDate; // تاریخ سررسید
  final TodoDifficulty difficulty;
  final DateTime? createdAt; // ⬅️ اضافه شد

  const Todo({
    required this.id,
    required this.title,
    this.description,
    this.isDone = false,
    this.dueDate,
    this.difficulty = TodoDifficulty.medium,
    this.createdAt, // ⬅️ اجباری
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isDone,
    DateTime? dueDate,
    TodoDifficulty? difficulty,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      dueDate: dueDate ?? this.dueDate,
      difficulty: difficulty ?? this.difficulty,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
