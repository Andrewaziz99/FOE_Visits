import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:docx_template/docx_template.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visits/modules/Complaining/cubit/states.dart';
import '../../../models/Visitor/visitor_model.dart';
import '../../../shared/components/constants.dart';
import '../../../models/Complaining/complaining_model.dart';

class ComplainingCubit extends Cubit<ComplainingStates> {
  ComplainingCubit() : super(ComplainingInitial());

  static ComplainingCubit get(context) => BlocProvider.of(context);

  final supabase = Supabase.instance.client;

  List<VisitorModel>? visitors;

  Future<void> getVisitors() async {
    emit(getVisitorsLoadingState());
    await supabase.from('visitors').select().then((value) {
      visitors = value.map((e) => VisitorModel.fromJson(e)).toList();
      emit(getVisitorsSuccessState());
    }).catchError((error) {
      emit(getVisitorsErrorState(error));
      print(error);
    });
  }

  List<VisitorModel> searchByPhoneResults = [];

  Future<void> searchByPhone(String search) async {
    emit(searchByPhoneLoading());
    await supabase
        .from('visitors')
        .select()
        .ilike('phone_number', '%$search%')
        .then((value) {
      searchByPhoneResults =
          value.map((e) => VisitorModel.fromJson(e)).toList();
      emit(searchByPhoneSuccess());
    }).catchError((error) {
      emit(searchByPhoneError(error));
      print(error);
    });
  }

  List<VisitorModel> searchByNameResults = [];

  Future<void> searchByName(String search) async {
    emit(searchByNameLoading());
    await supabase
        .from('visitors')
        .select()
        .ilike('name', '%$search%')
        .then((value) {
      searchByNameResults = value.map((e) => VisitorModel.fromJson(e)).toList();
      emit(searchByNameSuccess());
    }).catchError((error) {
      emit(searchByNameError(error));
      print(error);
    });
  }

  List<String> departments = [];

  void getDepartments() {
    emit(getDepartmentsLoading());
    supabase.from('departments').select().then((value) {
      departments = value.map((e) => e['depName'] as String).toList();
      emit(getDepartmentsSuccess(departments));
    }).catchError((error) {
      emit(getDepartmentsError(error));
      print(error);
    });
  }

  final currentDate =
      convertToArabic(DateFormat('yyyy/MM/dd').format(DateTime.now()));
  final dayDate =
      convertToArabic(DateFormat('yyyy-MM-dd').format(DateTime.now()));

  Future<void> printComplaint(ComplainingModel complaint) async {
    emit(printComplaintLoading());
    final weekday = getWeekDay(DateFormat('EEEE').format(DateTime.now()));
    String? docPath;
    try {
      // Locate and read the template
      final appDir = await getTemplatesFolder();
      final docFile = File('$appDir\\complaints_template.docx');

      if (!await docFile.exists()) {
        msg = "complaints_template file not found: ${docFile.path}";
        throw Exception("complaints_template file not found: ${docFile.path}");
      }

      final docBytes = await docFile.readAsBytes();
      final doc = await DocxTemplate.fromBytes(docBytes);

      // Create a list of rows for the table content

      final logo = await File('$appDir\\logo1.png').readAsBytes();

      //set date as 2025/06/10 07:00 AM from the complaint submit date
      final date = DateFormat('a hh:mm - yyyy/MM/dd')
          .format(complaint.submitDate.toLocal());

      //Fetch the attachments if available
      String? attachments =
          complaint.attachments != null && complaint.attachments!.isNotEmpty
              ? complaint.attachments
              : null;
      // Get the attachments folder path
      final attachmentsFolder = await getAttachmentsFolder();

      // Attachments full path
      final attachmentsPaths = attachments != null
          ? attachments.split(',').map((e) => '$attachmentsFolder\\$e').toList()
          : [];
      // Prepare table rows for attachments
      List<RowContent> attachmentRows = [];
      for (int i = 0; i < attachmentsPaths.length; i++) {
        final filePath = attachmentsPaths[i];
        final bytes = await File(filePath).readAsBytes();
        attachmentRows.add(RowContent()
          ..add(ImageContent('attachment', bytes))
          ..add(TextContent('index', (i + 1).toString())));
      }
      // Populate placeholders
      Content content = Content();
      content.add(ImageContent("logo", logo));
        content.add(TextContent("currentDate", currentDate));
        content.add(TextContent("registrationNumber", complaint.registrationNumber));
        content.add(TextContent("attachments_no", attachmentsPaths.length));
        content.add(TextContent("day", weekday));
        content.add(TextContent("date", date));
        content.add(TextContent("spacer", '\n'));
        content.add(TextContent("username", currentUser.name));
        content.add(TextContent("user_nationalId", currentUser.nationalId));
        content.add(TextContent("user_phone", currentUser.phone));
        content.add(TextContent("name", complaint.name));
        content.add(TextContent("nationalId", complaint.nationalId));
        content.add(TextContent("phone", complaint.phone));
        content.add(TextContent("phone2", complaint.phone2));
        content.add(TextContent("address", complaint.address));
        content.add(TextContent("department", complaint.department));
        content.add(TextContent("subject", complaint.subject));
        content.add(TableContent('table', attachmentRows));
      final generatedDoc = await doc.generate(content);

      if (generatedDoc != null) {
        final Doc = File(
            '$appDir\\output\\$complaintFileName ${complaint.name} $dayDate.docx');
        await Doc.writeAsBytes(generatedDoc, flush: true);
        docPath = Doc.path;
        print("Document generated successfully at: ${Doc.path}");
      } else {
        emit(printComplaintError(msg));
        msg = 'Failed to generate document';
        throw Exception("Failed to generate document");
      }
      emit(printComplaintSuccess());

      final result = await OpenFilex.open(docPath);
      print('Open file result: ${result.type}');
    } catch (e) {
      emit(printComplaintError(e.toString()));
      msg = e.toString();
      print("Error: $e");
    }
  }

