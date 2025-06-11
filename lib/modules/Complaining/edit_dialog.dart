import 'package:flutter/material.dart';
import 'package:visits/models/Complaining/complaining_model.dart';

import '../../shared/components/constants.dart';
import 'cubit/cubit.dart';

TextEditingController nameController = TextEditingController();
TextEditingController nationalIdController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController phone2Controller = TextEditingController();
TextEditingController addressController = TextEditingController();
TextEditingController subjectController = TextEditingController();
TextEditingController departmentController = TextEditingController();

Widget updateDialog(context, ComplainingModel data, cubit) {
  nameController.text = data.name;
  nationalIdController.text = data.nationalId;
  phoneController.text = data.phone;
  phone2Controller.text = data.phone2;
  addressController.text = data.address;
  departmentController.text = data.department;
  subjectController.text = data.subject;
  return AlertDialog(
    title: const Text(
      'تحديث الشكوى',
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
          Center(
            child: Text('بيانات الشاكي', style: TextStyle(fontSize: 24.0),),),
          SizedBox(height: 20.0,),
          const SizedBox(height: 10),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: name,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: nationalIdController,
            decoration: const InputDecoration(
              labelText: nationalId,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: phoneNo,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: phone2Controller,
            decoration: const InputDecoration(
              labelText: additionalPhoneNo,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: addressController,
            decoration: const InputDecoration(
              labelText: address,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: departmentController,
            decoration: const InputDecoration(
              labelText: department,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20.0),
          Center(child: Text(complaint, style: TextStyle(fontSize: 24.0),),),
          const SizedBox(height: 20.0),
          TextField(
            controller: subjectController,
            decoration: InputDecoration(
              labelText: complaint,
              border: const OutlineInputBorder(),
            ),
            maxLines: 10,
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text(exit),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          // Add update logic here
          final ComplainingModel updated_complaint = ComplainingModel(
              name: nameController.text,
              nationalId: nationalIdController.text,
              phone: phoneController.text,
              phone2: phone2Controller.text,
              address: addressController.text,
              department: departmentController.text,
              subject: subjectController.text,
              submitDate: data.submitDate,
              reminderTime: data.reminderTime,
              docPath: data.docPath,
              attachments: data.attachments,
              specialistName: data.specialistName,
              specialistPhone: data.specialistPhone,
              compDepartment: data.compDepartment,
              status: data.status,
          );
          cubit.editComplaint(updated_complaint);
        },
        child: const Text(edit),
      ),
    ],
  );
}