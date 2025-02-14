import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:visits/modules/Home/cubit/states.dart';
import 'package:visits/modules/Home/endrawer.dart';
import 'package:visits/modules/Home/visit_item.dart';
import 'package:visits/modules/loading_screen.dart';
import 'package:visits/shared/components/components.dart';
import 'package:visits/shared/components/constants.dart';
import '../../models/Visitor/visitor_model.dart';
import '../Auth/cubit/cubit.dart';
import 'cubit/cubit.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  EventsController controller = EventsController();

  TextEditingController visitorController = TextEditingController();

  List<VisitorModel> visitor = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => homeCubit()..getUserData()..getVisitors(),
      child: BlocConsumer<homeCubit, homeStates>(
        builder: (BuildContext context, state) {
          var cubit = homeCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(appName,
                  style: TextStyle(color: Colors.white, fontSize: 25)),
              centerTitle: true,
            ),
            endDrawer: menu(context, cubit, AuthCubit.get(context)),
            body: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ConditionalBuilder(
                  condition: state is! getVisitorsLoading || cubit.visits!.isNotEmpty,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: BlurryContainer(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              CustomDropDownMenu(
                                  title: name,
                                  textColor: Colors.white,
                                  titleColor: Colors.white,
                                  controller: visitorController,
                                  screenWidth:
                                      MediaQuery.of(context).size.width * 0.2,
                                  screenRatio:
                                      MediaQuery.of(context).size.aspectRatio,
                                  entries: [
                                    for (var item in cubit.visitors ?? [])
                                      DropdownMenuEntry(
                                          value: item.name ?? '', label: item.name ?? ''),
                                  ],
                                  onSelected: (value) {
                                    visitor = cubit.visitors!
                                        .where((element) => element.name == value)
                                        .toList();

                                    cubit
                                        .countVisits(cubit.visitors!.firstWhere(
                                            (element) => element.name == value))
                                        .then((value) {
                                      print(cubit.visitsCount);
                                    });
                                  }),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white60,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: MediaQuery.of(context).size.width * 0.8,
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                        children: [
                                          Text('#'),
                                          const Spacer(),
                                          Text(name),
                                          const Spacer(),
                                          Text(phoneNo),
                                          const Spacer(),
                                          Text(additionalPhoneNo),
                                          const Spacer(),
                                          Text(department),
                                          const Spacer(),
                                          Text(visitReason),
                                          const Spacer(),
                                          Text(visitDestination),
                                          const Spacer(),
                                          Text(visitDate),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Expanded(
                                      child: ListView.separated(
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(height: 10),
                                          itemCount: cubit.visitsCount,
                                          itemBuilder: (context, index) => visitItem(index, visitor.first,cubit.visits![index])),
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
                  fallback: (BuildContext context) => loadingDialog(context),
                ),
              ],
            ),
          );
        },
        listener: (BuildContext context, state) {
          if (state is getVisitorsLoading) {
            showDialog(context: context, builder: (context) => loadingDialog(context));
          }
          if (state is countVisitsLoading) {
            showDialog(context: context, builder: (context) => loadingDialog(context));
          }
          if (state is countVisitsSuccess) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
