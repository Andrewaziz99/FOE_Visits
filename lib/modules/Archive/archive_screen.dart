import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:visits/modules/Home/cubit/cubit.dart';

import '../../models/Visitor/visitor_model.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../Home/cubit/states.dart';
import '../loading_screen.dart';


class ArchiveScreen extends StatelessWidget {
  TextEditingController visitorController = TextEditingController();
  TextEditingController subjectController = TextEditingController();

  List<VisitorModel> visitor = [];

  VisitorModel? visitor_data;

  ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => homeCubit()
        ..getUserData()
        ..getVisitors(),
      child: BlocConsumer<homeCubit, homeStates>(
        builder: (BuildContext context, state) {
          var cubit = homeCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              title: Text(appName,
                  style: TextStyle(color: Colors.white, fontSize: 25)),
              centerTitle: true,
            ),
            body: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background_1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ConditionalBuilder(
                  condition:
                  state is! getVisitorsLoading || cubit.visits!.isNotEmpty,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              //Search
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width * 0.1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: defaultFormField(
                                        radius: BorderRadius.circular(5),
                                          textColor: Colors.black,
                                          labelColor: Colors.black,
                                          controller: visitorController,
                                          type: TextInputType.text,
                                          label: name,
                                          onChange: (value) {
                                            cubit.searchByName(value);
                                          },
                                          validate: (val){
                                            return null;
                                          }
                                      ),
                                    ),

                                    SizedBox(
                                      width: 20,
                                    ),

                                    Expanded(
                                      child: defaultFormField(
                                          radius: BorderRadius.circular(5),
                                          textColor: Colors.black,
                                          labelColor: Colors.black,
                                          controller: subjectController,
                                          type: TextInputType.text,
                                          label: subject,
                                          onChange: (value) {
                                            cubit.searchBySubject(value);
                                          },
                                          validate: (val){
                                            return null;
                                          }
                                      ),
                                    ),

                                    SizedBox(
                                      width: 20,
                                    ),

                                    Column(
                                      children: [
                                        Text(totalVisitsNumber),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(cubit.visitsCount.toString()),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              if (cubit.searchByNameResults.isNotEmpty || cubit.searchBySubjectResults.isNotEmpty)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SingleChildScrollView(
                                    child: BlurryContainer(
                                      height: MediaQuery.of(context).size.height * 0.3,
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: ListView.separated(
                                        itemCount: cubit.searchByNameResults.length,
                                        separatorBuilder: (context, index) => myDivider(color: Colors.grey),
                                        itemBuilder: (context, index) => InkWell(
                                          onTap: () {
                                            visitorController.text = cubit.searchByNameResults[index].name!;
                                            cubit.countVisits(cubit.searchByNameResults[index]);
                                            visitor_data = cubit.searchByNameResults[index];
                                            cubit.searchByNameResults = [];
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(cubit.searchByNameResults[index].name!),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  SingleChildScrollView(
                                    child: BlurryContainer(
                                      height: MediaQuery.of(context).size.height * 0.3,
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: ListView.separated(
                                        itemCount: cubit.searchBySubjectResults.length,
                                        separatorBuilder: (context, index) => myDivider(color: Colors.grey),
                                        itemBuilder: (context, index) => InkWell(
                                          onTap: () {
                                            subjectController.text = cubit.searchBySubjectResults[index].subject!;
                                            cubit.getVisitor(cubit.searchBySubjectResults[index].visitor_id!);
                                            visitor_data = cubit.visitor;
                                            // cubit.countVisits(visitor_data!);
                                            cubit.searchBySubjectResults = [];
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(cubit.searchBySubjectResults[index].subject!),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),


                              //Table View

                              BlurryContainer(
                                elevation: 20,
                                child: Table(
                                  border: TableBorder.all(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(15),

                                  ),
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),

                                      ),
                                      children: [
                                        TableCell(child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text('#'),
                                        )),
                                        TableCell(child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text(name),
                                        )),
                                        TableCell(child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text(phoneNo),
                                        )),
                                        TableCell(child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text(additionalPhoneNo),
                                        )),
                                        TableCell(child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text(department),
                                        )),
                                        TableCell(child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text(visitReason),
                                        )),
                                        TableCell(child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text(visitDestination),
                                        )),
                                        TableCell(child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text(visitDate),
                                        )),
                                      ],
                                    ),
                                    for (var i = 0; i < cubit.visitsCount; i++)
                                      TableRow(
                                        decoration: BoxDecoration(
                                          color: Colors.white60,
                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                        ),
                                        children: [
                                          TableCell(child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Text('${i + 1}'),
                                          )),
                                          TableCell(child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Text(
                                                '${visitor_data!.name}'),
                                          )),
                                          TableCell(child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Text(
                                                '${visitor_data!.phone_number}'),
                                          )),
                                          TableCell(child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Text(
                                                visitor_data!.additional_phone_number ?? ''),
                                          )),
                                          TableCell(child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Text(
                                                '${visitor_data!.department}'),
                                          )),
                                          TableCell(child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Text(
                                                '${cubit.visits![i].subject}'),
                                          )),
                                          TableCell(child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Text(
                                                '${cubit.visits![i].visitDestination}'),
                                          )),
                                          TableCell(
                                              child: Padding(
                                                padding: const EdgeInsets.all(20.0),
                                                child: Text(
                                                    DateFormat('yyyy-MM-dd hh:mma').format(DateTime.parse('${cubit.visits![i].visitDate}'))),
                                              )),
                                        ],
                                      ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  fallback: (BuildContext context) {
                    if (cubit.visits!.isEmpty) {
                      return loadingDialog(context);
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(noData),
                          ],
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          );
        },
        listener: (BuildContext context, state) {
          var cubit = homeCubit.get(context);
          if (state is getVisitorsLoading) {
            showDialog(context: context, builder: (context) => loadingDialog(context));
          }
          if (state is countVisitsLoading) {
            showDialog(context: context, builder: (context) => loadingDialog(context));
          }
          if (state is countVisitsSuccess) {
            Navigator.pop(context);
          }
          if (state is getVisitorSuccess) {
            visitor_data = cubit.visitor;
            cubit.countVisits(cubit.visitor);
          }
        },
      ),
    );
  }
}
