import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:todo_list/features/todos/domain/entities/todo.dart';
import 'package:todo_list/features/todos/presentation/pages/add_todo_page.dart';
import 'package:todo_list/features/todos/presentation/pages/done_todo_list_page.dart';
import 'package:todo_list/features/todos/presentation/providers/todo_notifier.dart';

class TodoListPage extends ConsumerStatefulWidget {
  const TodoListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TodoListPageState();
}

class _TodoListPageState extends ConsumerState<TodoListPage> {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  String _searchQuery = "";

  String difficultyText(TodoDifficulty d) {
    switch (d) {
      case TodoDifficulty.easy:
        return "Easy";
      case TodoDifficulty.medium:
        return "Medium";
      case TodoDifficulty.hard:
        return "Hard";
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
            return LayoutBuilder(
              builder: (context, constraints) {
                final contentHeight = _calculateContentHeight(context, todo);
                final sheetHeight =
                    contentHeight / MediaQuery.of(context).size.height;
                final finalHeight = sheetHeight.clamp(0.3, 0.85);

                return SizedBox(
                  height: finalHeight * MediaQuery.of(context).size.height,
                  child: Container(
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
                      child: _buildBottomSheetContent(context, todo),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildBottomSheetContent(BuildContext context, Todo todo) {
    String formatDate(DateTime dt) =>
        "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
    String formatTime(DateTime dt) =>
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";

    return SingleChildScrollView(
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
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Chip(
                label: Text(
                  difficultyText(todo.difficulty),
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
          if (todo.description != null && todo.description!.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                todo.description!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
            )
          else
            Center(
              child: Text(
                "No description",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ),
          const SizedBox(height: 16),
          if (todo.dueDate != null)
            Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // تاریخ ایجاد - با آیکون متفاوت
                Row(
                  children: [
                    Icon(
                      Icons.create, // آیکون ایجاد
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "CreatedAt : ${formatDate(todo.createdAt!)} ${formatTime(todo.createdAt!)}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),

                // تاریخ سررسید - با آیکون متفاوت
                Row(
                  children: [
                    Icon(
                      Icons.event_available, // آیکون سررسید
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Due Date : ${formatDate(todo.dueDate!)} ${formatTime(todo.dueDate!)}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Close", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(Todo todo) {
    final progress = _calculateProgress(todo);
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progress),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Progress",
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                Text(
                  "${(value * 100).toStringAsFixed(0)}%",
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 8,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getTimeRemainingText(todo),
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        );
      },
    );
  }

  // تابع جدید برای نمایش متن زمان باقی‌مانده
  String _getTimeRemainingText(Todo todo) {
    if (todo.dueDate == null) return "No due date";

    final now = DateTime.now();
    final dueDate = todo.dueDate!;

    if (now.isAfter(dueDate)) {
      return "Overdue!";
    }

    final difference = dueDate.difference(now);

    if (difference.inDays > 0) {
      return "${difference.inDays} days remaining";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hours remaining";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minutes remaining";
    } else {
      return "Less than a minute remaining";
    }
  }

  Color _progressColor(double progress) {
    if (progress < 0.01) return Colors.green;
    if (progress < 0.25) return Colors.green;
    if (progress < 0.5) return Colors.yellow;
    if (progress < 0.75) return Colors.orange;
    return Colors.red;
  }

  double _calculateProgress(Todo todo) {
    final creationDate = todo.createdAt ?? DateTime.now();

    if (todo.dueDate == null) {
      return 0.0;
    }

    final now = DateTime.now();
    final dueDate = todo.dueDate!;

    if (dueDate.isBefore(creationDate)) {
      return 1.0;
    }

    if (now.isAfter(dueDate)) {
      return 1.0;
    }

    if (now.isBefore(creationDate)) {
      return 0.0;
    }

    final totalDuration = dueDate.difference(creationDate).inSeconds;
    final elapsedDuration = now.difference(creationDate).inSeconds;

    if (totalDuration <= 0) {
      return 0.0;
    }

    double progress = elapsedDuration / totalDuration;

    return progress.clamp(0.0, 1.0);
  }

  double _calculateContentHeight(BuildContext context, Todo todo) {
    double height = 16;
    height += 24 + 16;
    height += 16;
    if (todo.description != null && todo.description!.isNotEmpty) {
      height += 20 + (todo.description!.length / 2);
    } else {
      height += 40;
    }
    if (todo.dueDate != null) height += 40;
    height += 24;
    height += 56;
    height += 16;
    return height;
  }

  List<Widget> _buildScreens() {
    return [_todoListScreen(), const DoneTodoListPage()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    final theme = Theme.of(context);
    return [
      PersistentBottomNavBarItem(
        icon: const FaIcon(FontAwesomeIcons.house, size: 26),
        title: "Home",
        activeColorPrimary: theme.colorScheme.primary,
        inactiveColorPrimary: theme.colorScheme.onSurface.withOpacity(0.6),
      ),
      PersistentBottomNavBarItem(
        icon: const FaIcon(FontAwesomeIcons.check, size: 26),
        title: "Completed",
        activeColorPrimary: theme.colorScheme.primary,
        inactiveColorPrimary: theme.colorScheme.onSurface.withOpacity(0.6),
      ),
    ];
  }

  // تابع جدید برای نمایش فقط روزهای باقی‌مانده
  Widget _buildDaysRemaining(Todo todo) {
    if (todo.dueDate == null) return const SizedBox();

    final now = DateTime.now();
    final dueDate = todo.dueDate!;

    if (now.isAfter(dueDate)) {
      return const Text(
        "Overdue!",
        style: TextStyle(
          fontSize: 12,
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    final difference = dueDate.difference(now);

    return Text(
      "${difference.inDays} days left",
      style: TextStyle(
        fontSize: 12,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _todoListScreen() {
    final todos = ref.watch(todoListProvider);
    final theme = Theme.of(context);

    List<Todo> filteredTodos() {
      final activeTodos = todos.where((t) => !t.isDone).toList();
      if (_searchQuery.isEmpty) return activeTodos;
      return activeTodos.where((t) {
        final titleMatch = t.title.toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
        final descMatch =
            t.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
            false;
        return titleMatch || descMatch;
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        elevation: 0, // حذف سایه از AppBar
        scrolledUnderElevation: 0, // جلوگیری از نمایش سایه هنگام اسکرول
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const AddTodoPage(), transition: Transition.fadeIn);
        },
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        child: const FaIcon(FontAwesomeIcons.plus, size: 20),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search tasks...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
            ),
          ),
          Expanded(
            child: Builder(
              builder: (_) {
                final activeTodos = filteredTodos();
                if (activeTodos.isEmpty) {
                  if (_searchQuery.isNotEmpty) {
                    // 📌 فقط متن برای حالت بدون نتیجه جستجو
                    return Center(
                      child: Text(
                        "No results found for '$_searchQuery'",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    // 📌 تصویر و متن برای حالت بدون تسک فعال
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/NoActiveTasks.png',
                            width: 200,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    );
                  }
                }

                return AnimationLimiter(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: activeTodos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final t = activeTodos[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 50,
                          child: FadeInAnimation(
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
                                    title: const Text("Delete Task"),
                                    content: Text(
                                      "Are you sure you want to delete '${t.title}'?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text("No"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text("Yes, Delete"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onDismissed: (direction) {
                                ref
                                    .read(todoListProvider.notifier)
                                    .remove(t.id);
                                Get.snackbar(
                                  "Deleted",
                                  "Task '${t.title}' deleted",
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
                                    border: Border.all(
                                      color: theme.dividerColor,
                                    ),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    leading: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Checkbox(
                                        value: t.isDone,
                                        onChanged: (value) async {
                                          if (value == true) {
                                            final confirmed = await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                  "Mark as Done",
                                                ),
                                                content: Text(
                                                  "Are you sure you want to mark '${t.title}' as done?",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(false),
                                                    child: const Text("No"),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(true),
                                                    child: const Text("Yes"),
                                                  ),
                                                ],
                                              ),
                                            );

                                            if (confirmed == true) {
                                              ref
                                                  .read(
                                                    todoListProvider.notifier,
                                                  )
                                                  .toggle(t.id);
                                              Get.snackbar(
                                                "Done",
                                                "Task '${t.title}' completed!",
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor: Colors.green,
                                                colorText: Colors.white,
                                                duration: const Duration(
                                                  seconds: 2,
                                                ),
                                              );
                                            }
                                          } else {
                                            ref
                                                .read(todoListProvider.notifier)
                                                .toggle(t.id);
                                          }
                                        },
                                      ),
                                    ),
                                    title: Text(
                                      t.title,
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (t.description != null)
                                          Text(
                                            t.description!,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface
                                                      .withOpacity(0.7),
                                                ),
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        // نمایش فقط روزهای باقی‌مانده به جای نوار پیشرفت
                                        if (t.dueDate != null)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                            ),
                                            child: _buildDaysRemaining(t),
                                          ),
                                      ],
                                    ),
                                    trailing: Chip(
                                      label: Text(
                                        difficultyText(t.difficulty),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineToSafeArea: true,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarStyle: NavBarStyle.style14,
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
          Colors.black,
    );
  }
}
