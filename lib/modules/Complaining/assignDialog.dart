import 'package:flutter/material.dart';
import 'package:visits/models/Complaining/complaining_model.dart';
import 'package:visits/modules/Complaining/cubit/cubit.dart';
import 'package:visits/shared/components/constants.dart';

import '../../shared/components/components.dart';

class Specialist {
  TextEditingController nameController;
  TextEditingController phoneController;
  Specialist({String? name, String? phone})
      : nameController = TextEditingController(text: name ?? ''),
        phoneController = TextEditingController(text: phone ?? '');
}

Widget assignDialog(
    context, ComplainingModel complaint, ComplainingCubit cubit) {
  // Parse specialist names and phones from comma-separated strings
  List<String> names = (complaint.specialistName ?? '').split(',').where((n) => n.trim().isNotEmpty).toList();
  List<String> phones = (complaint.specialistPhone ?? '').split(',').where((p) => p.trim().isNotEmpty).toList();
  List<Specialist> specialists = [];
  int maxLen = names.length > phones.length ? names.length : phones.length;
  if (maxLen > 0) {
    for (int i = 0; i < maxLen; i++) {
      specialists.add(Specialist(
        name: i < names.length ? names[i] : '',
        phone: i < phones.length ? phones[i] : '',
      ));
    }
  } else {
    specialists.add(Specialist());
  }

  TextEditingController complaintDepartmentController = TextEditingController(text: complaint.compDepartment ?? '');

  return StatefulBuilder(
    builder: (context, setState) {
      return AlertDialog(
        title: Text(assign),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10.0),
              ...specialists.asMap().entries.map((entry) {
                int idx = entry.key;
                Specialist specialist = entry.value;
                return Column(
                  children: [
                    TextField(
                      onChanged: (val){
                        setState(() {
                          cubit.searchByName(val);
                        });
                      },
                      controller: specialist.nameController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: '$specialistName ${specialists.length > 1 ? idx + 1 : ''}',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // For name search
                    if (specialist.nameController.text.isNotEmpty && cubit.searchByNameResults.isNotEmpty)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: ListView.separated(
                          itemCount: cubit.searchByNameResults.length,
                          separatorBuilder: (context, index) => myDivider(color: Colors.grey),
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              specialist.nameController.text = cubit.searchByNameResults[index].name!;
                              specialist.phoneController.text = cubit.searchByNameResults[index].phone_number!;
                              setState(() {
                                specialist.nameController.text = cubit.searchByNameResults[index].name!;
                                specialist.phoneController.text = cubit.searchByNameResults[index].phone_number!;
                                cubit.searchByNameResults.clear();
                                cubit.searchByPhoneResults.clear();
                              }); // Force rebuild to hide the search results after selection
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(cubit.searchByNameResults[index].name!),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 10.0),
                    TextField(
                      maxLength: 11,
                      onChanged: (val){
                        setState(() {
                          cubit.searchByPhone(val);
                        });
                      },
                      controller: specialist.phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: '$specialistPhone ${specialists.length > 1 ? idx + 1 : ''}',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // For phone search
                    if (specialist.phoneController.text.isNotEmpty && cubit.searchByPhoneResults.isNotEmpty)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: ListView.separated(
                          itemCount: cubit.searchByPhoneResults.length,
                          separatorBuilder: (context, index) => myDivider(color: Colors.grey),
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              setState(() {
                                specialist.nameController.text = cubit.searchByPhoneResults[index].name!;
                                specialist.phoneController.text = cubit.searchByPhoneResults[index].phone_number!;
                                cubit.searchByNameResults.clear();
                                cubit.searchByPhoneResults.clear();
                              }); // Force rebuild to hide the search results after selection
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(cubit.searchByPhoneResults[index].phone_number!),
                            ),
                          ),
                        ),
                      ),
                    if (specialists.length > 1)
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              specialists.removeAt(idx);
                            });
                          },
                        ),
                      ),
                    const SizedBox(height: 10.0),
                  ],
                );
              }),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('إضافة مختص'),
                  onPressed: () {
                    setState(() {
                      specialists.add(Specialist());
                    });
                  },
                ),
              ),
              CustomDropDownMenu(
                  showTitle: false,
                  title: departments,
                  titleColor: Colors.black,
                  textColor: Colors.black,
                  controller: complaintDepartmentController,
                  screenWidth: MediaQuery.of(context).size.width,
                  screenRatio: MediaQuery.of(context).devicePixelRatio * 0.3,
                  entries: [
                    for (var value in departmentsList)
                      DropdownMenuEntry(value: value, label: value)
                  ],
                  onSelected: (val) {
                    complaintDepartmentController.text = val;
                  }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // Combine all specialist names and phones as comma-separated strings
              String names = specialists.map((s) => s.nameController.text).where((n) => n.isNotEmpty).join(',');
              String phones = specialists.map((s) => s.phoneController.text).where((p) => p.isNotEmpty).join(',');
              final updatedComplaint = complaint.copyWith(
                compDepartment: complaintDepartmentController.text,
                specialistName: names,
                specialistPhone: phones,
              );
              cubit.editComplaint(updatedComplaint);
              Navigator.pop(context);
            },
            child: const Text(assign),
          ),
        ],
      );
    },
  );
}
