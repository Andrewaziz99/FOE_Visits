import 'dart:io';

import 'package:docx_template/docx_template.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visits/modules/Complaining/cubit/states.dart';

import '../../../models/Visitor/visitor_model.dart';
import '../../../shared/components/constants.dart';

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
    supabase
        .from('departments')
        .select()
        .then((value) {
      departments = value.map((e) => e['depName'] as String).toList();
      emit(getDepartmentsSuccess(departments));
    })
        .catchError((error) {
      emit(getDepartmentsError(error));
      print(error);
    });
  }
  
  

  final currentDate =
  convertToArabic(DateFormat('yyyy/MM/dd').format(DateTime.now()));
  final dayDate =
  convertToArabic(DateFormat('yyyy-MM-dd').format(DateTime.now()));




  Future<void> printComplaint(String name, String nationalId, String phone, String phone2, String address, String department, String subject) async {
    emit(printComplaintLoading());
    final weekday = getWeekDay(DateFormat('EEEE').format(DateTime.now()));
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

      // Populate placeholders
      Content content = Content();
      content
        ..add(ImageContent("logo", logo))
        ..add(TextContent("currentDate", currentDate))
        ..add(TextContent("day", weekday))
        ..add(TextContent("date", currentDate))
        ..add(TextContent("spacer", '\n'))
        ..add(TextContent("name", name))
        ..add(TextContent("nationalId", nationalId))
        ..add(TextContent("phone", phone))
        ..add(TextContent("phone2", phone2))
        ..add(TextContent("address", address))
        ..add(TextContent("department", department))
        ..add(TextContent("subject", subject));
      // Generate the document for the current item
      final generatedDoc = await doc.generate(content);

      //Generate unique complaint file number for each complaint


      if (generatedDoc != null) {
        final Doc = File('$appDir\\output\\$complaintFileName $name $dayDate.docx');
        await Doc.writeAsBytes(generatedDoc, flush: true);

        print("Document generated successfully at: ${Doc.path}");

        emit(printComplaintSuccess());

        final result = await OpenFilex.open(Doc.path);
        print('Open file result: ${result.type}');
      } else {
        emit(printComplaintError(msg));
        msg = 'Failed to generate document';
        throw Exception("Failed to generate document");
      }
    } catch (e) {
      emit(printComplaintError(e.toString()));
      msg = e.toString();
      print("Error: $e");
    }
  }


}