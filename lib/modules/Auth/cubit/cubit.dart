import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visits/models/User/user_model.dart';
import 'package:visits/modules/Auth/login/login_screen.dart';
import 'package:visits/shared/components/components.dart';

import '../../loading_screen.dart';
import 'states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of(context);

  void login({
    required String username,
    required String password,
  }) async {
    emit(AuthLoadingState());
    await Supabase.instance.client.auth
        .signInWithPassword(email: '$username@foe.com', password: password)
        .then((value) {
      emit(AuthSuccessState());
    }).catchError((error) {
      emit(AuthErrorState());
      print(error);
    });
  }

  void logout(context) async {
    emit(AuthLoadingState());
    showDialog(context: context, builder: (context) => loadingDialog(context));
    await Supabase.instance.client.auth.signOut().then((value) {
      emit(AuthLogoutState());
      navigateAndFinish(context, LoginScreen());
    }).catchError((error) {
      emit(AuthErrorState());
    });
  }

  void register({
    required String username,
    required String password,
    required int region,
  }) async {
    emit(AuthLoadingState());
    await Supabase.instance.client.auth
        .signUp(
      email: '$username@foe.com',
      password: password,
    ).then((value) {
      createUser(user_id: value.user!.id,username: username, region: region).then((value){
      emit(AuthSuccessState());
      }).catchError((error){
      emit(AuthErrorState());
      });
    }).catchError((error) {
      emit(AuthErrorState());
      print(error);
    });
  }


  Future<void> createUser({
    required String user_id,
    required String username,
    required int region,
  }) async {
    emit(AuthCreateUserLoadingState());
    await Supabase.instance.client.from('users').insert({
      'user_id': user_id,
      'username': username,
      'region': region,
    }).then((value) {
      emit(AuthCreateUserSuccessState());
    }).catchError((error) {
      emit(AuthCreateUserErrorState());
      print(error);
    });
  }


}
