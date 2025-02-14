import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:visits/shared/components/components.dart';
import '../../shared/components/constants.dart';

TextEditingController rankController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController additionalPhoneController = TextEditingController();
TextEditingController subjectController = TextEditingController();
TextEditingController departmentController = TextEditingController();
TextEditingController destinationController = TextEditingController();

final _formkey = GlobalKey<FormState>();


Widget newVisitDialog(BuildContext context, {required Function function, visitor}) {
  return BlurryContainer(
    child: AlertDialog(
      backgroundColor: Colors.white70,
      title: const Text(newVisit),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.5,
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Rank
                CustomDropDownMenu(
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
                    visitor = visitor.where((element) => element.rank == value).toList();
                  },
                ),
                SizedBox(height: 20),
                //Name
                CustomDropDownMenu(
                  controller: nameController,
                  title: name,
                  screenWidth: MediaQuery.of(context).size.width * 0.5,
                  screenRatio: MediaQuery.of(context).devicePixelRatio,
                  entries: [
                    for (var item in visitor)
                      DropdownMenuEntry(
                        value: item.name,
                        label: item.name,
                      )
                  ],
                  onSelected: (value) {
                    nameController.text = value;
                    rankController.text = visitor.firstWhere((element) => element.name == value).rank;
                    phoneController.text = visitor.firstWhere((element) => element.name == value).phone_number;
                    additionalPhoneController.text = visitor.firstWhere((element) => element.name == value).additional_phone_number;
                    departmentController.text = visitor.firstWhere((element) => element.name == value).department;
                  },
                ),
                SizedBox(height: 20),
                //Phone Number
                CustomDropDownMenu(
                  controller: phoneController,
                  title: phoneNo,
                  screenWidth: MediaQuery.of(context).size.width * 0.5,
                  screenRatio: MediaQuery.of(context).devicePixelRatio,
                  entries: [
                    for (var item in visitor)
                      DropdownMenuEntry(
                        value: item.phone_number,
                        label: item.phone_number,
                      )
                  ],
                  onSelected: (value) {
                    phoneController.text = value;
                    nameController.text = visitor.firstWhere((element) => element.phone_number == value).name;
                    rankController.text = visitor.firstWhere((element) => element.phone_number == value).rank;
                    additionalPhoneController.text = visitor.firstWhere((element) => element.phone_number == value).additional_phone_number;
                    departmentController.text = visitor.firstWhere((element) => element.phone_number == value).department;
                  },
                ),
                SizedBox(height: 20),
                //Additional Phone Number
                defaultFormField(
                    labelColor: Colors.blueAccent.withAlpha(190),
                    textColor: Colors.black,
                    radius: BorderRadius.circular(10),
                    controller: additionalPhoneController,
                    type: TextInputType.text,
                    label: additionalPhoneNo,
                    validate: (value) {
                      return null;
                    }),
                SizedBox(height: 20),
                //Department
                defaultFormField(
                    labelColor: Colors.blueAccent.withAlpha(190),
                    textColor: Colors.black,
                    radius: BorderRadius.circular(10),
                    controller: departmentController,
                    type: TextInputType.text,
                    label: department,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return departmentError;
                      }
                      return null;
                    }),
                SizedBox(height: 20),
                //Subject
                defaultFormField(
                    labelColor: Colors.blueAccent.withAlpha(190),
                    textColor: Colors.black,
                    radius: BorderRadius.circular(10),
                    controller: subjectController,
                    type: TextInputType.text,
                    label: visitReason,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return visitReasonError;
                      }
                      return null;
                    }),
                SizedBox(height: 20),
                //Destination
                defaultFormField(
                    labelColor: Colors.blueAccent.withAlpha(190),
                    textColor: Colors.black,
                    radius: BorderRadius.circular(10),
                    controller: destinationController,
                    type: TextInputType.text,
                    label: visitDestination,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return visitDestinationError;
                      }
                      return null;
                    }),
              ],
            ),
          ),
        ),
      ),
      actions: [
        defaultButton(
          width: 200,
          radius: 15,
          fSize: 20,
          background: Colors.red,
          tColor: Colors.white,
          text: close,
          function: () {
            Navigator.pop(context);
          },
        ),
        defaultButton(
          width: 200,
          radius: 15,
          fSize: 20,
          background: Colors.blue,
          tColor: Colors.white,
          text: add,
          function: () {
            if (_formkey.currentState!.validate()) {
              function();
            }
          },
        ),
      ],
    ),
  );
}
