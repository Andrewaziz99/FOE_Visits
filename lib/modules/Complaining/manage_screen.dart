import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:visits/modules/Complaining/cubit/states.dart';
import 'package:visits/modules/Complaining/edit_dialog.dart';
import 'package:visits/modules/Complaining/reminder.dart';
import 'package:visits/shared/components/components.dart';
import 'package:visits/shared/components/constants.dart';
import '../../models/Complaining/complaining_model.dart';
import '../loading_screen.dart';
import 'cubit/cubit.dart';

class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  final TextEditingController departmentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          ComplainingCubit()..fetchAllComplaints(),
      child: BlocConsumer<ComplainingCubit, ComplainingStates>(
        builder: (BuildContext context, state) {
          final cubit = ComplainingCubit.get(context);
          List<ComplainingModel>? complaints = cubit.complaints;
          return Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.white, // Change the color of the back button
              ),
              backgroundColor: Color(0xFF2b2d30),
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
                Stack(children: [
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
                                  leading: Icon(Icons.notifications, color: Colors.amberAccent),
                                  title: Text(
                                    reminder.name ?? 'Notification',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    reminder.subject ?? '',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.notification_important_rounded,
                        size: 30,
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
                Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(colors: [
                      Color(0xFF3B3B40),
                      Color(0xFF2b2d30),
                      // Color(0xFF4ECDC4),
                    ]),
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
                            onSelected: (val) {}),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: ConditionalBuilder(
                            condition:
                                state is! fetchAllComplaintsLoadingState &&
                                    state is! getTodaysReminderLoadingState,
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: ListView.separated(
                                    itemBuilder: (context, index) =>
                                        complaintItem(context,
                                            complaints[index], index, cubit),
                                    separatorBuilder: (context, index) =>
                                        myDivider(color: Colors.white),
                                    itemCount: complaints!.length),
                              );
                            },
                            fallback: (context) => Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )),
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
            showDialog(
                context: context, builder: (context) => loadingDialog(context));
          }
          if (state is fetchAllComplaintsSuccessState) {
            // Navigator.pop(context); // Close the loading dialog
          }

          if (state is editComplaintLoadingState) {
            showDialog(
                context: context, builder: (context) => loadingDialog(context));
          }
          if (state is editComplaintSuccessState) {
            Navigator.pop(context);
            Navigator.pop(context);
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

Widget complaintItem(context, ComplainingModel complaint, index, cubit) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      color: Colors.white.withValues(alpha: 0.1),
      child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(complaint.name, style: TextStyle(color: Colors.white)),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                complaint.subject,
                style: TextStyle(color: Colors.white70),
                maxLines: 6,
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
                          title: Text('تفاصيل الشكوى'),
                          // "Complaint Details" in Arabic
                          content: SingleChildScrollView(
                            child: Text(complaint.subject),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('إغلاق'), // "Close" in Arabic
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
              IconButton(
                icon: Icon(Icons.print, color: Colors.white),
                tooltip: 'حفظ ملف word',
                onPressed: () {
                  // Handle print action
                  cubit.printComplaint(complaint);
                },
              ),
              IconButton(
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
              IconButton(
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
              IconButton(
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
            ],
          ),
          leading: Text('${index + 1}',
              style: TextStyle(color: Colors.white, fontSize: 18))),
    ),
  );
}
