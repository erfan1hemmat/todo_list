// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'برنامه انجام کارها';

  @override
  String get helloWorld => 'سلام دنیا';

  @override
  String get tasks => 'کارها';

  @override
  String get searchTasks => 'جستجوی کارها...';

  @override
  String noResultsFound(Object query) {
    return 'نتیجه‌ای برای \'$query\' یافت نشد';
  }

  @override
  String get noActiveTasks => 'هیچ کار فعالی وجود ندارد';

  @override
  String get home => 'خانه';

  @override
  String get completed => 'انجام شده ها';

  @override
  String get completedTasks => 'تسک‌های انجام شده';

  @override
  String get noCompletedTasks => 'هیچ کار انجام شده‌ای وجود ندارد';

  @override
  String get addNewTask => 'افزودن کار جدید';

  @override
  String get enterTaskTitle => 'عنوان کار را وارد کنید...';

  @override
  String get titleRequired => 'عنوان الزامی است';

  @override
  String get enterTaskDescription => 'توضیحات کار را وارد کنید...';

  @override
  String get createdat => 'ساخته شده در';

  @override
  String get dueDate => 'تاریخ سررسید';

  @override
  String get noDescription => 'توضیحی وجود ندارد';

  @override
  String get close => 'بستن';

  @override
  String get deleteTask => 'حذف کار';

  @override
  String areYouSureDelete(Object title) {
    return 'آیا مطمئن هستید که \'$title\' حذف شود؟';
  }

  @override
  String get yesDelete => 'بله، حذف شود';

  @override
  String get no => 'خیر';

  @override
  String get easy => 'آسان';

  @override
  String get medium => 'متوسط';

  @override
  String get hard => 'سخت';

  @override
  String get deleted => 'حذف شد';

  @override
  String taskDeleted(Object title) {
    return 'کار \'$title\' حذف شد';
  }

  @override
  String get notSet => 'تعیین نشده';

  @override
  String get difficultyLevel => 'سطح دشواری';

  @override
  String get saveTask => 'ذخیره کار';

  @override
  String get success => 'موفق';

  @override
  String taskAdded(Object title) {
    return 'کار «$title» اضافه شد';
  }

  @override
  String get error => 'خطا';

  @override
  String saveFailed(Object error) {
    return 'ذخیره ناموفق: $error';
  }

  @override
  String get markAsDone => 'انجام شد';

  @override
  String areYouSureMarkDone(Object title) {
    return 'آیا مطمئن هستید که \'$title\' انجام شود؟';
  }

  @override
  String get done => 'انجام شد';

  @override
  String taskCompleted(Object title) {
    return 'کار \'$title\' انجام شد!';
  }

  @override
  String get progress => 'پیشرفت';

  @override
  String daysRemaining(Object days) {
    return '$days روز باقی مانده';
  }

  @override
  String get overdue => 'تاریخ گذشته!';

  @override
  String get lessThanAMinuteRemaining => 'کمتر از یک دقیقه باقی مانده';

  @override
  String hoursRemaining(Object hours) {
    return '$hours ساعت باقی مانده';
  }

  @override
  String minutesRemaining(Object minutes) {
    return '$minutes دقیقه باقی مانده';
  }

  @override
  String get darkmode => 'حالت شب فعال شد';

  @override
  String get lightmode => 'حالت روز فعال شد';
}
