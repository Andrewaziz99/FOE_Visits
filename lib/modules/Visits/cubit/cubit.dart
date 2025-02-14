import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visits/models/User/user_model.dart';
import 'package:visits/models/Visit/visit_model.dart';
import 'package:visits/modules/Visits/cubit/states.dart';

import '../../../models/Visitor/visitor_model.dart';

class visitCubit extends Cubit<visitStates> {
  visitCubit() : super(visitInitialState());

  static visitCubit get(context) => BlocProvider.of(context);

  final supabase = Supabase.instance.client;

  UserModel? user;
  Future<void> getUserData() async{
    emit(getUserDataLoading());
    await supabase.from('users').select().eq('user_id', supabase.auth.currentUser!.id).then((value) {
      user = UserModel.fromJson(value.first);
      emit(getUserDataSuccess());
    }).catchError((error){
      emit(getUserDataError());
      print(error);
    });
  }


  List<VisitorModel>? visitors;

  Future<void> getVisitors() async {
    emit(getVisitorsLoading());
    await supabase.from('visitors').select().then((value) {
      visitors = value.map((e) => VisitorModel.fromJson(e)).toList();
      emit(getVisitorsSuccess());
      getVisits();
    }).catchError((error) {
      emit(getVisitorsError());
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
              visitor_id: visitors!.firstWhere((element) => element.name == name).id!,
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
    getUserData().then((value) async{
      emit(getVisitsLoading());
      await supabase
          .from('daily_visits')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id).eq('region', user!.region!)
          .then((value) {
        visits = value.map((e) => VisitModel.fromJson(e)).toList();
        visitorsData = visitors!.where((element) => visits!.any((element2) => element2.visitor_id == element.id)).toList();
        emit(getVisitsSuccess());
      }).catchError((error) {
        emit(getVisitsError());
        print(error);
      });
    }).catchError((error){
      emit(getUserDataError());
    });
  }

  //
  // Future<void> getVisitsByDate(selectedDate) async {
  //   emit(getVisitsLoading());
  //   await supabase.from('daily_visits').select().eq('user_id', supabase.auth.currentUser!.id).eq('visitDate', selectedDate).then((value) {
  //     visits = value.map((e) => VisitModel.fromJson(e)).toList();
  //     emit(getVisitsSuccess());
  //   }).catchError((error) {
  //     emit(getVisitsError());
  //     print(error);
  //   });
  // }

  List<VisitModel>? searchResults;

  Future<void> searchByName(query) async {
    emit(searchVisitsLoading());
    await supabase
        .from('daily_visits')
        .select()
        .eq('user_id', supabase.auth.currentUser!.id)
        .ilike('name', '%$query%')
        .then((value) {
      searchResults = value.map((e) => VisitModel.fromJson(e)).toList();
      emit(searchVisitsSuccess());
    }).catchError((error) {
      emit(searchVisitsError());
      print(error);
    });
  }

  Future<void> searchByPhone(query) async {
    emit(searchVisitsLoading());
    await supabase
        .from('daily_visits')
        .select()
        .eq('user_id', supabase.auth.currentUser!.id)
        .ilike('phone_number', '%$query%')
        .then((value) {
      searchResults = value.map((e) => VisitModel.fromJson(e)).toList();
      emit(searchVisitsSuccess());
    }).catchError((error) {
      emit(searchVisitsError());
      print(error);
    });
  }
}