  var filePath = '';

  Future<FilePickerResult?> pickAttachment() async {
    emit(getAttachmentLoadingState());
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        allowMultiple: true,
      );
      if (result != null) {
        // Optionally, you can store all file paths if needed
        filePath = result.names.join(',');
        emit(getAttachmentSuccessState(result));
        return result;
      } else {
        emit(getAttachmentCancelledState());
        return null;
      }
    } catch (e) {
      emit(getAttachmentErrorState(e.toString()));
      return null;
    }
  }

  Future<String> getNextRegistrationNumber() async {
    // Get current year in two digits
    final year = DateTime.now().year % 100;
    // Fetch the last registrationNumber from the database
    final result = await supabase
        .from('complaints')
        .select('registrationNumber')
        .order('submit_date', ascending: false)
        .limit(1);
    int nextNumber = 1;
    if (result != null && result.isNotEmpty && result[0]['registrationNumber'] != null) {
      final lastReg = result[0]['registrationNumber'] as String;
      final parts = lastReg.split('/');
      if (parts.length == 2 && int.tryParse(parts[1]) != null) {
        nextNumber = int.parse(parts[1]) + 1;
      }
    }
    return '$year/$nextNumber';
  }

  Future<void> addComplaint(
      String name,
      String nationalId,
      String phone,
      String phone2,
      String address,
      String department,
      String subject,
      String attachments) async {
    emit(addComplaintLoadingState());
    try {
      final submitDate = DateTime.now();
      final reminderTime = DateTime.now();
      final registrationNumber = await getNextRegistrationNumber();
      final newComplaint = ComplainingModel(
        name: name,
        nationalId: nationalId,
        phone: phone,
        phone2: phone2,
        address: address,
        department: department,
        subject: subject,
        submitDate: submitDate,
        reminderTime: reminderTime,
        attachments: attachments,
        docPath: '',
        specialistName: '',
        specialistPhone: '',
        compDepartment: '',
        status: 0,
        registrationNumber: registrationNumber,
      );

      await supabase.from('complaints').insert(newComplaint.toJson());
      // Save attachments in a writable attachments folder
      if (attachments.isNotEmpty) {
        final attachmentPaths = attachments.split(',');
        final dir = await getAttachmentsFolder();
        final attachmentsDir = Directory(dir);
        if (!await attachmentsDir.exists()) {
          await attachmentsDir.create(recursive: true);
        }
        for (final path in attachmentPaths) {
          final trimmedPath = path.trim();
          if (trimmedPath.isEmpty) continue;
          final sourceFile = File(trimmedPath);
          if (await sourceFile.exists()) {
            final fileName = sourceFile.uri.pathSegments.last;
            final destPath = '${attachmentsDir.path}/$fileName';
            await sourceFile.copy(destPath);
          }
        }
      }
      emit(addComplaintSuccessState());
    } catch (e) {
      emit(addComplaintErrorState(e.toString()));
      print('Error adding complaint: $e');
    }
  }

  List<ComplainingModel>? complaints = [];

  Future<void> fetchAllComplaints() async {
    emit(fetchAllComplaintsLoadingState());
    try {
      final response = await supabase.from('complaints').select();
      complaints = response
          .map<ComplainingModel>((json) => ComplainingModel.fromJson(json))
          .toList();
      emit(fetchAllComplaintsSuccessState());
      getTodaysReminder();
    } catch (e) {
      emit(fetchAllComplaintsErrorState());
      print('Error fetching complaints: $e');
    }
  }

  // Fetch complaints filtered by department from the database
  Future<void> fetchComplaintsByDepartment(String department) async {
    emit(filterComplaintsByDepartmentLoadingState());
    try {
      final response = await supabase
          .from('complaints')
          .select()
          .eq('compDepartment', department);
      complaints = response
          .map<ComplainingModel>((json) => ComplainingModel.fromJson(json))
          .toList();
      emit(filterComplaintsByDepartmentSuccessState());
    } catch (e) {
      emit(filterComplaintsByDepartmentErrorState(error));
      print('Error fetching complaints by department: $e');
    }
  }

  Future<void> deleteComplaint(complaintSubmitDate) async {
    emit(deleteComplaintLoadingState());
    try {
      await supabase
          .from('complaints')
          .delete()
          .eq('submit_date', complaintSubmitDate);
      emit(deleteComplaintSuccessState());
    } catch (e) {
      emit(deleteComplaintErrorState());
    }
  }

  Future<void> editComplaint(ComplainingModel complaint) async {
    emit(editComplaintLoadingState());
    try {
      await supabase
          .from('complaints')
          .update({
            'name': complaint.name,
            'nationalId': complaint.nationalId,
            'phone': complaint.phone,
            'phone2': complaint.phone2,
            'address': complaint.address,
            'department': complaint.department,
            'subject': complaint.subject,
            'specialistName': complaint.specialistName,
            'specialistPhone': complaint.specialistPhone,
            'compDepartment': complaint.compDepartment,
            'status': complaint.status
          })
          .eq('submit_date', complaint.submitDate)
          .then((value) {
            emit(editComplaintSuccessState());
            fetchAllComplaints();
          });
    } catch (e) {
      emit(editComplaintErrorState());
      print('Error editing complaint: $e');
    }
  }

  List<ComplainingModel> todaysReminders = [];

  Future<void> getTodaysReminder() async {
    emit(getTodaysReminderLoadingState());
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day, 0, 0, 0);
      final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

      final response = await supabase.from('complaints').select().or(
          'and(reminder_time.gte.${startOfDay.toIso8601String()},reminder_time.lte.${endOfDay.toIso8601String()}),status.eq.0,status.eq.1');

      todaysReminders = response
          .map<ComplainingModel>((json) => ComplainingModel.fromJson(json))
          .toList();

      emit(getTodaysReminderSuccessState());
    } catch (e) {
      emit(getTodaysReminderErrorState(e.toString()));
      print('Error fetching todays reminders: $e');
    }
  }

  int pages = 0;

  /// Converts a DOCX file to PDF using ConvertAPI and counts the number of pages in the PDF.
  /// [docxFilePath] is the local path to the DOCX file.
  /// Returns the number of pages in the PDF, or throws an error.
  Future<int> convertDocxToPdfAndCountPages(String docxFilePath) async {
    emit(printComplaintLoading());
    try {
      final apiKey =
          dotenv.env['CONVERTAPI_KEY']; // Replace with your ConvertAPI secret
      print(apiKey);
      final url = Uri.parse(
          'https://v2.convertapi.com/convert/docx/to/pdf?Secret=$apiKey');
      final docxFile = File(docxFilePath);
      final request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath('File', docxFile.path));
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        throw Exception('Failed to convert DOCX to PDF: ${response.body}');
      }
      final pdfUrl = RegExp(r'"Url"\s*:\s*"(.*?)"')
          .firstMatch(response.body)
          ?.group(1)
          ?.replaceAll('\\/', '/');
      if (pdfUrl == null) throw Exception('PDF URL not found in response');
      // Download the PDF
      final pdfResponse = await http.get(Uri.parse(pdfUrl));
      if (pdfResponse.statusCode != 200) {
        throw Exception('Failed to download PDF');
      }
      final tempDir = await getTemporaryDirectory();
      final pdfFile = File('${tempDir.path}/converted.pdf');
      await pdfFile.writeAsBytes(pdfResponse.bodyBytes);
      // Count PDF pages
      final pdfDoc = PdfDocument(inputBytes: pdfFile.readAsBytesSync());
      final pageCount = pdfDoc.pages.count;
      pdfDoc.dispose();
      emit(printComplaintSuccess());
      return pageCount;
    } catch (e) {
      emit(printComplaintError(e.toString()));
      rethrow;
    }
  }

