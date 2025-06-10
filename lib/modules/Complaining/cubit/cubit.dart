import 'dart:io';

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


      // Populate placeholders
      Content content = Content();
      content
        ..add(ImageContent("logo", logo))
        ..add(TextContent("currentDate", currentDate))
        ..add(TextContent("day", weekday))
        ..add(TextContent("date", date))
        ..add(TextContent("spacer", '\n'))
        ..add(TextContent("name", complaint.name))
        ..add(TextContent("nationalId", complaint.nationalId))
        ..add(TextContent("phone", complaint.phone))
        ..add(TextContent("phone2", complaint.phone2))
        ..add(TextContent("address", complaint.address))
        ..add(TextContent("department", complaint.department))
        ..add(TextContent("subject", complaint.subject));
      // Generate the document for the current item
      final generatedDoc = await doc.generate(content);

      if (generatedDoc != null) {
        final Doc =
            File('$appDir\\output\\$complaintFileName ${complaint.name} $dayDate.docx');
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
        filePath = result.paths.join(',');
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


  Future<void> addComplaint(String name, String nationalId, String phone,
      String phone2, String address, String department, String subject) async {
    emit(addComplaintLoadingState());
    try {
      final submitDate = DateTime.now();
      final reminderTime = DateTime.now();

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
        docPath: '',
      );

      await supabase.from('complaints').insert(newComplaint.toJson());
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

  Future<void> deleteComplaint(complaint_submit_date) async {
    emit(deleteComplaintLoadingState());
    try {
      await supabase
          .from('complaints')
          .delete()
          .eq('submit_date', complaint_submit_date);
      emit(deleteComplaintSuccessState());
    } catch (e) {
      emit(deleteComplaintErrorState());
    }
  }

  Future<void> editComplaint (ComplainingModel complaint) async {
    emit(editComplaintLoadingState());
    try{
      await supabase.from('complaints').update({
        'name': complaint.name,
        'nationalId': complaint.nationalId,
        'phone': complaint.phone,
        'phone2': complaint.phone2,
        'address': complaint.address,
        'department': complaint.department,
        'subject': complaint.subject,
      }).eq('submit_date', complaint.submitDate).then((value) {
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

     final startOfDay = DateTime(today.year, today.month, today.day, 1, 0, 0);
     final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);


      final response = await supabase
          .from('complaints')
          .select()
          .gte('reminder_time', startOfDay.toIso8601String())
          .lte('reminder_time', endOfDay.toIso8601String());

      todaysReminders = response
          .map<ComplainingModel>((json) => ComplainingModel.fromJson(json))
          .toList();

      emit(getTodaysReminderSuccessState());
    } catch (e) {
      emit(getTodaysReminderErrorState(e.toString()));
      print('Error fetching todays reminders: $e');
    }
  }

}
