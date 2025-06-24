import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:visits/modules/Complaining/cubit/states.dart';
import 'package:visits/modules/Complaining/edit_dialog.dart';
import 'package:visits/modules/Complaining/reminder.dart';
import 'package:visits/shared/components/components.dart';
import 'package:visits/shared/components/constants.dart';
import '../../models/Complaining/complaining_model.dart';
import 'assignDialog.dart';
import 'complaint_dialog.dart';
import 'cubit/cubit.dart';

class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  final TextEditingController departmentsController = TextEditingController();
  List<ComplainingModel>? complaints = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          ComplainingCubit()..fetchAllComplaints()..getVisitors() ,
      child: BlocConsumer<ComplainingCubit, ComplainingStates>(
        builder: (BuildContext context, state) {
          final cubit = ComplainingCubit.get(context);
          complaints = cubit.complaints;
          return Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.black, // Change the color of the back button
              ),
              backgroundColor: Color(0xffd9f9f8),
              elevation: 0,
              title: Text(
                manageComplaints,
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              actions: [
                Stack(
                    children: [
                  IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: const Color(0xFF2b2d30),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            final reminders = cubit.todaysReminders;
                            if (reminders.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Center(
                                  child: Text(
                                    emptyNotifications,
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              );
                            }
                            return ListView.separated(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: reminders.length,
                              separatorBuilder: (_, __) => Divider(color: Colors.white24),
                              itemBuilder: (context, index) {
                                final reminder = reminders[index];
                                return ListTile(
                                  onTap: (){showDialog(context: context, builder: (context) => ComplaintDialog(context, reminder, cubit));},
                                  leading: Icon(Icons.notifications, color: Colors.amberAccent),
                                  title: Text(
                                    reminder.compDepartment!,
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    Status[reminder.status]!,
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.notifications_outlined, color: Colors.black,
                        size: 40,
                      )),
                  if (cubit.todaysReminders.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            '${cubit.todaysReminders.length}',
                            // Replace with your notification count
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ])
              ],
            ),
            backgroundColor: Colors.transparent,
            body: Stack(
              fit: StackFit.expand,
              children: [
                //Background gradient
                // Container(
                //   decoration: const BoxDecoration(
                //     gradient: RadialGradient(colors: [
                //       Color(0xFFF4F4FB),
                //       Color(0xff9c9e9f),
                //       Color(0xffd9f9f8),
                //     ]),
                //   ),
                // ),
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/bg2.jpg',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    // opacity: const AlwaysStoppedAnimation(0.5),
                    // color: Colors.black.withOpacity(0.5),
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
                //Background image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/logo_transparent.png',
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    opacity: const AlwaysStoppedAnimation(0.5),
                    colorBlendMode: BlendMode.screen,
                  ),
                ),

                //Content
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Departments Dropdown
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: CustomDropDownMenu(
                            showTitle: false,
                            title: departments,
                            titleColor: Colors.white,
                            textColor: Colors.white,
                            controller: departmentsController,
                            screenWidth: MediaQuery.of(context).size.width,
                            screenRatio:
                                MediaQuery.of(context).devicePixelRatio * 0.3,
                            entries: [
                              for (var value in departmentsList)
                                DropdownMenuEntry(value: value, label: value)
                            ],
                            onSelected: (val) {
                              if (val == null || val.isEmpty) {
                                cubit.fetchAllComplaints();
                              } else {
                                cubit.fetchComplaintsByDepartment(val);

                              }
                            }),
                      ),


                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: ConditionalBuilder(
                          condition:
                              state is! fetchAllComplaintsLoadingState &&
                              state is! getTodaysReminderLoadingState,
                          builder: (context) {
                            if (complaints == null || complaints!.isEmpty) {
                              return Center(
                                child: Text(
                                  noComplaintsFound,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            }
                            // Group complaints by status
                            Map<int, List<ComplainingModel>> groupedComplaints = {};
                            for (var complaint in complaints!) {
                              final status = complaint.status ?? 0;
                              if (!groupedComplaints.containsKey(status)) {
                                groupedComplaints[status] = [];
                              }
                              groupedComplaints[status]!.add(complaint);
                            }
                            // Helper to get status label
                            String getStatusLabel(int status) {
                              switch (status) {
                                case 0:
                                  return Status[0]!;
                                case 1:
                                  return Status[1]!;
                                case 2:
                                  return Status[2]!;
                                default:
                                  return Status[0]!;
                              }
                            }
                            // Define all possible statuses
                            final List<int> allStatuses = [0, 1, 2];
                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ListView(
                                children: allStatuses.map((status) {
                                  final complaintsList = groupedComplaints[status] ?? [];
                                  return Column(
                                    children: [
                                      SizedBox(height: 20.0,),
                                      ExpansionTile(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        iconColor: Colors.black,
                                        textColor: Colors.black,
                                        title: Text(
                                          getStatusLabel(status),
                                          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                                        ),
                                        collapsedBackgroundColor: status == 0
                                            ? Colors.green.withValues(alpha: 0.8)
                                            : status == 1
                                            ? Colors.amberAccent.withValues(alpha: 0.8)
                                            : Colors.red.withValues(alpha: 0.8),


                                        backgroundColor: Color(0xfff3f7fa).withValues(alpha: 0.8),

                                        children: complaintsList.isEmpty
                                            ? [
                                                Padding(
                                                  padding: const EdgeInsets.all(20.0),
                                                  child: Text(
                                                    'لا توجد شكاوى لهذه الحالة.',
                                                    style: TextStyle(color: Colors.grey[600]),
                                                  ),
                                                ),
                                              ]
                                            : complaintsList
                                                .asMap()
                                                .entries
                                                .map((e) => complaintItem(context, e.value, e.key, cubit))
                                                .toList(),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            );
                          },
                          fallback: (context) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        listener: (BuildContext context, state) {
          if (state is fetchAllComplaintsLoadingState) {

          }
          if (state is fetchAllComplaintsSuccessState) {
            // Navigator.pop(context); // Close the loading dialog
          }

          if (state is editComplaintLoadingState) {
            Center(child: CircularProgressIndicator(color: Colors.white,),);
            // showDialog(
            //     context: context, builder: (context) => loadingDialog(context));
          }
          if (state is editComplaintSuccessState) {
            // Navigator.pop(context);
            Toastification().show(
              context: context,
              autoCloseDuration: Duration(seconds: 3),
              backgroundColor: Colors.green,
              dragToClose: true,
              type: ToastificationType.success,
              title: Text(
                editSuccess,
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          if (state is editComplaintErrorState) {
            Navigator.pop(context);
            Toastification().show(
              context: context,
              autoCloseDuration: Duration(seconds: 3),
              backgroundColor: Colors.red,
              dragToClose: true,
              type: ToastificationType.error,
              title: Text(errorMsg, style: TextStyle(color: Colors.white)),
            );
          }
        },
      ),
    );
  }
}

Widget complaintItem(context, ComplainingModel complaint, index, ComplainingCubit cubit) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      color: Color(0xfff3f7fa),
      child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(complaint.compDepartment!.isNotEmpty ? complaint.compDepartment!: 'لم توجه*',
                  style: TextStyle(color: complaint.compDepartment!.isNotEmpty ? Colors.green : Colors.redAccent)),
              SizedBox(height: 10.0,)
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                complaint.subject,
                style: TextStyle(color: Colors.black54),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    // Show full text logic (e.g., showDialog or expand)
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              Text('تفاصيل الشكوى'),
                              Spacer(),
                              Text(
                                Status[complaint.status]!,
                                style: TextStyle(
                                  color: complaint.status == 0
                                      ? Colors.green
                                      : complaint.status == 1
                                          ? Colors.amberAccent
                                          : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          // "Complaint Details" in Arabic
                          content: SingleChildScrollView(
                            child: Text(complaint.subject,style: TextStyle(color: Colors.black54),),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(close), // "Close" in Arabic
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'عرض المزيد', // "See more" in Arabic
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.add, color: Colors.black54),
                  tooltip: assign,
                  onPressed: () {
                    // Handle assign action
                    showDialog(
                      context: context,
                      builder: (context) => assignDialog(context, complaint, cubit),
                    );
                  },
                ),
              ),
              SizedBox(width: 10.0,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.print, color: Colors.black54),
                  tooltip: 'حفظ ملف word',
                  onPressed: () {
                    // Handle print action
                    cubit.printComplaint(complaint);
                    // cubit.printComplaintPdf(complaint);
                  },
                ),
              ),
              SizedBox(width: 10.0,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.notification_add, color: Colors.amberAccent),
                  tooltip: 'تذكير',
                  onPressed: () {
                    // Handle notify action
                    showDialog(
                        context: context,
                        builder: (context) =>
                            reminderDialog(context, complaint, cubit));
                  },
                ),
              ),
              SizedBox(width: 10.0,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  tooltip: edit,
                  onPressed: () {
                    // Handle edit action
                    showDialog(
                        context: context,
                        builder: (context) =>
                            updateDialog(context, complaint, cubit));
                  },
                ),
              ),
              SizedBox(width: 10.0,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  tooltip: delete,
                  onPressed: () {
                    // Handle delete action
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: Text('تأكيد الحذف'),
                        content: Text(confirmDelete),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(close),
                          ),
                          TextButton(
                            onPressed: () {
                              cubit.deleteComplaint(complaint.submitDate);
                              Navigator.of(context).pop();
                              Toastification().show(
                                context: context,
                                autoCloseDuration: Duration(seconds: 3),
                                backgroundColor: Colors.green,
                                dragToClose: true,
                                type: ToastificationType.success,
                                title: Text(deleteSuccess, style: TextStyle(color: Colors.white)),
                              );
                            },
                            child: Text(delete), // "Delete" in Arabic
                          ),
                        ],
                      );
                    });
                  },
                ),
              ),
              SizedBox(width: 10.0,),
              IconButton(
                icon: Icon(Icons.check_circle, color: complaint.status == 2 ? Colors.green : Colors.grey),
                tooltip: solved,
                onPressed: () {
                  // Handle assign action
                  final solvedComplaint = complaint.copyWith(status: 2);
                  cubit.editComplaint(solvedComplaint);
                }
              )
            ],
          ),
          leading: Column(
            children: [
              Text(complaint.submitDate.toString().substring(0, 10),
                  style: TextStyle(color: Colors.black, fontSize: 14)),
              SizedBox(height: 10.0,),
              Text('${complaint.registrationNumber}',
                  style: TextStyle(color: Colors.black, fontSize: 12)),
            ],
          )),
    ),
  );
}
