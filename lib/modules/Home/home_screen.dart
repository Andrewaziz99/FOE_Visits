import 'dart:math';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:visits/modules/Archive/archive_screen.dart';
import 'package:visits/modules/Complaining/manage_screen.dart';
import 'package:visits/modules/Home/add_new_visit.dart';
import 'package:visits/modules/Home/cubit/states.dart';
import 'package:visits/modules/Home/endrawer.dart';
import 'package:visits/modules/Home/new_visit_dialog.dart';
import 'package:visits/modules/Visits/visits_screen.dart';
import 'package:visits/modules/loading_screen.dart';
import 'package:visits/shared/components/components.dart';
import 'package:visits/shared/components/constants.dart';
import 'package:visits/shared/playSound.dart';
import '../../models/Visitor/visitor_model.dart';
import '../Auth/cubit/cubit.dart';
import '../Complaining/complaining_screen.dart';
import 'cubit/cubit.dart';

class HomeScreen extends StatefulWidget {
  final bool is_admin;

  const HomeScreen({super.key, required this.is_admin});
  // const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController visitorController = TextEditingController();

  List<VisitorModel> visitor = [];

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    if (widget.is_admin) {
      supabase
          .channel('public:daily_visits')
          .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'daily_visits',
          callback: (payload) {
            playSound('sfx/alert.mp3');
            // CherryToast.warning(
            //   height: MediaQuery
            //       .of(context)
            //       .size
            //       .height * 0.2,
            //   width: MediaQuery
            //       .of(context)
            //       .size
            //       .width * 0.5,
            //   textDirection: TextDirection.rtl,
            //   backgroundColor: Colors.amber.withAlpha(100),
            //   title: Text(newVisit,
            //       style: TextStyle(color: Colors.white, fontSize: 14)),
            //   animationCurve: Curves.easeInCubic,
            //   animationDuration: Duration(seconds: 3),
            //   enableIconAnimation: true,
            //   toastPosition: Position.top,
            //   autoDismiss: true,
            //   toastDuration: Duration(minutes: 1),
            //   description: Text(newVisitDescription,
            //       style: TextStyle(color: Colors.white,)),
            //   action: Text(view, style: TextStyle(color: Colors.blue),),
            //   actionHandler: () {
            //     navigateTo(context, VisitsScreen());
            //   },
            // ).show(context);
            Toastification().show(
              style: ToastificationStyle.flatColored,
              type: ToastificationType.warning,
              backgroundColor: Colors.amber.withAlpha(100),
              borderSide: BorderSide(color: Colors.amber, width: 1.0),
              showIcon: true,
              showProgressBar: true,
              title: Text(newVisit,
                  style: TextStyle(color: Colors.black, fontSize: 24)),
              borderRadius: BorderRadius.circular(20.0),
              dragToClose: true,
              autoCloseDuration: const Duration(seconds: 8),
              applyBlurEffect: true,
              direction: TextDirection.rtl,
              icon: Icon(Icons.warning_amber_rounded, color: Colors.amber),
              alignment: Alignment.topLeft,
            );

          })
          .subscribe(
            (status, error) {
          if (error != null) {
            print('Error: $error');
          } else {
            print('Status: $status');
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => homeCubit()
        ..getUserData()
        ..getVisitors()
        ..getDepartments(),
      child: BlocConsumer<homeCubit, homeStates>(
        builder: (BuildContext context, state) {
          var cubit = homeCubit.get(context);
          //get the current attachments path
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              toolbarHeight: 150,
              title: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/bar.gif',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(100),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/logo_name_black.png',
                          ),
                          Spacer(),
                          Text(
                            dailyVisits,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Image.asset(
                            'assets/images/logo1.png',
                            width: 150,
                            height: 150,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
            ),
            endDrawer: menu(context, cubit, AuthCubit.get(context), state),
            body: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background_1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (widget.is_admin || !widget.is_admin)
                                    Container(
                                      width:
                                      MediaQuery.of(context).size.width * 0.3,
                                      height:
                                      MediaQuery.of(context).size.height * 0.4,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(100),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          BlurryContainer(
                                            elevation: 20,
                                            child: Image.asset(
                                              'assets/images/add.gif',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              navigateTo(context, AddNewVisit());
                                            },
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.5,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withAlpha(100),
                                                borderRadius:
                                                BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    addVisit,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 30,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  SizedBox(width: 50.0,),
                                  if(!widget.is_admin)
                                    Container(
                                      width:
                                      MediaQuery.of(context).size.width * 0.3,
                                      height:
                                      MediaQuery.of(context).size.height * 0.4,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(100),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          BlurryContainer(
                                            elevation: 20,
                                            child: Image.asset(
                                              'assets/images/comlpaining.gif',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              navigateTo(context, ComplainingScreen());
                                            },
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.5,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withAlpha(100),
                                                borderRadius:
                                                BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    complaining,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 30,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  SizedBox(
                                    width: 50.0,
                                  ),
                                  if(widget.is_admin)
                                    Container(
                                      width:
                                      MediaQuery.of(context).size.width * 0.3,
                                      height:
                                      MediaQuery.of(context).size.height * 0.4,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(100),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          BlurryContainer(
                                            elevation: 20,
                                            child: Image.asset(
                                              'assets/images/archive.gif',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              navigateTo(context, ArchiveScreen());
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white.withAlpha(100),
                                                borderRadius:
                                                BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    archive,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 30,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              if (widget.is_admin)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width:
                                      MediaQuery.of(context).size.width * 0.3,
                                      height:
                                      MediaQuery.of(context).size.height * 0.4,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(100),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          BlurryContainer(
                                            elevation: 20,
                                            child: Image.asset(
                                              'assets/images/visits.gif',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              navigateTo(context, VisitsScreen());
                                            },
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.5,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withAlpha(100),
                                                borderRadius:
                                                BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    dailyVisitsLogs,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 30,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50.0,
                                    ),
                                    //Complaining Section
                                    Container(
                                      width:
                                      MediaQuery.of(context).size.width * 0.3,
                                      height:
                                      MediaQuery.of(context).size.height * 0.4,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(100),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          BlurryContainer(
                                            elevation: 20,
                                            child: Image.asset(
                                              'assets/images/comlpaining.gif',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              navigateTo(context, ManageScreen());
                                            },
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.5,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withAlpha(100),
                                                borderRadius:
                                                BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    manageComplaints,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 30,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          if (widget.is_admin)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BlurryContainer(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.white30,
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  height: MediaQuery.of(context).size.height * 0.3,
                                  child: CalendarDatePicker(
                                      initialDate: selectedDate,
                                      firstDate: DateTime(2024),
                                      lastDate: DateTime.now(),
                                      onDateChanged: (date) {
                                        selectedDate = date;
                                        // if (cubit.user!.is_admin!) {
                                        //   print(cubit.visits_data?.length);
                                        //   cubit.getRealTimeVisitsByDate(date).then((value){
                                        //     showDialog(context: context, builder: (BuildContext context) => visitDialog(context, cubit.visits_data, cubit.visitorsData));
                                        //   });
                                        // } else {
                                        //   cubit.getVisitsByDate(date);
                                        // }

                                      }),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        listener: (BuildContext context, state) {
          if (state is addVisitorLoading) {
            Navigator.pop(context);
            showDialog(
                context: context, builder: (context) => loadingDialog(context));
          }

          if (state is addVisitLoading) {
            Navigator.pop(context);
            showDialog(
                context: context, builder: (context) => loadingDialog(context));
          }

          if (state is addVisitError) {
            QuickAlert.show(
              width: MediaQuery.of(context).size.width * 0.2,
              context: context,
              animType: QuickAlertAnimType.scale,
              type: QuickAlertType.error,
              autoCloseDuration: Duration(seconds: 3),
              title: addErrorMessage,
              confirmBtnText: done,
            );
          } else if (state is addVisitSuccess) {
            final Random random = Random();
            final event = Event(
              startTime: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  DateTime.now().hour,
                  DateTime.now().minute),
              endTime: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  DateTime.now().hour,
                  DateTime.now().minute + 30),
              title: nameController.text,
              description: subjectController.text,
              color: Color.fromRGBO(
                random.nextInt(256), // Red (0-255)
                random.nextInt(256), // Green (0-255)
                random.nextInt(256), // Blue (0-255)
                1.0,
              ),
              textColor: Colors.white,
              data: {
                'event_id': DateTime.now().toIso8601String(),
                'name': nameController.text,
                'rank': rankController.text,
                'phoneNo': phoneController.text,
                'additionalPhoneNo': additionalPhoneController.text,
                'department': departmentController.text,
                'visitDestination': destinationController.text,
                'visitReason': subjectController.text,
              },
            );
            controller.updateCalendarData((calendarData) {
              calendarData.addEvents([event]);
            });
            Navigator.pop(context);
            QuickAlert.show(
                width: MediaQuery.of(context).size.width * 0.2,
                borderRadius: 15,
                animType: QuickAlertAnimType.scale,
                context: context,
                type: QuickAlertType.success,
                autoCloseDuration: Duration(seconds: 3),
                title: addSuccessMessage,
                confirmBtnText: done);

            rankController.clear();
            nameController.clear();
            phoneController.clear();
            additionalPhoneController.clear();
            departmentController.clear();
            destinationController.clear();
            subjectController.clear();
          }

          if (state is ImagePickerLoading) {
            showDialog(
                context: context, builder: (context) => loadingDialog(context));
          }

          if (state is ImagePickerSuccess) {
            Navigator.pop(context);
            Toastification().show(
              style: ToastificationStyle.flatColored,
              type: ToastificationType.success,
              backgroundColor: Colors.green.withAlpha(100),
              borderSide: BorderSide(color: Colors.green, width: 1.0),
              showIcon: true,
              showProgressBar: false,
              title: Text(imageSuccess,
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              borderRadius: BorderRadius.circular(20.0),
              dragToClose: true,
              autoCloseDuration: const Duration(seconds: 3),
              applyBlurEffect: true,
              direction: TextDirection.rtl,
              icon: Icon(Icons.done_rounded, color: Colors.green),
              alignment: Alignment.topCenter,
            );
          }
        },
      ),
    );
  }
}
