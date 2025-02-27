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


Widget newVisitDialog(BuildContext context, {required Function function, visitor, cubit}) {
  return BlurryContainer(
    child: AlertDialog(
      backgroundColor: Colors.white70,
      title: const Text(newVisit),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.7,
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    visitor = visitor.where((element) => element.rank == value).toList();
                  },
                ),
                //Name
                // CustomDropDownMenu(
                //   space: 0,
                //   controller: nameController,
                //   title: name,
                //   screenWidth: MediaQuery.of(context).size.width * 0.5,
                //   screenRatio: MediaQuery.of(context).devicePixelRatio,
                //   entries: [
                //     for (var item in visitor)
                //       DropdownMenuEntry(
                //         value: item.name,
                //         label: item.name,
                //       )
                //   ],
                //   onSelected: (value) {
                //     nameController.text = value;
                //     rankController.text = visitor.firstWhere((element) => element.name == value).rank;
                //     phoneController.text = visitor.firstWhere((element) => element.name == value).phone_number;
                //     additionalPhoneController.text = visitor.firstWhere((element) => element.name == value).additional_phone_number ?? '';
                //     departmentController.text = visitor.firstWhere((element) => element.name == value).department;
                //   },
                // ),

                //name
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: defaultFormField(
                      radius: BorderRadius.circular(5),
                      textColor: Colors.black,
                      labelColor: Colors.black,
                      controller: nameController,
                      type: TextInputType.text,
                      label: name,
                      onChange: (value) {
                        cubit.searchByName(value);
                      },
                      validate: (val){}
                  ),
                ),
                if (cubit.searchByNameResults.isNotEmpty)
                SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: ListView.separated(
                      itemCount: cubit.searchByNameResults.length,
                      separatorBuilder: (context, index) => myDivider(color: Colors.grey),
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          nameController.text = cubit.searchByNameResults[index].name!;
                          rankController.text = visitor.firstWhere((element) => element.name == nameController.text).rank;
                          phoneController.text = visitor.firstWhere((element) => element.name == nameController.text).phone_number;
                          additionalPhoneController.text = visitor.firstWhere((element) => element.name == nameController.text).additional_phone_number ?? '';
                          departmentController.text = visitor.firstWhere((element) => element.name == nameController.text).department;
                          cubit.searchByNameResults.clear();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(cubit.searchByNameResults[index].name!),
                        ),
                      ),
                    ),
                  ),
                ),


                //Phone Number
                // CustomDropDownMenu(
                //   space: 0,
                //   controller: phoneController,
                //   title: phoneNo,
                //   screenWidth: MediaQuery.of(context).size.width * 0.5,
                //   screenRatio: MediaQuery.of(context).devicePixelRatio,
                //   entries: [
                //     for (var item in visitor)
                //       DropdownMenuEntry(
                //         value: item.phone_number,
                //         label: item.phone_number,
                //       )
                //   ],
                //   onSelected: (value) {
                //     phoneController.text = value;
                //     nameController.text = visitor.firstWhere((element) => element.phone_number == value).name;
                //     rankController.text = visitor.firstWhere((element) => element.phone_number == value).rank;
                //     additionalPhoneController.text = visitor.firstWhere((element) => element.phone_number == value).additional_phone_number ?? '';
                //     departmentController.text = visitor.firstWhere((element) => element.phone_number == value).department;
                //   },
                // ),
                SizedBox(height: 10,),
                //Subject
                CustomDropDownMenu(
                    title: visitReason,
                    controller: subjectController,
                    screenWidth: MediaQuery.of(context).size.width * 0.5,
                    screenRatio: MediaQuery.of(context).devicePixelRatio,
                    entries: [
                      for (var item in visitSubject)
                        DropdownMenuEntry(
                            value: item,
                            label: item)
                    ],
                    onSelected: (value){}
                ),
                const SizedBox(height: 10,),
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
                SizedBox(height: 10),
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
            rankController.clear();
            nameController.clear();
            phoneController.clear();
            additionalPhoneController.clear();
            departmentController.clear();
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
