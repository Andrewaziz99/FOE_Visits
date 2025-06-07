import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visits/modules/Complaining/cubit/states.dart';
import 'package:visits/shared/components/components.dart';
import 'package:visits/shared/components/constants.dart';

import '../../models/Complaining/complaining_model.dart';
import 'cubit/cubit.dart';

class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ComplainingCubit()..fetchAllComplaints(),
      child: BlocConsumer<ComplainingCubit, ComplainingStates>(
        builder: (BuildContext context, state) {
          final cubit = ComplainingCubit.get(context);
          List<ComplainingModel>? complaints = cubit.complaints;
          return Scaffold(
            appBar: AppBar(
              title: Text(manageComplaints,
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              centerTitle: true,
            ),
            backgroundColor: Colors.transparent,
            body: Stack(
              fit: StackFit.expand,
              children: [
                //Background gradient
                Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(colors: [
                      Color(0xFF3B3B40),
                      Color(0xFF2b2d30),
                      // Color(0xFF4ECDC4),
                    ]),
                  ),
                ),

                //Content
                ConditionalBuilder(
                    condition: complaints != null,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ListView.separated(
                            itemBuilder: (context, index) => Text(complaints.first.name, style: TextStyle(color: Colors.white),),
                            separatorBuilder: (context, index) => myDivider(color: Colors.white),
                            itemCount: complaints!.length),
                      );
                    },
                    fallback: (context) => Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                ),

              ],
            ),
          );
        },
        listener: (BuildContext context, state) {  },
      ),
    );
  }
}
