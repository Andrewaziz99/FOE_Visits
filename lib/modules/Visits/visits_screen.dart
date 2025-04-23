import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visits/shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../loading_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

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
              actions: [IconButton(onPressed: (){
                cubit.printDailyVisits();
              }, icon: Icon(Icons.print, color: Colors.white,)),],
            ),
            body: ConditionalBuilder(
              condition: state is! getVisitsLoading &&
                      state is! getRealTimeVisitsLoading &&
                      state is! getVisitsByDateLoading &&
                      state is changeCurrentDateSuccess ||
                  cubit.visitsData != null,
                  // cubit.visits != null && cubit.visitorsData != null,
              builder: (BuildContext context) {
                return ListView.separated(
                  itemBuilder: (BuildContext context, index) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Table(
                                border: TableBorder.all(
                                    color: Colors.black45,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                children: [
                                  //Table Headers
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            rank,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            name,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            phoneNo,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            additionalPhoneNo,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            department,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            visitReason,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      //DATE
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            startDate,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  //Table Data
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            cubit.visitsData![index].visitors!.rank ??
                                                '',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            cubit.visitsData![index].visitors!.name ??
                                                '',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            cubit.visitsData![index].visitors!.phone_number ??
                                                '',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            cubit.visitsData![index].visitors!.additional_phone_number ??
                                                '',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            cubit.visitsData![index].visitors!.department ??
                                                '',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            cubit.visitsData![index].subject ?? '',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            DateFormat('yyyy-MM-dd hh:mma')
                                                    .format(DateTime.parse(cubit.visitsData![index]
                                                        .visitDate
                                                        .toString())),
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, index) =>
                      myDivider(),
                  itemCount: cubit.visitsData?.length ?? 0,
                );
              },
              fallback: (BuildContext context) {
                return Center(child: Text(noData),);
              },
            ),
          );
        },
        listener: (BuildContext context, state) {
          visitCubit.get(context);

          if (state is getVisitorsLoading) {
            showDialog(
                context: context, builder: (context) => loadingDialog(context));
          }
          if (state is getVisitsLoading || state is getRealTimeVisitsLoading) {
            Navigator.pop(context);
            showDialog(
                context: context, builder: (context) => loadingDialog(context));
          }

          if (state is getVisitsError || state is getRealTimeVisitsError) {
            Navigator.pop(context);
            QuickAlert.show(
              width: MediaQuery.of(context).size.width * 0.2,
              context: context,
              animType: QuickAlertAnimType.scale,
              type: QuickAlertType.error,
              autoCloseDuration: Duration(seconds: 3),
              title: getErrorMessage,
              confirmBtnText: done,
            );
          } else if (state is getVisitsSuccess ||
              state is getRealTimeVisitsSuccess ||
              state is getVisitsByDateSuccess) {
            Navigator.pop(context);
            // controller.calendarData.clearAll();
            // final Random random = Random();
            // controller.updateCalendarData((calendarData) {
            //   calendarData.addEvents(cubit.visits!.map((e) {
            //     return Event(
            //       startTime: DateTime.parse(e.visitDate!),
            //       endTime: DateTime.parse(e.visitDate!)
            //           .add(const Duration(minutes: 30)),
            //       title: cubit.visitorsData!
            //           .firstWhere((element) => element.id == e.visitor_id)
            //           .name,
            //       description: e.subject,
            //       color: Color.fromRGBO(
            //         random.nextInt(256), // Red (0-255)
            //         random.nextInt(256), // Green (0-255)
            //         random.nextInt(256), // Blue (0-255)
            //         1.0,
            //       ),
            //       textColor: Colors.white,
            //       data: {
            //         'event_id': e.visitor_id,
            //         'name': cubit.visitorsData!
            //             .firstWhere((element) => element.id == e.visitor_id)
            //             .name,
            //         'rank': cubit.visitorsData!
            //             .firstWhere((element) => element.id == e.visitor_id)
            //             .rank,
            //         'phoneNo': cubit.visitorsData!
            //             .firstWhere((element) => element.id == e.visitor_id)
            //             .phone_number,
            //         'additionalPhoneNo': cubit.visitorsData!
            //             .firstWhere((element) => element.id == e.visitor_id)
            //             .additional_phone_number,
            //         'department': cubit.visitorsData!
            //             .firstWhere((element) => element.id == e.visitor_id)
            //             .department,
            //         'visitDestination': e.visitDestination,
            //         'visitReason': e.subject,
            //       },
            //     );
            //   }).toList());
            // });
          }

          if (state is updateVisitLoading) {
            Navigator.pop(context);
            showDialog(
                context: context, builder: (context) => loadingDialog(context));
          }

          if (state is updateVisitSuccess) {
            Navigator.pop(context);
            QuickAlert.show(
                width: MediaQuery.of(context).size.width * 0.2,
                borderRadius: 15,
                animType: QuickAlertAnimType.scale,
                context: context,
                type: QuickAlertType.success,
                autoCloseDuration: Duration(seconds: 3),
                title: editSuccess,
                confirmBtnText: done);
          } else if (state is updateVisitError) {
            Navigator.pop(context);
            QuickAlert.show(
              width: MediaQuery.of(context).size.width * 0.2,
              context: context,
              animType: QuickAlertAnimType.scale,
              type: QuickAlertType.error,
              autoCloseDuration: Duration(seconds: 3),
              title: editError,
              confirmBtnText: done,
            );
          }

          if (state is printDailyVisitsLoading) {
            showDialog(
                context: context, builder: (context) => loadingDialog(context));
          }

          if (state is printDailyVisitsSuccess) {
            Navigator.pop(context);
            QuickAlert.show(
                width: MediaQuery.of(context).size.width * 0.2,
                borderRadius: 15,
                animType: QuickAlertAnimType.scale,
                context: context,
                type: QuickAlertType.success,
                autoCloseDuration: Duration(seconds: 3),
                title: 'تم طباعة الزيارات اليومية بنجاح',
                confirmBtnText: done);
          }

          if (state is printDailyVisitsError) {
            Navigator.pop(context);
            QuickAlert.show(
              width: MediaQuery.of(context).size.width * 0.2,
              context: context,
              animType: QuickAlertAnimType.scale,
              type: QuickAlertType.error,
              autoCloseDuration: Duration(seconds: 3),
              title: msg,
              confirmBtnText: done,
            );
          }
        },
      ),
    );
  }
}

