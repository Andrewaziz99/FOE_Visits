
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:visits/shared/network/local/cache_helper.dart';

import '../../modules/Auth/login/login_screen.dart';
import 'components.dart';

final String pass = CacheHelper.getData(key: 'password');
const String wrongPass = 'خطأ فى كلمة المرور';
const String region = 'القطاع';

const String add_new_visitor = 'اضافة زائر جديد';

void signOut(context) {
  CacheHelper.removeData(key: 'loggedIn').then((value) {
      navigateAndFinish(context, LoginScreen());
  });
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

const String MUSTQBL_MISR = 'جهاز مستقبل مصر للتنمية المستدامة';
const String DEPT_NAME = 'قطاع الضبعة';
const String OFFICE = 'مكتب السيد/ مدير الجهاز';

const user = 'استقبال';

const String selectDate = 'اختر التاريخ';

const String addWarning = 'برجاء إضافة بيانات الزائر أولاً من +';

const String addVisit = 'اضافة زيارة';
const String complaining = 'تسجيل شكوى';
const String archive = 'أرشيف';
const String dailyVisits = 'الزيارات اليومية';
const String agenda = 'الأجندة';
const String totalVisitsNumber = 'عدد مرات التردد';

const String appName = 'الزيارات اليومية';

const String visitsLogs = 'سجل الزيارات';
const String dailyVisitsLogs = 'سجل الزيارات اليومي';

const String newVisitDescription = 'تم اضافة زيارة جديدة';
const String view = 'عرض';
const String settings = 'الاعدادات';
const String activate_gifs = 'تفعيل الرسوم المتحركة';

const String visitorExists = 'هذا الزائر موجود بالفعل';

const String visits_data = 'بيانات الزيارات';

DateTime selectedDate = DateTime.now();
const String loading = 'جارى التحميل...';

const String username = 'اسم المستخدم';
const String password = 'كلمة المرور';
const String login = 'تسجيل الدخول';
const String logout = 'تسجيل الخروج';
const String register = 'تسجيل جديد';
const String usernameError = 'يجب ادخال اسم المستخدم';
const String passwordError = 'يجب ادخال كلمة المرور';
const String confirm = 'تأكيد';
const String done = 'تم';
const String cancel = 'الغاء';
const String back = 'رجوع';
const String exit = 'خروج';

const String changePassword = 'تغيير كلمة المرور';
const String oldPassword = 'كلمة المرور القديمة';
const String newPassword = 'كلمة المرور الجديدة';

const String changePasswordDone = 'تم تغيير كلمة المرور بنجاح';

const String loginSuccess = 'تم تسجيل الدخول بنجاح';
const String loginError = 'خطأ فى اسم المستخدم او كلمة المرور';

const String registerSuccess = 'تم تسجيل الحساب بنجاح';
const String registerError = 'خطأ فى تسجيل الحساب';

const String add = 'اضافة';
const String edit = 'تعديل';
const String editData = 'تعديل البيانات';
const String delete = 'حذف';
const String save = 'حفظ';
const String search = 'بحث';
const String close = 'اغلاق';

const String addComplaint = 'اضافة شكوى';

const String addSuccess = 'تمت الاضافة بنجاح';
const String editSuccess = 'تم التعديل بنجاح';
const String deleteSuccess = 'تم الحذف بنجاح';

const String addError = 'خطأ فى الاضافة';
const String editError = 'خطأ فى التعديل';
const String deleteError = 'خطأ فى الحذف';

const String confirmDelete = 'هل انت متأكد من حذف هذا العنصر؟';

const String newVisit = 'زيارة جديدة';

const String name_other = 'الاسم أو اخرى';

const String startDate = 'تاريخ بداية الزيارة';
const String endDate = 'تاريخ نهاية الزيارة';

const String rank = 'الرتبة';
const String name = 'الاسم';
const String phoneNo = 'رقم الهاتف';
const String additionalPhoneNo = 'رقم الهاتف الاضافى';
const String department = 'الجهة التابع لها';
const String departmentOrJob = 'الجهة أو الوظيفة';
const String visitDestination = 'جهة الزيارة';
const String visitReason = 'سبب الزيارة';
const String visitDate = 'تاريخ الزيارة';
const String feedback = 'ملاحظات';
const String nationalId = 'الرقم القومى';
const String address = 'العنوان';

const String subject = 'سبب الزيارة';
const String complaint = 'موضوع الشكوى';

const String error = 'خطأ';
const String warning = 'تحذير';
const String success = 'نجاح';
const String info = 'معلومة';

const String noData = 'لا يوجد بيانات';

const String imageSuccess = 'تم تغيير الصورة بنجاح';

const String rankError = 'يجب ادخال الرتبة';
const String nameError = 'يجب ادخال الاسم';
const String phoneNoError = 'يجب ادخال رقم الهاتف';
const String additionalPhoneNoError = 'يجب ادخال رقم الهاتف الاضافى';
const String departmentError = 'يجب ادخال الجهة التابع لها';
const String visitDestinationError = 'يجب ادخال جهة الزيارة';
const String visitReasonError = 'يجب ادخال سبب الزيارة';
const String visitDateError = 'يجب ادخال تاريخ الزيارة';
const String emptyDataError = 'لا يمكن ترك البيانات فارغة';
const String complaintError = 'يجب ادخال موضوع الشكوى';
const String nationalIdError = 'يجب ادخال الرقم القومى';
const String addressError = 'يجب ادخال العنوان';

const String phoneNoFormatError = 'رقم الهاتف يجب أن يكون 11 رقمًا';
const String nationalIdFormatError = 'الرقم القومى يجب أن يكون 14 رقمًا';

const String addSuccessMessage = 'تمت الاضافة بنجاح';
const String addErrorMessage = 'خطأ فى الاضافة';

const String getErrorMessage = 'حدث خطأ';

const String notificationMsg = 'تم اضافة زيارة جديدة';

const String visitCount = 'عدد الزيارات';

var msg = '';


const String engRegister = 'تسجيل المهندسين';

const List<String> visitSubject = [
  'مقابلة مع السيد/ مدير الجهاز',
  'إجتماع مع السيد/ مدير الجهاز',
  'تسليم أوراق',
  'إستلام أوراق',
  'مقابلة مع سكرتارية السيد/ مدير الجهاز',
  'مقابلة مع مدير مكتب السيد/ مدير الجهاز',
  'إستفسارات',
];

const List<String> ranks = [
  'جندى',
  'عريف',
  'رقيب',
  'رقيب أول',
  'مساعد',
  'مساعد أول',
  'ملازم',
  'ملازم أول',
  'نقيب',
  'رائد',
  'مقدم',
  'عقيد',
  'عميد',
  'لواء',
  'مدنى',
  'مهندس',
  'محاسب',
  'دكتور',
  'مدني',
  'مستشار',
  'مدير',
  'مدير شركة',
];

class Regions{
  String label;
  int value;

  Regions({required this.label, required this.value});
}

List<Regions> regions = [
Regions(label: 'قطاع الضبعة', value: 0),
Regions(label: 'قطاع دار القوات الجوية', value: 1),
];

Map<String, String> arabicDigits = {
  '0': '٠',
  '1': '١',
  '2': '٢',
  '3': '٣',
  '4': '٤',
  '5': '٥',
  '6': '٦',
  '7': '٧',
  '8': '٨',
  '9': '٩',
};

Map<String, String> weekDays = {
  'saturday': 'السبت',
  'sunday': 'الأحد',
  'monday': 'الإثنين',
  'tuesday': 'الثلاثاء',
  'wednesday': 'الأربعاء',
  'thursday': 'الخميس',
  'friday': 'الجمعة',
};

String getWeekDay(String day) {
  return weekDays[day.toLowerCase()]!;
}

// enum Weekday {
//   saturday('Saturday', 'السبت'),
//   sunday('Sunday', 'الأحد'),
//   monday('Monday', 'الإثنين'),
//   tuesday('Tuesday', 'الثلاثاء'),
//   wednesday('Wednesday', 'الأربعاء'),
//   thursday('Thursday', 'الخميس'),
//   friday('Friday', 'الجمعة');
// }

String convertToArabic(String text) {
  return text.split('').map((char) {
    return arabicDigits[char] ?? char;
  }).join();
}

String convertArabicToEnglish(String text) {
  // Arabic digits
  const arabicDigits = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };

  // Convert Arabic digits to English
  return text.split('').map((char) {
    return arabicDigits[char] ??
        char; // Replace with English digit or keep original
  }).join();
}

class ArabicNumbersInputFormatter extends TextInputFormatter {
  // Map to convert English digits (0-9) to Arabic-Indic digits (٠-٩)
  final Map<String, String> arabicDigits = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
  };

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Replace digits with their Arabic-Indic equivalents
    String newText = newValue.text.split('').map((char) {
      return arabicDigits[char] ??
          char; // Use Arabic digit or the same character if it's not a digit
    }).join();

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}


Future<void> pickTemplatesFolder() async {
  try {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      print("Selected folder: $selectedDirectory");
      CacheHelper.saveData(key: 'templates_folder', value: selectedDirectory);
    } else {
      print("Folder selection canceled.");
    }
  } catch (e) {
    print("An error occurred while picking folder: $e");
  }
}


Future<String> getTemplatesFolder() async {
  final templatesFolder = await CacheHelper.getData(key: 'templates_folder');
  return templatesFolder;
}

Future<void> getPassword() async{
  CacheHelper.getData(key: 'password');
}