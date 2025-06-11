import 'dart:math';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:visits/modules/loading_screen.dart';
import '../../models/Visitor/visitor_model.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import 'add_new_visitor.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'eng_screen.dart';

class AddNewVisit extends StatefulWidget {
  const AddNewVisit({super.key});

  @override
  State<AddNewVisit> createState() => _AddNewVisitState();
}

class _AddNewVisitState extends State<AddNewVisit> {
  EventsController controller = EventsController();

  TextEditingController rankController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController additionalPhoneController = TextEditingController();

  TextEditingController subjectController = TextEditingController();

  TextEditingController departmentController = TextEditingController();

  TextEditingController feedbackController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  bool showWarningIcon = false;


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => homeCubit()
        ..getUserData()
        ..getVisitors()
        ..getSubjects()
        ..getDepartments()
        ..getEngineers(),
      child: BlocConsumer<homeCubit, homeStates>(
        builder: (BuildContext context, state) {
          var cubit = homeCubit.get(context);
          List<VisitorModel> visitor = cubit.visitors ?? [];
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => newVisitor(context, cubit));
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            persistentFooterButtons: [
              defaultButton(
                  function: () {
                    showDialog(
                        context: context,
                        builder: (context) => engPage(context, cubit));
                  },
                  width: 500,
                  radius: 10,
                  fSize: 20,
                  background: Colors.green,
                  tColor: Colors.white,
                  text: engRegister)
            ],
            body: Center(
              child: ConditionalBuilder(
                condition: state is! getUserDataLoading &&
                    state is! getVisitorsLoading &&
                    cubit.visitors != null,
                builder: (BuildContext context) {
                  return Form(
                    key: _formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Rank
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.military_tech,
                                          color: Colors.red,
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        CustomDropDownMenu(
                                          space: 0,
                                          controller: rankController,
                                          title: rank,
                                          screenWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          screenRatio: MediaQuery.of(context)
                                              .devicePixelRatio,
                                          entries: [
                                            for (var item in ranks)
                                              DropdownMenuEntry(
                                                value: item,
                                                label: item,
                                              )
                                          ],
                                          onSelected: (value) {
                                            rankController.text = value;
                                            visitor = visitor
                                                .where((element) =>
                                                    element.rank == value)
                                                .toList();
                                          },
                                        ),
                                      ],
                                    ),
                                    //name
                                    Row(
                                      children: [
                                        Icon(Icons.person, color: Colors.red),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: arabicLettersFormField(
                                              radius: BorderRadius.circular(5),
                                              textColor: Colors.black,
                                              labelColor: Colors.black,
                                              controller: nameController,
                                              type: TextInputType.text,
                                              label: name,
                                              onChange: (value) {
                                                cubit.searchByName(value);
                                              },
                                              validate: (val) {
                                                return nameError;
                                              }),
                                        ),
                                      ],
                                    ),
                                    // For name search
                                    if (nameController.text.isNotEmpty &&
                                        cubit.searchByNameResults.isNotEmpty)
                                      SingleChildScrollView(
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          child: ListView.separated(
                                            itemCount: cubit
                                                .searchByNameResults.length,
                                            separatorBuilder: (context,
                                                    index) =>
                                                myDivider(color: Colors.grey),
                                            itemBuilder: (context, index) =>
                                                InkWell(
                                              onTap: () {
                                                nameController.text = cubit
                                                    .searchByNameResults[index]
                                                    .name!;
                                                rankController.text = visitor
                                                    .lastWhere((element) =>
                                                        element.name ==
                                                        nameController.text)
                                                    .rank!;
                                                phoneController.text = visitor
                                                    .lastWhere((element) =>
                                                        element.name ==
                                                        nameController.text)
                                                    .phone_number!;
                                                additionalPhoneController
                                                    .text = visitor
                                                        .firstWhere((element) =>
                                                            element.name ==
                                                            nameController.text)
                                                        .additional_phone_number ??
                                                    '';
                                                departmentController.text =
                                                    visitor
                                                        .firstWhere((element) =>
                                                            element.name ==
                                                            nameController.text)
                                                        .department!;
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(cubit
                                                    .searchByNameResults[index]
                                                    .name!),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    //Phone
                                    Row(
                                      children: [
                                        Icon(Icons.phone, color: Colors.red),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: numbersFormField(
                                              maxLength: 11,
                                              radius: BorderRadius.circular(5),
                                              textColor: Colors.black,
                                              labelColor: Colors.black,
                                              controller: phoneController,
                                              type: TextInputType.text,
                                              label: phoneNo,
                                              onChange: (value) {
                                                cubit.searchByPhone(value);
                                              },
                                              validate: (val) {
                                                return phoneNoError;
                                              }),
                                        ),
                                      ],
                                    ),
                                    // For phone search
                                    if (phoneController.text.isNotEmpty &&
                                        cubit.searchByPhoneResults.isNotEmpty)
                                      SingleChildScrollView(
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          child: ListView.separated(
                                            itemCount: cubit
                                                .searchByPhoneResults.length,
                                            separatorBuilder: (context,
                                                    index) =>
                                                myDivider(color: Colors.grey),
                                            itemBuilder: (context, index) =>
                                                InkWell(
                                              onTap: () {
                                                nameController.text = cubit
                                                    .searchByPhoneResults[index]
                                                    .name!;
                                                rankController.text = visitor
                                                    .firstWhere((element) =>
                                                        element.name ==
                                                        nameController.text)
                                                    .rank!;
                                                phoneController.text = visitor
                                                    .firstWhere((element) =>
                                                        element.name ==
                                                        nameController.text)
                                                    .phone_number!;
                                                additionalPhoneController
                                                    .text = visitor
                                                        .firstWhere((element) =>
                                                            element.name ==
                                                            nameController.text)
                                                        .additional_phone_number ??
                                                    '';
                                                departmentController.text =
                                                    visitor
                                                        .firstWhere((element) =>
                                                            element.name ==
                                                            nameController.text)
                                                        .department!;

                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(cubit
                                                    .searchByPhoneResults[index]
                                                    .phone_number!),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    //Additional Phone Number
                                    Row(
                                      children: [
                                        Icon(Icons.contact_phone,
                                            color: Colors.blue),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.5,
                                          child: numbersFormField(
                                              maxLength: 11,
                                              labelColor: Colors.blueAccent
                                                  .withAlpha(190),
                                              textColor: Colors.black,
                                              radius: BorderRadius.circular(10),
                                              controller:
                                              additionalPhoneController,
                                              type: TextInputType.text,
                                              label: additionalPhoneNo,
                                              validate: (value) {
                                                return null;
                                              }),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    //Department
                                    Row(
                                      children: [
                                        Icon(Icons.place_rounded,
                                            color: Colors.red),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        //department
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.5,
                                          child: CustomDropDownMenu(
                                            space: 0,
                                            controller:
                                            departmentController,
                                            title: department,
                                            screenWidth: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.8,
                                            screenRatio: MediaQuery.of(context)
                                                .devicePixelRatio,
                                            entries: [
                                              for (var item
                                              in cubit.departments)
                                                DropdownMenuEntry(
                                                  value: item,
                                                  label: item,
                                                )
                                            ],
                                            onSelected: (value) {
                                              visitorDepartmentController.text =
                                                  value;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    //Subject
                                    Row(
                                      children: [
                                        Icon(Icons.subject, color: Colors.red),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        CustomDropDownMenu(
                                            title: visitReason,
                                            controller: subjectController,
                                            screenWidth: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.5,
                                            screenRatio: MediaQuery.of(context)
                                                .devicePixelRatio,
                                            entries: [
                                              for (var item
                                              in cubit.visitSubject)
                                                DropdownMenuEntry(
                                                    value: item, label: item)
                                            ],
                                            onSelected: (value) {
                                              subjectController.text = value;
                                            }),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    //Feedback
                                    Row(
                                      children: [
                                        Icon(Icons.feedback, color: Colors.blue),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.5,
                                          child: arabicLettersFormField(
                                              radius: BorderRadius.circular(5),
                                              textColor: Colors.black,
                                              labelColor: Colors.black,
                                              controller: feedbackController,
                                              type: TextInputType.text,
                                              label: feedback,
                                              validate: (val) {
                                                return null;
                                              }),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    //Add Button
                                    Row(
                                      children: [
                                        defaultButton(
                                          width: 200,
                                          radius: 15,
                                          fSize: 20,
                                          background: Colors.blue,
                                          tColor: Colors.white,
                                          text: add,
                                          function: () {
                                            if (subjectController.text.isEmpty || departmentController.text.isEmpty) {
                                              setState(() {
                                                showWarningIcon = true;
                                              });
                                            }
                                            else if (_formkey.currentState!.validate() || subjectController.text.isNotEmpty || departmentController.text.isNotEmpty) {
                                              setState(() {
                                                showWarningIcon = false;
                                              });
                                              cubit.addSubject(
                                                  subjectName:
                                                      subjectController.text);
                                              cubit.addVisitorAndVisit(
                                                rank: rankController.text,
                                                name: nameController.text,
                                                phone_number: phoneController.text,
                                                additional_phone_number:
                                                    additionalPhoneController.text,
                                                department:
                                                    departmentController.text,
                                                feedback:
                                                feedbackController.text,
                                                visitReason: subjectController.text,
                                                context: context,
                                              );
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        //Warning widgets
                                        if (showWarningIcon)
                                        Row(
                                          children: [
                                            Icon(Icons.warning_amber, color: Colors.red,),
                                            SizedBox(width: 20.0,),
                                            Text(emptyDataError, style: TextStyle(color: Colors.red),)
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                fallback: (BuildContext context) => loadingDialog(context),
              ),
            ),
          );
        },
        listener: (BuildContext context, state) {
          var cubit = homeCubit.get(context);

          if (state is addVisitorLoading) {
            showDialog(
                context: context, builder: (context) => loadingDialog(context));
          }

          if (state is addVisitorSuccess) {
            rankController.text = visitorRankController.text;
            nameController.text = visitorNameController.text;
            phoneController.text = visitorPhoneController.text;
            additionalPhoneController.text =
                visitorAdditionalPhoneController.text;
            departmentController.text = visitorDepartmentController.text;

            Navigator.pop(context);
            QuickAlert.show(
              width: MediaQuery.of(context).size.width * 0.2,
              context: context,
              animType: QuickAlertAnimType.scale,
              type: QuickAlertType.success,
              barrierDismissible: true,
              autoCloseDuration: Duration(seconds: 2),
              title: addSuccessMessage,
              confirmBtnText: done,
            );

            visitorRankController.clear();
            visitorNameController.clear();
            visitorPhoneController.clear();
            visitorAdditionalPhoneController.clear();
            visitorDepartmentController.clear();

            cubit.getVisitors();
          }

          if (state is addVisitLoading) {
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
                'feedback': feedbackController.text,
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
                autoCloseDuration: Duration(seconds: 2),
                barrierDismissible: true,
                title: addSuccessMessage,
                confirmBtnText: done);

            rankController.clear();
            nameController.clear();
            phoneController.clear();
            additionalPhoneController.clear();
            departmentController.clear();
            feedbackController.clear();
            subjectController.clear();

            cubit.getVisitors();
          }
        },
      ),
    );
  }
}
