import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:todo_list/features/todos/domain/entities/todo.dart';
import 'package:todo_list/features/todos/presentation/pages/add_todo_page.dart';
import 'package:todo_list/features/todos/presentation/pages/done_todo_list_page.dart';
import 'package:todo_list/features/todos/presentation/providers/settings_provider.dart';
import 'package:todo_list/features/todos/presentation/providers/todo_notifier.dart';
import 'package:todo_list/l10n/app_localizations.dart';

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
            return LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: 400,
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
    final loc = AppLocalizations.of(context)!;

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
                loc.noDescription,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ),
          const SizedBox(height: 16),
          if (todo.dueDate != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.create,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${loc.createdat} : ${formatDate(todo.createdAt!)} ${formatTime(todo.createdAt!)}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.event_available,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${loc.dueDate} : ${formatDate(todo.dueDate!)} ${formatTime(todo.dueDate!)}",
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
              child: Text(loc.close, style: const TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  // مثال برای placeholder با تعداد روز
  Widget _buildDaysRemaining(Todo todo) {
    final loc = AppLocalizations.of(context)!;
    if (todo.dueDate == null) return const SizedBox();

    final now = DateTime.now();
    final dueDate = todo.dueDate!;

    if (now.isAfter(dueDate)) {
      return Text(
        loc.overdue,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    final difference = dueDate.difference(now);

    return Text(
      loc.daysRemaining(difference.inDays),
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
    final loc = AppLocalizations.of(context)!;

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
        leading: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: PopupMenuButton<Locale>(
            icon: const Icon(FontAwesomeIcons.globe, size: 26),
            tooltip: "",
            onSelected: (locale) {
              ref.read(localeProvider.notifier).toggleLocale();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: Locale('en'),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.globe, size: 18),
                    SizedBox(width: 8),
                    Text('English'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: Locale('fa'),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.globe, size: 18),
                    SizedBox(width: 8),
                    Text('فارسی'),
                  ],
                ),
              ),
            ],
          ),
        ),
        title: Text(loc.tasks),
        centerTitle: true,
        actions: [
          // Custom Switch برای تغییر تم
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: GestureDetector(
              onTap: () {
                ref.read(themeProvider.notifier).toggleTheme();
                final isDark = ref.read(themeProvider) == ThemeMode.dark;
                Get.snackbar(
                  isDark ? loc.lightmode : loc.darkmode,
                  "",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.blueGrey.shade800,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                  margin: const EdgeInsets.all(12),
                  borderRadius: 12,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                width: 70,
                height: 36,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ref.watch(themeProvider) == ThemeMode.dark
                      ? Colors.grey.shade900
                      : Colors.yellow.shade600,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // توپ سوییچ
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOutBack,
                      left: ref.watch(themeProvider) == ThemeMode.dark ? 34 : 0,
                      right: ref.watch(themeProvider) == ThemeMode.dark
                          ? 0
                          : 34,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.6),
                              blurRadius: 2,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          ref.watch(themeProvider) == ThemeMode.dark
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          size: 18,
                          color: ref.watch(themeProvider) == ThemeMode.dark
                              ? Colors.black
                              : Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: loc.searchTasks,
                  hintStyle: TextStyle(
                    color: Theme.of(context).hintColor.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _searchQuery.isEmpty
                        ? Icon(
                            FontAwesomeIcons.search,
                            key: const ValueKey('search_icon'),
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          )
                        : Icon(
                            FontAwesomeIcons.search,
                            key: const ValueKey('search_icon_active'),
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.7),
                            size: 24,
                          ),
                  ),

                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim();
                  });
                },
              ),
            ),
          ),

          Expanded(
            child: Builder(
              builder: (_) {
                final activeTodos = filteredTodos();
                if (activeTodos.isEmpty) {
                  if (_searchQuery.isNotEmpty) {
                    return Center(
                      child: Text(
                        loc.noResultsFound(_searchQuery),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
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

                // ... ادامه لیست تسک‌ها بدون تغییر متن استاتیک

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
                                    title: Text(loc.deleteTask),
                                    content: Text(
                                      loc.areYouSureDelete(t.title),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text(loc.close),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text(loc.deleteTask),
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
                                            final confirmed =
                                                await showDialog<bool>(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        title: Text(
                                                          loc.markAsDone,
                                                        ),
                                                        content: Text(
                                                          loc.areYouSureMarkDone(
                                                            t.title,
                                                          ),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                  context,
                                                                ).pop(false),
                                                            child: Text(
                                                              loc.close,
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                  context,
                                                                ).pop(true),
                                                            child: Text(
                                                              loc.done,
                                                            ),
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
                                                loc.done,
                                                loc.taskCompleted(t.title),
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

  List<Widget> _buildScreens() {
    return [_todoListScreen(), const DoneTodoListPage()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    return [
      PersistentBottomNavBarItem(
        icon: const FaIcon(FontAwesomeIcons.house, size: 26),
        title: loc.home,
        activeColorPrimary: theme.colorScheme.primary,
        inactiveColorPrimary: theme.colorScheme.onSurface.withOpacity(0.6),
      ),
      PersistentBottomNavBarItem(
        icon: const FaIcon(FontAwesomeIcons.check, size: 26),
        title: loc.completed,
        activeColorPrimary: theme.colorScheme.primary,
        inactiveColorPrimary: theme.colorScheme.onSurface.withOpacity(0.6),
      ),
    ];
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
