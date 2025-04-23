import 'dart:io';

import 'package:docx_template/docx_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visits/models/User/user_model.dart';
import 'package:visits/models/Visit/visit_model.dart';
import 'package:visits/modules/Visits/cubit/states.dart';

import '../../../models/Visit/visit_data_model.dart';
import '../../../models/Visitor/visitor_model.dart';
import '../../../shared/components/constants.dart';

class visitCubit extends Cubit<visitStates> {
  visitCubit() : super(visitInitialState());

  static visitCubit get(context) => BlocProvider.of(context);

  final supabase = Supabase.instance.client;

  final DateTime now = DateTime.now();

  UserModel? user;

  Future<void> getUserData() async {
    emit(getUserDataLoading());
    await supabase
        .from('users')
        .select()
        .eq('user_id', supabase.auth.currentUser!.id)
        .then((value) {
      user = UserModel.fromJson(value.first);
      emit(getUserDataSuccess());
    }).catchError((error) {
      emit(getUserDataError());
      print(error);
    });
  }

  List<VisitorModel>? visitors;

  Future<void> getVisitors() async {
    getUserData().then((value) async {
      emit(getVisitorsLoading());
      await supabase.from('visitors').select().then((value) {
        visitors = value.map((e) => VisitorModel.fromJson(e)).toList();
        emit(getVisitorsSuccess());
        if (user!.is_admin!) {
          // getRealTimeVisits();
          getVisitsByDate(selectedDate);
        } else {
          // getVisits();
          getVisitsByDate(selectedDate);
        }
      }).catchError((error) {
        emit(getVisitorsError());
        print(error);
      });
    }).catchError((error) {
      emit(getUserDataError());
      print(error);
    });
  }

  Future<void> addVisitor({
    required rank,
    required name,
    required phone_number,
    required additional_phone_number,
    required department,
    required visitDestination,
    required visitReason,
  }) async {
    if (visitors!.any((element) => element.name == name) &&
        visitors!.any((element) => element.phone_number == phone_number)) {
      addVisit(
          visitor_id:
              visitors!.firstWhere((element) => element.name == name).id!,
          visitDestination: visitDestination,
          visitReason: visitReason);
    } else {
      emit(addVisitorLoading());
      await supabase.from('visitors').insert({
        'rank': rank,
        'name': name,
        'phone_number': phone_number,
        'additional_phone_number': additional_phone_number,
        'department': department,
      }).then((value) {
        emit(addVisitorSuccess());
        getVisitors().then((value) {
          addVisit(
              visitor_id:
                  visitors!.firstWhere((element) => element.name == name).id!,
              visitDestination: visitDestination,
              visitReason: visitReason);
        });
      }).catchError((error) {
        emit(addVisitorError());
        print(error);
      });
    }
  }

  Future<void> addVisit({
    required int visitor_id,
    required String visitDestination,
    required String visitReason,
  }) async {
    emit(addVisitLoading());
    await supabase.from('daily_visits').insert({
      'user_id': supabase.auth.currentUser!.id,
      'visitor_id': visitor_id,
      'visitDestination': visitDestination,
      'subject': visitReason,
      'visitDate': DateTime.now().toIso8601String(),
      'region': user?.region,
    }).then((value) {
      emit(addVisitSuccess());
    }).catchError((error) {
      emit(addVisitError());
      print(error);
    });
  }

  List<VisitModel>? visits;
  List<VisitorModel>? visitorsData;

  Future<void> getVisits() async {
    getUserData().then((value) async {
      emit(getVisitsLoading());
      await supabase
          .from('daily_visits')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .eq('region', user!.region!)
          .then((value) {
        visits = value.map((e) => VisitModel.fromJson(e)).toList();
        visitorsData = visitors!
            .where((element) =>
                visits!.any((element2) => element2.visitor_id == element.id))
            .toList();
        emit(getVisitsSuccess());
      }).catchError((error) {
        emit(getVisitsError());
        print(error);
      });
    }).catchError((error) {
      emit(getUserDataError());
    });
  }

  List<VisitDataModel>? visitsData;

