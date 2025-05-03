import 'package:flutter/material.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';

TextEditingController visitorRankController = TextEditingController();
TextEditingController visitorNameController = TextEditingController();
TextEditingController visitorPhoneController = TextEditingController();
TextEditingController visitorAdditionalPhoneController =
    TextEditingController();
TextEditingController visitorDepartmentController = TextEditingController();

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
            controller: visitorRankController,
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
              visitorRankController.text = value;
            },
          ),
          SizedBox(height: 10),
          //Name
          arabicLettersFormField(
              radius: BorderRadius.circular(10),
              textColor: Colors.black,
              labelColor: Colors.black,
              controller: visitorNameController,
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
          numbersFormField(
              maxLength: 11,
              radius: BorderRadius.circular(10),
              textColor: Colors.black,
              labelColor: Colors.black,
              controller: visitorPhoneController,
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
          numbersFormField(
              maxLength: 11,
              radius: BorderRadius.circular(10),
              textColor: Colors.black,
              labelColor: Colors.black,
              controller: visitorAdditionalPhoneController,
              type: TextInputType.text,
              label: additionalPhoneNo,
              validate: (val) {
                return null;
              }),

          SizedBox(height: 10),
          //department
          CustomDropDownMenu(
            space: 0,
            controller: visitorDepartmentController,
            title: department,
            screenWidth: MediaQuery.of(context).size.width * 0.8,
            screenRatio: MediaQuery.of(context).devicePixelRatio,
            entries: [
              for (var item in cubit.departments)
                DropdownMenuEntry(
                  value: item,
                  label: item,
                )
            ],
            onSelected: (value) {
              visitorDepartmentController.text = value;
            },
          ),
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
              rank: visitorRankController.text,
              name: visitorNameController.text,
              phone_number: visitorPhoneController.text,
              additional_phone_number: visitorAdditionalPhoneController.text,
              department: visitorDepartmentController.text,
              context: context,
            );
            Navigator.of(context).pop();
          },
          text: add),
    ],
  );
}
