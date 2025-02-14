import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visits/modules/Home/cubit/states.dart';

import '../../../models/User/user_model.dart';
import '../../../models/Visit/visit_model.dart';
import '../../../models/Visitor/visitor_model.dart';

class homeCubit extends Cubit<homeStates> {
  homeCubit() : super(homeInitialState());

  static homeCubit get(context) => BlocProvider.of(context);

  final supabase = Supabase.instance.client;

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
    emit(getVisitorsLoading());
    await supabase.from('visitors').select().then((value) {
      visitors = value.map((e) => VisitorModel.fromJson(e)).toList();
      emit(getVisitorsSuccess());
    }).catchError((error) {
      emit(getVisitorsError());
      print(error);
    });
  }

  int visitsCount = 0;

  List<VisitModel>? visits = [];

  Future<void> countVisits(visitor) async {
    emit(countVisitsLoading());
    await supabase
        .from('daily_visits')
        .select()
        .eq('user_id', user!.user_id!)
        .eq('visitor_id', visitor.id)
        .eq('region', user!.region!)
        .then((value) {
      visits = value.map((e) => VisitModel.fromJson(e)).toList();
      visitsCount = value.length;
      emit(countVisitsSuccess());
    }).catchError((error) {
      emit(countVisitsError());
      print(error);
    });
  }
}
