import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:visits/models/Engineers/engineers_model.dart';
import 'package:visits/modules/Home/cubit/states.dart';
import 'package:visits/shared/network/local/cache_helper.dart';
import '../../../models/User/user_model.dart';
import '../../../models/Visit/visit_data_model.dart';
import '../../../models/Visit/visit_model.dart';
import '../../../models/Visitor/visitor_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/playSound.dart';

class homeCubit extends Cubit<homeStates> {
  homeCubit() : super(homeInitialState());

  static homeCubit get(context) => BlocProvider.of(context);

  final supabase = Supabase.instance.client;

  Future<void> addSubject({
    required String subjectName,
  }) async {
    getSubjects().then((value) async {
      if (!visitSubject.any((element) => element == subjectName)) {
        emit(addSubjectLoading());
        await supabase.from('subjects').insert({
          'subjectName': subjectName,
        }).then((value) {
          emit(addSubjectSuccess());
          getSubjects();
        }).catchError((error) {
          emit(addSubjectError());
          print(error);
        });
      }
    });
  }

  Future<void> addDepartment({
    required String departmentName,
  }) async {
    getSubjects().then((value) async {
      if (!departments.any((element) => element == departmentName)) {
        emit(addDepartmentLoading());
        await supabase.from('departments').insert({
          'depName': departmentName,
        }).then((value) {
          emit(addDepartmentSuccess());
          getSubjects();
        }).catchError((error) {
          emit(addDepartmentError());
          print(error);
        });
      }
    });
  }

