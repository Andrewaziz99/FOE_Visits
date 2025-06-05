import 'package:flutter/material.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';

Widget engPage(BuildContext context, cubit) => SizedBox(
  width: MediaQuery.of(context).size.width * 0.8,
  height: MediaQuery.of(context).size.height * 0.8,
  child: AlertDialog(
    titlePadding: const EdgeInsets.all(16),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    actionsPadding: const EdgeInsets.all(16),
    title: Center(
      child: Text(
        engRegister,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    content: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < cubit.engineers.length; i++)
          Column(
            children: [
              ListTile(
                leading: Text('${i + 1}'),
                title: Row(
                  children: [
                    Text(
                      cubit.engineers[i].visitor.name ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    defaultButton(
                        function: () async {
                          // Add a daily visit for today
                          await cubit.addVisit(
                            visitor_id: cubit.engineers[i].visitor.id!,
                            feedback: '',
                            visitReason: 'حضور يومي',
                          );
                          // Remove the added engineer from the list using the cubit's method
                          cubit.removeEngineerAt(i);
                        },
                        text: add,
                      tColor: Colors.white,
                      fSize: 20.0,
                    width: 200.0,
                        background: Colors.blue,
                        radius: 20.0,
                    )
                  ],
                ),
                subtitle: Text(
                  cubit.engineers[i].visitor.phone_number ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              myDivider(color: Colors.black),
            ],
          )
        ],
      ),
    ),
    actions: [
      Center(
        child: defaultButton(
          radius: 20,
          fSize: 15,
          tColor: Colors.white,
          width: MediaQuery.of(context).size.width * 0.3,
          background: Colors.redAccent,
          function: () => Navigator.pop(context),
          text: cancel,
        ),
      ),
    ],
  ),
);
