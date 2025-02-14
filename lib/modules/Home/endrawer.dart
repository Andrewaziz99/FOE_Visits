import 'package:flutter/material.dart';
import 'package:visits/shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../Settings/settings_dialog.dart';
import '../Visits/visits_screen.dart';

Widget menu(context, cubit, AuthCubit) => Drawer(
  child: ListView(
    children: [
      DrawerHeader(
        decoration: BoxDecoration(color: Colors.blueAccent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: const AssetImage('assets/images/user.png'),
            ),
            const SizedBox(height: 10),
            Text(
              user,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
      ListTile(
        leading: Icon(Icons.home_rounded),
        title: Text(
          'الرئيسية',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: Icon(Icons.calendar_month_rounded),
        title: Text(
          'الزيارات',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        onTap: () {
          navigateTo(context, VisitsScreen());
        },
      ),
      ListTile(
        leading: Icon(Icons.settings_outlined),
        title: Text(
          'الاعدادات',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        onTap: () {
          showDialog(context: context, builder: (context) => SettingsDialog(context));
        },
      ),
      ListTile(
        leading: Icon(Icons.exit_to_app_rounded, color: Colors.redAccent,),
        title: Text(
          logout,
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        onTap: () {
          AuthCubit.logout(context);
        },
      ),
    ],
  ),
);