  List<String> visitSubject = [];
  Future<void> getSubjects() async {
    emit(getSubjectsLoading());
    await supabase
        .from('subjects')
        .select()
        .then((value) {
      visitSubject = value.map((e) => e['subjectName'] as String).toList();
      emit(getSubjectsSuccess());
    }).catchError((error) {
      emit(getSubjectsError());
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
      departmentsList = departments;
      emit(getDepartmentsSuccess());
    })
        .catchError((error) {
      emit(getDepartmentsError());
      print(error);
    });
  }

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
      currentUser = user!;
    }).catchError((error) {
      emit(getUserDataError());
      print(error);
    });
  }

  void changePassword(String old, String newPass) async {
    getUserData().then((value) {
      emit(changePasswordLoading());
      final String oldPass = CacheHelper.getData(key: 'password');
      if (old == oldPass) {
        supabase
            .from('users')
            .update({'new_password': newPass})
            .eq('user_id', supabase.auth.currentUser!.id)
            .then((value) {
              emit(changePasswordSuccess());
            })
            .catchError((error) {
              emit(changePasswordError());
              print(error);
            });
      } else {
        emit(changePasswordError());
      }
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
    if (user!.is_admin!) {
      await supabase
          .from('daily_visits')
          .select()
          .eq('visitor_id', visitor.id!)
          .eq('region', user!.region!)
          .then((value) {
        visits = value.map((e) => VisitModel.fromJson(e)).toList();
        visitsCount = value.length;
        emit(countVisitsSuccess());
      }).catchError((error) {
        emit(countVisitsError());
        print(error);
      });
    } else {
      await supabase
          .from('daily_visits')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .eq('visitor_id', visitor.id!)
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

  // Future<void> addVisitor({
  //   required rank,
  //   required name,
  //   required phone_number,
  //   required additional_phone_number,
  //   required department,
  //   required feedback,
  //   required visitReason,
  // }) async {
  //
  //   if (visitors!.any((element) => element.name == name) &&
  //       visitors!.any((element) => element.phone_number == phone_number)) {
  //     addVisit(
  //         visitor_id:
  //             visitors!.firstWhere((element) => element.name == name).id!,
  //         feedback: feedback,
  //         visitReason: visitReason);
  //   } else {
  //     emit(addVisitorLoading());
  //     await supabase.from('visitors').insert({
  //       'rank': rank,
  //       'name': name,
  //       'phone_number': phone_number,
  //       'additional_phone_number': additional_phone_number,
  //       'department': department,
  //     }).then((value) {
  //       emit(addVisitorSuccess());
  //       getVisitors().then((value) {
  //         addVisit(
  //             visitor_id:
  //                 visitors!.where((element) => element.name == name).first.id!,
  //             feedback: feedback,
  //             visitReason: visitReason);
  //       });
  //     }).catchError((error) {
  //       emit(addVisitorError());
  //       print(error);
  //     });
  //   }
  // }

  // Future<void> addVisitor({
  //   required String rank,
  //   required String name,
  //   required String phone_number,
  //   required String? additional_phone_number,
  //   required String department,
  //   required String feedback,
  //   required String visitReason,
  // }) async {
  //   // Ensure visitors list is initialized
  //   if (visitors == null) {
  //     emit(addVisitorError());
  //     return;
  //   }
  //
  //   // Check if the visitor already exists
  //   final existingVisitor = visitors!.firstWhereOrNull(
  //         (visitor) => visitor.name == name && visitor.phone_number == phone_number,
  //   );
  //
  //   if (existingVisitor != null) {
  //     // If the visitor exists, directly add the visit
  //     addVisit(
  //       visitor_id: existingVisitor.id!,
  //       feedback: feedback,
  //       visitReason: visitReason,
  //     );
  //     return;
  //   }
  //
  //   // Emit loading state
  //   emit(addVisitorLoading());
  //
  //   try {
  //     // Insert the new visitor into the database
  //     await supabase.from('visitors').insert({
  //       'rank': rank,
  //       'name': name,
  //       'phone_number': phone_number,
  //       'additional_phone_number': additional_phone_number,
  //       'department': department,
  //     }).then((value) {
  //       emit(addVisitorSuccess());
  //     }).catchError((error) {
  //       emit(addVisitorError());
  //       print(error);
  //     });
  //
  //
  //     // Refresh the visitors list
  //     await getVisitors();
  //
  //     // Find the newly added visitor by name and phone number
  //     final newVisitor = visitors!.firstWhereOrNull(
  //           (visitor) => visitor.name == name && visitor.phone_number == phone_number,
  //     );
  //
  //     if (newVisitor == null) {
  //       emit(addVisitError());
  //       return;
  //     }
  //
  //     // Add the visit for the newly added visitor
  //     addVisit(
  //       visitor_id: newVisitor.id!,
  //       feedback: feedback,
  //       visitReason: visitReason,
  //     );
  //
  //     // Emit success state
  //     emit(addVisitorSuccess());
  //   } catch (error) {
  //     // Handle errors gracefully
  //     emit(addVisitorError());
  //     print('Error adding visitor: $error');
  //   }
  // }

  Future<void> addVisitor({
    required String rank,
    required String name,
    required String phone_number,
    String? additional_phone_number,
    required String department,
    required context,
  }) async {
    // Check if the visitor already exists
    final existingVisitor = visitors?.lastWhereOrNull(
      (visitor) => visitor.name == name || visitor.phone_number == phone_number
    );
    if (existingVisitor != null) {
      // If the visitor exists, directly add the visit
      playSound('sfx/error.mp3');
      Toastification().show(
        style: ToastificationStyle.flatColored,
        type: ToastificationType.error,
        backgroundColor: Colors.red.withAlpha(100),
        borderSide: BorderSide(color: Colors.red, width: 1.0),
        showIcon: true,
        showProgressBar: false,
        title: Text(visitorExists, style: TextStyle(color: Colors.white, fontSize: 18)),
        borderRadius: BorderRadius.circular(20.0),
        dragToClose: true,
        autoCloseDuration: const Duration(seconds: 5),
        applyBlurEffect: true,
        direction: TextDirection.rtl,
        icon: Icon(Icons.warning_amber_rounded, color: Colors.amber),
        alignment: Alignment.topCenter,
      );

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
      }).catchError((error) {
        emit(addVisitorError());
        print(error);
      });
    }
  }

  Future<void> addVisit({
    required int visitor_id,
    required String feedback,
    required String visitReason,
  }) async {
    emit(addVisitLoading());
    await supabase.from('daily_visits').insert({
      'user_id': supabase.auth.currentUser!.id,
      'visitor_id': visitor_id,
      'feedback': feedback,
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


  Future<void> addVisitorAndVisit({
    required String rank,
    required String name,
    required String phone_number,
    String? additional_phone_number,
    required String department,
    required String feedback,
    required String visitReason,
    required BuildContext context,
  }) async {
    // Check if the visitor already exists
    final existingVisitor = visitors?.lastWhereOrNull(
            (visitor) => visitor.name == name || visitor.phone_number == phone_number
    );

    if (existingVisitor != null) {
      // Visitor exists - add visit directly
      try {
        emit(addVisitLoading());
        await supabase.from('daily_visits').insert({
          'user_id': supabase.auth.currentUser!.id,
          'visitor_id': existingVisitor.id, // Use the existing visitor's ID
          'feedback': feedback,
          'subject': visitReason,
          'visitDate': DateTime.now().toIso8601String(),
          'region': user?.region,
        });
        emit(addVisitSuccess());
      } catch (error) {
        emit(addVisitError());
        print(error);
        // Optionally show error toast here
        return;
      }
    } else {
      // Visitor doesn't exist - add visitor first, then add visit
      try {
        // Add new visitor
        final response = await supabase.from('visitors').insert({
          'rank': rank,
          'name': name,
          'phone_number': phone_number,
          'additional_phone_number': additional_phone_number,
          'department': department,
          'created_at': DateTime.now().toIso8601String(),
        }).select();

        if (response.isNotEmpty) {
          final newVisitorId = response[0]['id'] as int;

          // Now add the visit
          try {
            emit(addVisitLoading());
            await supabase.from('daily_visits').insert({
              'user_id': supabase.auth.currentUser!.id,
              'visitor_id': newVisitorId,
              'feedback': feedback,
              'subject': visitReason,
              'visitDate': DateTime.now().toIso8601String(),
              'region': user?.region,
            });
            emit(addVisitSuccess());
          } catch (error) {
            emit(addVisitError());
            print(error);
            // Optionally show error toast here
          }
        }
      } catch (error) {
        playSound('sfx/error.mp3');
        Toastification().show(
          style: ToastificationStyle.flatColored,
          type: ToastificationType.error,
          backgroundColor: Colors.red.withAlpha(100),
          borderSide: BorderSide(color: Colors.red, width: 1.0),
          showIcon: true,
          showProgressBar: false,
          title: Text(addError, style: TextStyle(color: Colors.white, fontSize: 18)),
          borderRadius: BorderRadius.circular(20.0),
          dragToClose: true,
          autoCloseDuration: const Duration(seconds: 5),
          applyBlurEffect: true,
          direction: TextDirection.rtl,
          icon: Icon(Icons.warning_amber_rounded, color: Colors.amber),
          alignment: Alignment.topCenter,
        );
        print(error);
      }
    }
  }



  File? image;
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      // Step 1: Pick the image
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      emit(ImagePickerLoading());

      if (pickedImage != null) {
        image = File(pickedImage.path);

        // Step 2: Upload the image to Supabase storage
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String filePath = 'images/$fileName';

        await supabase.storage
            .from('images') // Replace 'image' with your bucket name
            .upload(filePath, image!);

        // Step 3: Get the image URL
        final String imageUrl =
            supabase.storage.from('images').getPublicUrl(filePath);

        // Step 4: Update the users table with the image URL
        final user = supabase.auth.currentUser;
        if (user != null) {
          await supabase
              .from('users')
              .update({'image': imageUrl}).eq('user_id', user.id);
        }
        print(user!.id);

        emit(ImagePickerSuccess());
      } else {
        // If no image is picked, load a default image
        ByteData byteData = await rootBundle.load('assets/images/user.png');
        Uint8List imageData = byteData.buffer.asUint8List();
        image = File.fromRawPath(imageData);
      }
    } catch (e) {
      emit(ImagePickerError());
      print('Error picking image: $e');
    }
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
      emit(searchByPhoneError());
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
      searchBySubjectResults = [];
      emit(searchByNameSuccess());
    }).catchError((error) {
      emit(searchByNameError());
      print(error);
    });
  }

  List<VisitDataModel> searchBySubjectResults = [];
  Future<void> searchBySubject(String search) async {
    emit(searchBySubjectLoading());
    await supabase
        .from('daily_visits')
        .select('*, visitors (*)')
        .ilike('subject', '%$search%')
        .then((value) {
      searchBySubjectResults =
          value.map((e) => VisitDataModel.fromJson(e)).toList();
      searchByNameResults = [];
      emit(searchBySubjectSuccess());
    }).catchError((error) {
      emit(searchBySubjectError());
      print(error);
    });
  }

  VisitorModel? visitor;

  Future<void> getVisitor(int id) async {
    emit(getVisitorLoading());
    await supabase.from('visitors').select().eq('id', id).then((value) {
      visitor = VisitorModel.fromJson(value.first);
      emit(getVisitorSuccess());
    }).catchError((error) {
      emit(getVisitorError());
      print(error);
    });
  }

  List<VisitModel>? visits_data;
  List<VisitorModel>? visitorsData;


  Future<void> getVisitsByDate(DateTime date) async {
    getUserData().then((value) async {
      emit(getVisitsByDateLoading());
      await supabase
          .from('daily_visits')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .eq('region', user!.region!)
          .eq('visitDate', date)
          .then((value) {
        visits_data = value.map((e) => VisitModel.fromJson(e)).toList();
        visitorsData = visitors!
            .where((element) =>
            visits_data!.any((element2) => element2.visitor_id == element.id))
            .toList();
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
        .eq('visitDate', date.toString())
        .then((value) {
      visits_data = value.map((e) => VisitModel.fromJson(e)).toList();
      visitorsData = visitors!
          .where((element) =>
          visits_data!.any((element2) => element2.visitor_id == element.id))
          .toList();
      emit(getRealTimeVisitsByDateSuccess());
    }).catchError((error) {
      emit(getRealTimeVisitsByDateError());
      print(error);
    });
  }

  List<EngineersModel> engineers = [];

  void getEngineers() {
    emit(getEngineersLoading());
    supabase
        .from('engineers')
        .select('*, visitors (*)')
        .then((value) {
      engineers = (value as List)
          .map((e) => EngineersModel.fromJson(e))
          .toList();
      emit(getEngineersSuccess());
    }).catchError((error) {
      emit(getEngineersError());
      print(error);
    });
  }

  void removeEngineerAt(int index) {
    if (index >= 0 && index < engineers.length) {
      engineers.removeAt(index);
      emit(EngineersUpdatedState(engineers)); // Replace with the appropriate state
    }
  }


}
