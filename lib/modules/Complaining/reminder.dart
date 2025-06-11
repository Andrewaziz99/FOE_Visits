import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visits/models/Complaining/complaining_model.dart';
import 'package:visits/modules/Complaining/cubit/cubit.dart';

TextEditingController reminderController = TextEditingController();

Widget reminderDialog(context, ComplainingModel data, ComplainingCubit cubit) {
  final reminderDate = DateFormat('yyyy/MM/dd').format(DateTime(data.reminderTime.year, data.reminderTime.month, data.reminderTime.day));


  reminderController.text = reminderDate;
  return AlertDialog(
    title: const Text(
      'تحديد موعد تذكير',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: reminderController,
            decoration: const InputDecoration(
              labelText: 'تاريخ التذكير',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: data.reminderTime,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(data.reminderTime),
                );
                if (pickedTime != null) {
                  DateTime reminderDateTime = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                  reminderController.text = reminderDateTime.toIso8601String();
                }
              }
            },
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          final editedComplaint = ComplainingModel(
              name: data.name,
              nationalId: data.nationalId,
              phone: data.phone,
              phone2: data.phone2,
              address: data.address,
              department: data.department,
              subject: data.subject,
              submitDate: data.submitDate,
              reminderTime: DateTime.parse(reminderController.text)
          );

          cubit.editComplaint(editedComplaint);
          Navigator.of(context).pop();
        },
        child: const Text('تحديث'),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('إلغاء'),
      ),
    ],
  );
}