// Future<void> printComplaintPdf(ComplainingModel complaint) async {
//   emit(printComplaintLoading());
//   try {
//     final arabicFont = await PdfGoogleFonts.cairoRegular();
//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//         margin: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//         build: (pw.Context context) {
//           return pw.Container(
//             decoration: pw.BoxDecoration(
//               border: pw.Border.all(color: PdfColors.black, width: 2),
//             ),
//             padding: const pw.EdgeInsets.all(20),
//             child: pw.Directionality(
//               textDirection: pw.TextDirection.rtl,
//               child: pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Row(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Text on the right
//                       pw.Column(
//                         crossAxisAlignment: pw.CrossAxisAlignment.center,
//                         children: [
//                           pw.Text('وزارة الدفاع',
//                               style: pw.TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: pw.FontWeight.bold,
//                                   font: arabicFont)),
//                           pw.Text('جهاز مستقبل مصر للتنمية المستدامة',
//                               style: pw.TextStyle(
//                                   fontSize: 12, font: arabicFont)),
//                           pw.Text('قطاع الضبعة',
//                               style: pw.TextStyle(
//                                   fontSize: 12, font: arabicFont)),
//                           pw.Text('مكتب السيد / مدير الجهاز',
//                               style: pw.TextStyle(
//                                   fontSize: 12, font: arabicFont)),
//                           pw.SizedBox(height: 4),
//                           pw.Text(
//                               'التاريخ: ${DateFormat('yyyy/MM/dd').format(DateTime.now())}',
//                               style: pw.TextStyle(
//                                   fontSize: 12, font: arabicFont)),
//                         ],
//                       ),
//
//                       // Logo on the left
//                       pw.Image(
//                         pw.MemoryImage(
//                           File('assets/images/logo1.png').readAsBytesSync(),
//                         ),
//                         width: 200,
//                         height: 200,
//                       ),
//                     ],
//                   ),
//                   pw.SizedBox(height: 12),
//                   pw.Center(
//                     child: pw.Text('نموذج شكوى',
//                         style: pw.TextStyle(
//                             fontSize: 28,
//                             fontWeight: pw.FontWeight.bold,
//                             font: arabicFont)),
//                   ),
//                   pw.SizedBox(height: 16),
//                   pw.Text(
//                       'تاريخ ووقت التقديم: ${complaint.submitDate.toString()}',
//                       style: pw.TextStyle(font: arabicFont)),
//                   pw.Divider(),
//                   pw.Text('موضوع الشكوى:',
//                       style: pw.TextStyle(
//                           fontWeight: pw.FontWeight.bold, font: arabicFont)),
//                   pw.Text(complaint.subject,
//                       style: pw.TextStyle(font: arabicFont)),
//                   pw.SizedBox(height: 12),
//                   pw.Divider(),
//                   pw.Text('بيانات مقدم الشكوى:',
//                       style: pw.TextStyle(
//                           fontWeight: pw.FontWeight.bold, font: arabicFont)),
//                   pw.Text('الاسم: ${complaint.name}',
//                       style: pw.TextStyle(font: arabicFont)),
//                   pw.Text('الرقم القومي: ${complaint.nationalId}',
//                       style: pw.TextStyle(font: arabicFont)),
//                   pw.Text('رقم الهاتف: ${complaint.phone}',
//                       style: pw.TextStyle(font: arabicFont)),
//                   pw.Text('رقم هاتف إضافي: ${complaint.phone2}',
//                       style: pw.TextStyle(font: arabicFont)),
//                   pw.Text('العنوان: ${complaint.address}',
//                       style: pw.TextStyle(font: arabicFont)),
//                   pw.SizedBox(height: 12),
//                   pw.Divider(),
//                   pw.Text('بيانات المستخدم:',
//                       style: pw.TextStyle(
//                           fontWeight: pw.FontWeight.bold, font: arabicFont)),
//                   pw.Text('القسم: ${complaint.department}',
//                       style: pw.TextStyle(font: arabicFont)),
//                   // Add more user data fields here if available
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//     await Printing.layoutPdf(onLayout: (format) async => pdf.save());
//     emit(printComplaintSuccess());
//   } catch (e) {
//     emit(printComplaintError(e.toString()));
//   }
// }
}
