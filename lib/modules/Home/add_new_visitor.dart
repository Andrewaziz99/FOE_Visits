import 'package:flutter/material.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';

TextEditingController rankController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController additionalPhoneController = TextEditingController();
TextEditingController departmentController = TextEditingController();

Widget newVisitor(context, cubit) {
  return AlertDialog(
    title: Text(add_new_visitor),
    content: Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //Rank
          CustomDropDownMenu(
            space: 0,
            controller: rankController,
            title: rank,
            screenWidth: MediaQuery.of(context).size.width * 0.5,
            screenRatio: MediaQuery.of(context).devicePixelRatio,
            entries: [
              for (var item in ranks)
                DropdownMenuEntry(
                  value: item,
                  label: item,
                )
            ],
            onSelected: (value) {
              rankController.text = value;
            },
          ),
          SizedBox(height: 10),
          //Name
          defaultFormField(
              radius: BorderRadius.circular(10),
              textColor: Colors.black,
              labelColor: Colors.black,
              controller: nameController,
              type: TextInputType.text,
              label: name,
              validate: (val) {
                if (val!.isEmpty) {
                  return nameError;
                }
                return null;
              }),
          SizedBox(height: 10),
          //Phone
          defaultFormField(
              radius: BorderRadius.circular(10),
              textColor: Colors.black,
              labelColor: Colors.black,
              controller: phoneController,
              type: TextInputType.text,
              label: phoneNo,
              validate: (val) {
                if (val!.isEmpty) {
                  return phoneNoError;
                }
                return null;
              }),
          SizedBox(height: 10),
          //Add_Phone
          defaultFormField(
              radius: BorderRadius.circular(10),
              textColor: Colors.black,
              labelColor: Colors.black,
              controller: additionalPhoneController,
              type: TextInputType.text,
              label: additionalPhoneNo,
              validate: (val) {}),

          SizedBox(height: 10),
          //department
          defaultFormField(
              radius: BorderRadius.circular(10),
              textColor: Colors.black,
              labelColor: Colors.black,
              controller: departmentController,
              type: TextInputType.text,
              label: department,
              validate: (val) {
                if (val!.isEmpty) {
                  return departmentError;
                }
                return null;
              }),
        ],
      ),
    ),
    actions: <Widget>[
      defaultButton(
          radius: 20,
          fSize: 15,
          tColor: Colors.white,
          width: MediaQuery.of(context).size.width * 0.3,
          background: Colors.redAccent,
          function: () {
            Navigator.of(context).pop();
          },
          text: cancel),
      SizedBox(width: 10),
      defaultButton(
          radius: 20,
          fSize: 15,
          tColor: Colors.white,
          width: MediaQuery.of(context).size.width * 0.3,
          background: Colors.blue,
          function: () {
            cubit.addVisitor(
              rank: rankController.text,
              name: nameController.text,
              phone_number: phoneController.text,
              additional_phone_number: additionalPhoneController.text,
              department: departmentController.text,
            );
            Navigator.of(context).pop();
          },
          text: add),
    ],
  );
}
