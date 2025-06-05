import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visits/shared/components/constants.dart';
import '../../models/Visitor/visitor_model.dart';
import '../../shared/components/components.dart';
import '../loading_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ComplainingScreen extends StatefulWidget {
  @override
  _ComplainingScreenState createState() => _ComplainingScreenState();
}

class _ComplainingScreenState extends State<ComplainingScreen> {
  final TextEditingController rankController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController nationalIdController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController additionalPhoneController =
      TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController departmentController = TextEditingController();

  final TextEditingController subjectController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ComplainingCubit()..getVisitors(),
      child: BlocConsumer<ComplainingCubit, ComplainingStates>(
        builder: (BuildContext context, state) {
          final cubit = ComplainingCubit.get(context);
          List<VisitorModel> visitor = cubit.visitors ?? [];
          return Scaffold(
            appBar: AppBar(
              title: Text(complaining,
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              centerTitle: true,
            ),
            body: Center(
              child: ConditionalBuilder(
                condition: true,
                builder: (BuildContext context) {
                  return Form(
                    key: _formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //name
                                    Row(
                                      children: [
                                        Icon(Icons.person, color: Colors.blue),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: arabicLettersFormField(
                                              radius: BorderRadius.circular(5),
                                              textColor: Colors.black,
                                              labelColor: Colors.black,
                                              controller: nameController,
                                              type: TextInputType.text,
                                              label: name,
                                              onChange: (value) {
                                                cubit.searchByName(value);
                                              },
                                              validate: (val) {
                                                if (val!.isEmpty) {
                                                  return nameError;
                                                }
                                                return null;
                                              }),
                                        ),
                                      ],
                                    ),
                                    // For name search
                                    if (nameController.text.isNotEmpty &&
                                        cubit.searchByNameResults.isNotEmpty)
                                      SingleChildScrollView(
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          child: ListView.separated(
                                            itemCount: cubit
                                                .searchByNameResults.length,
                                            separatorBuilder: (context,
                                                    index) =>
                                                myDivider(color: Colors.grey),
                                            itemBuilder: (context, index) =>
                                                InkWell(
                                              onTap: () {
                                                nameController.text = cubit
                                                    .searchByNameResults[index]
                                                    .name!;
                                                rankController.text = visitor
                                                    .lastWhere((element) =>
                                                        element.name ==
                                                        nameController.text)
                                                    .rank!;
                                                phoneController.text = visitor
                                                    .lastWhere((element) =>
                                                        element.name ==
                                                        nameController.text)
                                                    .phone_number!;
                                                additionalPhoneController
                                                    .text = visitor
                                                        .firstWhere((element) =>
                                                            element.name ==
                                                            nameController.text)
                                                        .additional_phone_number ??
                                                    '';
                                                departmentController.text =
                                                    visitor
                                                        .firstWhere((element) =>
                                                            element.name ==
                                                            nameController.text)
                                                        .department!;
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(cubit
                                                    .searchByNameResults[index]
                                                    .name!),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    //National ID
                                    Row(
                                      children: [
                                        Icon(Icons.credit_card, color: Colors.blue),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: numbersFormField(
                                            maxLength: 14,
                                              radius: BorderRadius.circular(5),
                                              textColor: Colors.black,
                                              labelColor: Colors.black,
                                              controller:  nationalIdController,
                                              type: TextInputType.text,
                                              label: nationalId,
                                              validate: (val) {
                                                if (val!.isEmpty) {
                                                  return nationalIdError;
                                                }
                                                else if (val.length < 14) {
                                                  return nationalIdFormatError;
                                                }
                                                return null;
                                              }),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    //Phone
                                    Row(
                                      children: [
                                        Icon(Icons.phone, color: Colors.blue),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: numbersFormField(
                                              maxLength: 11,
                                              radius: BorderRadius.circular(5),
                                              textColor: Colors.black,
                                              labelColor: Colors.black,
                                              controller: phoneController,
                                              type: TextInputType.text,
                                              label: phoneNo,
                                              onChange: (value) {
                                                cubit.searchByPhone(value);
                                              },
                                              validate: (val) {
                                                if (val!.isEmpty) {
                                                  return phoneNoError;
                                                }
                                                else if (val.length < 11) {
                                                  return phoneNoFormatError;
                                                }
                                                return null;
                                              }),
                                        ),
                                      ],
                                    ),
                                    // For phone search
                                    if (phoneController.text.isNotEmpty &&
                                        cubit.searchByPhoneResults.isNotEmpty)
                                      SingleChildScrollView(
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          child: ListView.separated(
                                            itemCount: cubit
                                                .searchByPhoneResults.length,
                                            separatorBuilder: (context,
                                                    index) =>
                                                myDivider(color: Colors.grey),
                                            itemBuilder: (context, index) =>
                                                InkWell(
                                              onTap: () {
                                                nameController.text = cubit
                                                    .searchByPhoneResults[index]
                                                    .name!;
                                                rankController.text = visitor
                                                    .firstWhere((element) =>
                                                        element.name ==
                                                        nameController.text)
                                                    .rank!;
                                                phoneController.text = visitor
                                                    .firstWhere((element) =>
                                                        element.name ==
                                                        nameController.text)
                                                    .phone_number!;
                                                additionalPhoneController
                                                    .text = visitor
                                                        .firstWhere((element) =>
                                                            element.name ==
                                                            nameController.text)
                                                        .additional_phone_number ??
                                                    '';
                                                departmentController.text =
                                                    visitor
                                                        .firstWhere((element) =>
                                                            element.name ==
                                                            nameController.text)
                                                        .department!;
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(cubit
                                                    .searchByPhoneResults[index]
                                                    .phone_number!),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    //Additional Phone
                                    Row(
                                      children: [
                                        Icon(Icons.phone, color: Colors.blue),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.5,
                                          child: numbersFormField(
                                              maxLength: 11,
                                              radius: BorderRadius.circular(5),
                                              textColor: Colors.black,
                                              labelColor: Colors.black,
                                              controller: additionalPhoneController,
                                              type: TextInputType.text,
                                              label: additionalPhoneNo,
                                              validate: (val) {
                                                return null;
                                              }),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.0,),
                                    //Address
                                    Row(
                                      children: [
                                        Icon(Icons.location_on, color: Colors.blue),
                                        SizedBox(width: 10.0),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: arabicLettersFormField(
                                              radius: BorderRadius.circular(5),
                                              textColor: Colors.black,
                                              labelColor: Colors.black,
                                              controller: addressController,
                                              type: TextInputType.text,
                                              label: address,
                                              validate: (val) {
                                                if (val!.isEmpty) {
                                                  return addressError;
                                                }
                                                return null;
                                              }),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20.0,),
                                    //Job or department
                                    Row(
                                      children: [
                                        Icon(Icons.business, color: Colors.blue),
                                        SizedBox(width: 10.0),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: arabicLettersFormField(
                                              radius: BorderRadius.circular(5),
                                              textColor: Colors.black,
                                              labelColor: Colors.black,
                                              controller: departmentController,
                                              type: TextInputType.text,
                                              label: departmentOrJob,
                                              validate: (val) {
                                                if (val!.isEmpty) {
                                                  return departmentError;
                                                }
                                                return null;
                                              }),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20.0,),
                                    //Complaint subject multi-line TextField
                                    Row(
                                      children: [
                                        Icon(Icons.title, color: Colors.blue),
                                        SizedBox(width: 10.0),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: TextFormField(
                                            textDirection: TextDirection.rtl,
                                            controller: subjectController,
                                            maxLines: 10,
                                            decoration: InputDecoration(
                                              labelText: complaint,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return complaintError;
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    defaultButton(
                                      width: 200,
                                      radius: 15,
                                      fSize: 20,
                                      background: Colors.blue,
                                      tColor: Colors.white,
                                      text: addComplaint,
                                      function: () {
                                        if (_formkey.currentState!.validate()) {
                                          cubit.printComplaint(
                                            nameController.text,
                                            nationalIdController.text,
                                            phoneController.text,
                                            additionalPhoneController.text,
                                            addressController.text,
                                            departmentController.text,
                                            subjectController.text,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                fallback: (BuildContext context) => loadingDialog(context),
              ),
            ),
          );
        },
        listener: (BuildContext context, state) {},
      ),
    );
  }
}
