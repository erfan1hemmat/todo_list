import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:todo_list/features/todos/domain/entities/todo.dart';
import 'package:todo_list/features/todos/presentation/providers/todo_notifier.dart';
import 'package:todo_list/l10n/app_localizations.dart';

class DoneTodoListPage extends ConsumerStatefulWidget {
  const DoneTodoListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DoneTodoListPageState();
}

class _DoneTodoListPageState extends ConsumerState<DoneTodoListPage> {
  String difficultyText(TodoDifficulty d, BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    switch (d) {
      case TodoDifficulty.easy:
        return loc.easy;
      case TodoDifficulty.medium:
        return loc.medium;
      case TodoDifficulty.hard:
        return loc.hard;
    }
  }

  Color difficultyColor(TodoDifficulty d) {
    switch (d) {
      case TodoDifficulty.easy:
        return Colors.green;
      case TodoDifficulty.medium:
        return Colors.orange;
      case TodoDifficulty.hard:
        return Colors.red;
    }
  }

  void _showTodoDetails(BuildContext context, Todo todo) {
    final loc = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            todo.title,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.lineThrough,
                                ),
                          ),
                        ),
                        Chip(
                          label: Text(
                            difficultyText(todo.difficulty, context),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: difficultyColor(todo.difficulty),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (todo.description != null &&
                        todo.description!.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          todo.description!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                decoration: TextDecoration.lineThrough,
                              ),
                          textAlign: TextAlign.justify,
                        ),
                      )
                    else
                      Center(
                        child: Text(
                          loc.noDescription,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                        ),
                      ),
                    const SizedBox(height: 16),
                    if (todo.dueDate != null)
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${loc.dueDate}: ${_formatDate(todo.dueDate!)}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          loc.close,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return "$day/$month/$year $hour:$minute";
  }

  String _getShortDescription(String? desc) {
    if (desc == null || desc.isEmpty) return "";
    return desc.length <= 50 ? desc : "${desc.substring(0, 50)}...";
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final todos = ref.watch(todoListProvider);
    final todosDone = todos.where((t) => t.isDone).toList();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(loc.completedTasks)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: todosDone.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/NoCompletedTasks.png',
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              )
            : AnimationLimiter(
                child: ListView.separated(
                  itemCount: todosDone.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final t = todosDone[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: SlideAnimation(
                          horizontalOffset: 10,
                          child: Dismissible(
                            key: ValueKey(t.id),
                            direction: DismissDirection.startToEnd,
                            background: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              return await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(loc.deleteTask),
                                  content: Text(loc.areYouSureDelete(t.title)),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text(loc.no),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text(loc.yesDelete),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (direction) {
                              ref.read(todoListProvider.notifier).remove(t.id);
                              Get.snackbar(
                                loc.deleted,
                                loc.taskDeleted(t.title),
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            },
                            child: GestureDetector(
                              onTap: () => _showTodoDetails(context, t),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: theme.dividerColor),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  leading: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    t.title,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                  ),
                                  subtitle: t.description != null
                                      ? Text(
                                          _getShortDescription(t.description),
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.7),
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                        )
                                      : null,
                                  trailing: Chip(
                                    label: Text(
                                      difficultyText(t.difficulty, context),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    backgroundColor: difficultyColor(
                                      t.difficulty,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
