import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visits/modules/Settings/cubit/states.dart';

import '../../shared/components/constants.dart';
import 'cubit/cubit.dart';

Widget SettingsDialog(context) {
  return AlertDialog(
    backgroundColor: Colors.white70,
    title: const Text('الاعدادات'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(activate_gifs),
            const SizedBox(width: 10.0,),
            Switch.adaptive(
              activeColor: Colors.green,
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),

      ],
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('اغلاق'),
      ),
    ],
  );
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => settingsCubit(),
      child: BlocConsumer<settingsCubit, SettingsStates>(
        builder: (BuildContext context, state) {
          var cubit = settingsCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              toolbarHeight: 150,
              title: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/bar.gif',
                      fit: BoxFit.cover,
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(100),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/logo_name_black.png',
                          ),
                          Spacer(),
                          Text(dailyVisits, style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),),
                          Spacer(),
                          Image.asset(
                            'assets/images/logo1.png',
                            width: 150,
                            height: 150,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(activate_gifs),
                        const SizedBox(width: 10.0,),
                        Switch.adaptive(
                          activeColor: Colors.green,
                          value: cubit.isActive,
                          onChanged: (value) {
                            cubit.toggleSwitch(value);
                          },
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          );
        },
          listener: (BuildContext context, state) {  },
      ),
    );
  }
}
