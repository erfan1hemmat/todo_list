import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_list/core/theme/app_theme.dart';
import 'package:todo_list/features/todos/data/models/todo_hive.dart';
import 'package:todo_list/features/todos/data/repositories/hive_todo_repository.dart';
import 'package:todo_list/features/todos/presentation/pages/todo_list_page.dart';
import 'package:todo_list/features/todos/presentation/providers/todo_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TodoHiveAdapter());
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Tehran'));

  await AndroidAlarmManager.initialize();

  // init repo
  final repo = HiveTodoRepository();
  await repo.init();

  runApp(
    ProviderScope(
      overrides: [todoRepoProvider.overrideWithValue(repo)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GetMaterialApp(
      title: 'Todo App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // localizationsDelegates: const [
      //   AppLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      // ],
      // supportedLocales: const [
      //   Locale('en'),
      //   Locale('fa'),
      // ],
      home: const TodoListPage(),
    );
  }
}