final supabase = Supabase.instance.client;

EventsController controller = EventsController();

//Table View

// Column(
// children: <Widget>[
// Expanded(
// child: Table(
// border: TableBorder.all(
// color: Colors.white60,
// borderRadius: const BorderRadius.all(
// Radius.circular(10))),
// children: [
// //Table Headers
// TableRow(
// children: [
// TableCell(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(
// rank,
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// TableCell(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(
// name,
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// TableCell(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(
// phoneNo,
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// TableCell(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(
// additionalPhoneNo,
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// TableCell(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(
// department,
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// TableCell(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(
// visitReason,
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// //DATE
// TableCell(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(
// startDate,
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// TableCell(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(
// endDate,
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// ],
// ),
//
// //Table Data
// TableRow(
// children: [
// TableCell(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(
// data['rank'],
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// TableCell(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(
// data['name'],
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// TableCell(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(
// data['phoneNo'],
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// TableCell(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(
// data['additionalPhoneNo'] ?? '',
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// TableCell(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(
// data['department'],
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// TableCell(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(
// data['visitReason'],
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// TableCell(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(
// DateFormat('yyyy-MM-dd hh:mma')
//     .format(DateTime.parse(
// event.startTime.toString())),
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// TableCell(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(
// DateFormat('yyyy-MM-dd hh:mma')
//     .format(DateTime.parse(
// event.endTime.toString())),
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// ],
// ),
// ],
// ),
// )
// ],
// )

// EventsPlanner(
// initialDate: selectedDate,
// heightPerMinute: 3,
// daysShowed: 5,
// controller: controller,
// automaticAdjustHorizontalScrollToDay: true,
// daysHeaderParam: DaysHeaderParam(
// dayHeaderBuilder: (day, isToday) {
// return DefaultDayHeader(
// dayText: DateFormat("E d").format(day),
// isToday: isToday,
// foregroundColor: Colors.white,
// );
// },
// daysHeaderColor: Colors.blue,
// ),
// currentHourIndicatorParam: CurrentHourIndicatorParam(
// currentHourIndicatorHourVisibility: true,
// currentHourIndicatorLineVisibility: true,
// currentHourIndicatorColor: Colors.blue,
// currentHourIndicatorCustomPainter:
// (heightPerMinute, isToday) => TimeIndicatorPainter(
// heightPerMinute, isToday, Colors.blue),
// ),
// dayParam: DayParam(
// dayEventBuilder: (event, height, width, heightPerMinute) {
// final Map<String, dynamic> data =
// event.data as Map<String, dynamic>;
// return DefaultDayEvent(
// width: width,
// height: MediaQuery.of(context).size.height * 0.2,
// color: event.color,
// title: event.title,
// roundBorderRadius: 5,
// titleFontSize: 15,
// onTap: () {
// showDialog(
// context: context,
// builder: (context) =>
// visitData(context, event, event.data, cubit));
// },
// horizontalPadding: 15,
// verticalPadding: 15,
// child: Text(
// '${data['name']}',
// style: const TextStyle(
// fontSize: 15,
// color: Colors.white,
// ),
// ),
// );
// }),
// );