  Future<void> getVisitsByDate(DateTime date) async {
    getUserData().then((value) async {
      emit(getVisitsByDateLoading());
      await supabase
          .from('daily_visits')
          .select('*, visitors (*)')
          .eq('region', user!.region!)
          .gte(
              'visitDate',
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day)
                  .toString())
          .lt(
              'visitDate',
              DateTime(selectedDate.year, selectedDate.month,
                      selectedDate.day + 1)
                  .toString())
          .then((value) {
        // visits = value.map((e) => VisitModel.fromJson(e)).toList();
        visitsData = value.map((e) => VisitDataModel.fromJson(e)).toList();
        emit(getVisitsByDateSuccess());
      }).catchError((error) {
        emit(getVisitsByDateError());
        print(error);
      });
    }).catchError((error) {
      emit(getUserDataError());
    });
  }

  Future<void> getRealTimeVisitsByDate(DateTime date) async {
    emit(getRealTimeVisitsByDateLoading());
    await supabase
        .from('daily_visits')
        .select()
        .eq('visitDate', date)
        .then((value) {
      visits = value.map((e) => VisitModel.fromJson(e)).toList();
      visitorsData = visitors!
          .where((element) =>
              visits!.any((element2) => element2.visitor_id == element.id))
          .toList();
      emit(getRealTimeVisitsByDateSuccess());
    }).catchError((error) {
      emit(getRealTimeVisitsByDateError());
      print(error);
    });
  }

  Future<void> getRealTimeVisits() async {
    emit(getRealTimeVisitsLoading());
    await supabase.from('daily_visits').select().then((value) {
      visits = value.map((e) => VisitModel.fromJson(e)).toList();
      visitorsData = visitors!
          .where((element) =>
              visits!.any((element2) => element2.visitor_id == element.id))
          .toList();
      emit(getRealTimeVisitsSuccess());
    }).catchError((error) {
      emit(getRealTimeVisitsError());
      print(error);
    });
  }

  void changeDate(context, selectedDate) {
    emit(changeCurrentDateLoading());
    showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(Duration(days: 30)),
      initialDate: selectedDate,
    ).then((value) {
      if (value != null) {
        selectedDate = value;
        emit(changeCurrentDateSuccess());
      } else {
        emit(changeCurrentDateError());
      }
    });
  }

  void deleteVisit(int id) {
    emit(deleteVisitLoading());
    supabase.from('daily_visits').delete().eq('id', id).then((value) {
      emit(deleteVisitSuccess());
    }).catchError((error) {
      emit(deleteVisitError());
      print(error);
    });
  }

  void updateVisit({
    required int id,
    required String visitorRank,
    required String visitorName,
    required String visitorPhone,
    required String visitorAdditionalPhone,
    required String visitorDepartment,
    required String visitReason,
  }) {
    emit(updateVisitLoading());
    supabase
        .from('visitors')
        .update({
          'rank': visitorRank,
          'name': visitorName,
          'phone_number': visitorPhone,
          'additional_phone_number': visitorAdditionalPhone,
          'department': visitorDepartment,
        })
        .eq('id', id)
        .then((value) {
          supabase
              .from('daily_visits')
              .update({'subject': visitReason}).eq('visitor_id', id);
          emit(updateVisitSuccess());
        })
        .catchError((error) {
          emit(updateVisitError());
          print(error);
        });
  }

  final currentDate =
      convertToArabic(DateFormat('yyyy/MM/dd').format(DateTime.now()));
  final dayDate =
      convertToArabic(DateFormat('yyyy-MM-dd').format(DateTime.now()));

  Future<void> printDailyVisits() async {
    emit(printDailyVisitsLoading());
    final weekday = getWeekDay(DateFormat('EEEE').format(DateTime.now()));
    try {
      // Locate and read the template
      final appDir = await getTemplatesFolder();
      final docFile = File('$appDir\\Daily_visits.docx');

      if (!await docFile.exists()) {
        msg = "Daily_visits file not found: ${docFile.path}";
        throw Exception("Daily_visits file not found: ${docFile.path}");
      }

      final docBytes = await docFile.readAsBytes();
      final doc = await DocxTemplate.fromBytes(docBytes);

      // Create a list of rows for the table content
      List<RowContent> allRows = [];

      final logo = await File('$appDir\\logo1.png').readAsBytes();

      for (int i = 0; i < visitsData!.length; i++) {
        final data = visitsData![i];

        // Create a row for the current data
        final row = RowContent()
          ..add(TextContent("level", data.visitors!.rank))
          ..add(TextContent("name", data.visitors!.name))
          ..add(TextContent("phone", data.visitors!.phone_number))
          ..add(TextContent("department", data.visitors!.department))
          ..add(TextContent("subject", data.subject))
          ..add(TextContent("num", convertToArabic((i + 1).toString())));

        // Add the row to our collection
        allRows.add(row);
      }
      // Populate placeholders
      Content content = Content();
      content
        ..add(ImageContent("logo", logo))
        ..add(TextContent("currentDate", currentDate))
        ..add(TextContent("day", weekday))
        ..add(TextContent("date", currentDate))
        ..add(TextContent("space", '\n'))
        ..add(TableContent('table', allRows));

      // Generate the document for the current item
      final generatedDoc = await doc.generate(content);

      if (generatedDoc != null) {
        final Doc = File('$appDir\\output\\$dailyVisits $dayDate.docx');
        await Doc.writeAsBytes(generatedDoc, flush: true);

        print("Document generated successfully at: ${Doc.path}");

        emit(printDailyVisitsSuccess());

        final result = await OpenFilex.open(Doc.path);
        print('Open file result: ${result.type}');
      } else {
        emit(printDailyVisitsError());
        msg = 'Failed to generate document';
        throw Exception("Failed to generate document");
      }
    } catch (e) {
      emit(printDailyVisitsError());
      msg = e.toString();
      print("Error: $e");
    }
  }
}
