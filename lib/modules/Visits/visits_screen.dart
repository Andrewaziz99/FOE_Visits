import 'dart:math';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import '../../shared/components/constants.dart';
import '../loading_screen.dart';
import 'new_visit_dialog.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'visit_data_dialog.dart';

class VisitsScreen extends StatelessWidget {
  const VisitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => visitCubit()..getVisitors(),
      child: BlocConsumer<visitCubit, visitStates>(
        builder: (BuildContext context, state) {
          var cubit = visitCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                appName,
                style: TextStyle(fontFamily: 'Cairo'),
              ),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: addVisit,
              hoverColor: Colors.amberAccent,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) =>
                        newVisitDialog(context, function: () async {
                          await cubit.addVisitor(
                              rank: rankController.text,
                              name: nameController.text,
                              phone_number: phoneController.text,
                              additional_phone_number:
                                  additionalPhoneController.text,
                              department: departmentController.text,
                              visitDestination: destinationController.text,
                              visitReason: subjectController.text);
                        }, visitor: cubit.visitors),);
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! getVisitsLoading,
              builder: (BuildContext context) {
                return EventsPlanner(
                  daysShowed: 1,
                  controller: controller,
                  automaticAdjustHorizontalScrollToDay: true,
                  daysHeaderParam: DaysHeaderParam(
                    dayHeaderBuilder: (day, isToday) {
                      return DefaultDayHeader(
                        dayText: DateFormat("E d").format(day),
                        isToday: isToday,
                        foregroundColor: Colors.white,
                      );
                    },
                    daysHeaderColor: Colors.blue,
                  ),
                  pinchToZoomParam: PinchToZoomParameters(
                    pinchToZoom: true,
                    onZoomChange: (heightPerMinute) {},
                    pinchToZoomMinHeightPerMinute: 0.5,
                    pinchToZoomMaxHeightPerMinute: 2.5,
                    pinchToZoomSpeed: 1,
                  ),
                  currentHourIndicatorParam: CurrentHourIndicatorParam(
                    currentHourIndicatorHourVisibility: true,
                    currentHourIndicatorLineVisibility: true,
                    currentHourIndicatorColor: Colors.blue,
                    currentHourIndicatorCustomPainter:
                        (heightPerMinute, isToday) => TimeIndicatorPainter(
                            heightPerMinute, isToday, Colors.blue),
                  ),
                  dayParam: DayParam(
                    dayEventBuilder: (event, height, width, heightPerMinute) =>
                        DefaultDayEvent(
                      width: width,
                      height: height,
                      color: event.color,
                      title: event.title,
                      roundBorderRadius: 5,
                      titleFontSize: 15,
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) =>
                                visitData(context, event.data));
                      },
                      horizontalPadding: 15,
                      verticalPadding: 15,
                      child: Center(
                        child: Text(
                          event.title!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              fallback: (BuildContext context) {
                return loadingDialog(context);
              },
            ),
          );
        },
        listener: (BuildContext context, state) {
          var cubit = visitCubit.get(context);

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

          if (state is getVisitsError) {
            QuickAlert.show(
              width: MediaQuery.of(context).size.width * 0.2,
              context: context,
              animType: QuickAlertAnimType.scale,
              type: QuickAlertType.error,
              autoCloseDuration: Duration(seconds: 3),
              title: getErrorMessage,
              confirmBtnText: done,
            );
          } else if (state is getVisitsSuccess) {
            controller.calendarData.clearAll();
            final Random random = Random();
            controller.updateCalendarData((calendarData) {
              calendarData.addEvents(cubit.visits!.map((e) {
                return Event(
                  startTime: DateTime.parse(e.visitDate!),
                  endTime: DateTime.parse(e.visitDate!).add(const Duration(minutes: 30)),
                  title: cubit.visitorsData!.firstWhere((element) => element.id == e.visitor_id).name,
                  description: e.subject,
                  color: Color.fromRGBO(
                    random.nextInt(256), // Red (0-255)
                    random.nextInt(256), // Green (0-255)
                    random.nextInt(256), // Blue (0-255)
                    1.0,
                  ),
                  textColor: Colors.white,
                  data: {
                    'event_id': e.id,
                    'name': cubit.visitorsData!.firstWhere((element) => element.id == e.visitor_id).name,
                    'rank': cubit.visitorsData!.firstWhere((element) => element.id == e.visitor_id).rank,
                    'phoneNo': cubit.visitorsData!.firstWhere((element) => element.id == e.visitor_id).phone_number,
                    'additionalPhoneNo': cubit.visitorsData!.firstWhere((element) => element.id == e.visitor_id).additional_phone_number,
                    'department': cubit.visitorsData!.firstWhere((element) => element.id == e.visitor_id).department,
                    'visitDestination': e.visitDestination,
                    'visitReason': e.subject,
                  },
                );
              }).toList());
            });
          }
        },
      ),
    );
  }
}

EventsController controller = EventsController();
