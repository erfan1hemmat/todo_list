import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:todo_list/features/todos/domain/entities/todo.dart';
import 'package:todo_list/features/todos/presentation/providers/todo_notifier.dart';

class AddTodoPage extends ConsumerStatefulWidget {
  const AddTodoPage({super.key});

  @override
  ConsumerState<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends ConsumerState<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _selectedDateTime;
  DateTime? _reminderTime;
  TodoDifficulty _selectedDifficulty = TodoDifficulty.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _pickReminder() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    setState(() {
      _reminderTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _saveTodo() async {
    if (!_formKey.currentState!.validate()) return;
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descController.text.isNotEmpty
          ? _descController.text
          : null,
      dueDate: _selectedDateTime,
      difficulty: _selectedDifficulty,
      createdAt: DateTime.now(), // ⬅️ مهم
    );

    try {
      await ref.read(todoListProvider.notifier).add(newTodo);

      // if (_reminderTime != null) {
      //   await ReminderService.scheduleReminder(newTodo);
      // }

      if (!mounted) return;
      Navigator.pop(context);

      Get.snackbar(
        "Success",
        "Task «${newTodo.title}» added",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Save failed: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Add New Task"), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTitleField(theme),
              const SizedBox(height: 20),
              _buildDescriptionField(theme),
              const SizedBox(height: 20),
              _buildDateTimeReminder(theme),
              const SizedBox(height: 20),
              _buildDifficulty(theme),
              const SizedBox(height: 30),
              _buildSaveButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField(ThemeData theme) {
    return Card(
      color: theme.cardColor,
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: "Enter task title...",
            border: InputBorder.none,
            prefixIcon: Icon(
              FontAwesomeIcons.heading,
              color: theme.colorScheme.primary,
            ),
          ),
          style: theme.textTheme.bodyLarge,
          validator: (v) => v == null || v.isEmpty ? "Title is required" : null,
        ),
      ),
    );
  }

  Widget _buildDescriptionField(ThemeData theme) {
    return Card(
      color: theme.cardColor,
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextFormField(
          controller: _descController,
          decoration: InputDecoration(
            hintText: "Enter task description...",
            border: InputBorder.none,
            prefixIcon: Icon(
              FontAwesomeIcons.alignLeft,
              color: theme.colorScheme.primary,
            ),
          ),
          style: theme.textTheme.bodyLarge,
          maxLines: 5,
        ),
      ),
    );
  }

  Widget _buildDateTimeReminder(ThemeData theme) {
    return Column(
      children: [
        _buildMinimalCard(
          icon: FontAwesomeIcons.calendarAlt,
          title: "Due Date",
          subtitle: _selectedDateTime == null
              ? ["Not set"]
              : [
                  "${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year}",
                  "${_selectedDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}",
                ],
          onTap: _pickDateTime,
          theme: theme,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildMinimalCard({
    required IconData icon,
    required String title,
    required List<String> subtitle,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: theme.cardColor,
        elevation: 1.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.transparent,
                child: Icon(icon, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  ...subtitle.map(
                    (line) => Text(
                      line,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficulty(ThemeData theme) {
    return Card(
      color: theme.cardColor,
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.flag,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  "Difficulty Level",
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _difficultySelector(),
          ],
        ),
      ),
    );
  }

  Widget _difficultySelector() {
    return Wrap(
      spacing: 12,
      children: TodoDifficulty.values.map((difficulty) {
        final isSelected = _selectedDifficulty == difficulty;
        final color = _getDifficultyColor(difficulty);
        return GestureDetector(
          onTap: () => setState(() => _selectedDifficulty = difficulty),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              difficulty.name.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getDifficultyColor(TodoDifficulty difficulty) {
    switch (difficulty) {
      case TodoDifficulty.easy:
        return Colors.greenAccent.shade700;
      case TodoDifficulty.medium:
        return Colors.orangeAccent.shade700;
      case TodoDifficulty.hard:
        return Colors.redAccent.shade700;
    }
  }

  Widget _buildSaveButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        icon: const Icon(FontAwesomeIcons.solidSave, size: 18),
        label: const Text(
          "Save Task",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: _saveTodo,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
