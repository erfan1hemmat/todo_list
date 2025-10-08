// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Todo App';

  @override
  String get helloWorld => 'Hello World';

  @override
  String get tasks => 'Tasks';

  @override
  String get searchTasks => 'Search tasks...';

  @override
  String noResultsFound(Object query) {
    return 'No results found for \'$query\'';
  }

  @override
  String get noActiveTasks => 'No active tasks';

  @override
  String get home => 'Home';

  @override
  String get completed => 'Completed';

  @override
  String get completedTasks => 'Completed Tasks';

  @override
  String get noCompletedTasks => 'No completed tasks';

  @override
  String get addNewTask => 'Add New Task';

  @override
  String get enterTaskTitle => 'Enter task title...';

  @override
  String get titleRequired => 'Title is required';

  @override
  String get enterTaskDescription => 'Enter task description...';

  @override
  String get createdat => 'CreatedAt';

  @override
  String get dueDate => 'Due Date';

  @override
  String get noDescription => 'No description';

  @override
  String get close => 'Close';

  @override
  String get deleteTask => 'Delete Task';

  @override
  String areYouSureDelete(Object title) {
    return 'Are you sure you want to delete \'$title\'?';
  }

  @override
  String get yesDelete => 'Yes, Delete';

  @override
  String get no => 'No';

  @override
  String get easy => 'Easy';

  @override
  String get medium => 'Medium';

  @override
  String get hard => 'Hard';

  @override
  String get deleted => 'Deleted';

  @override
  String taskDeleted(Object title) {
    return 'Task \'$title\' deleted';
  }

  @override
  String get notSet => 'Not set';

  @override
  String get difficultyLevel => 'Difficulty Level';

  @override
  String get saveTask => 'Save Task';

  @override
  String get success => 'Success';

  @override
  String taskAdded(Object title) {
    return 'Task «$title» added';
  }

  @override
  String get error => 'Error';

  @override
  String saveFailed(Object error) {
    return 'Save failed: $error';
  }

  @override
  String get markAsDone => 'Mark as Done';

  @override
  String areYouSureMarkDone(Object title) {
    return 'Are you sure you want to mark \'$title\' as done?';
  }

  @override
  String get done => 'Done';

  @override
  String taskCompleted(Object title) {
    return 'Task \'$title\' completed!';
  }

  @override
  String get progress => 'Progress';

  @override
  String daysRemaining(Object days) {
    return '$days days left';
  }

  @override
  String get overdue => 'Overdue!';

  @override
  String get lessThanAMinuteRemaining => 'Less than a minute remaining';

  @override
  String hoursRemaining(Object hours) {
    return '$hours hours remaining';
  }

  @override
  String minutesRemaining(Object minutes) {
    return '$minutes minutes remaining';
  }

  @override
  String get darkmode => 'Dark Mode Activated';

  @override
  String get lightmode => 'Light Mode Activated';
}
