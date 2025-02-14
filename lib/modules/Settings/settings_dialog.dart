import 'package:flutter/material.dart';
import 'package:visits/shared/encrypt.dart';

Widget SettingsDialog(context) {
  return AlertDialog(
    backgroundColor: Colors.white70,
    title: const Text('الاعدادات'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text('تسجيل مستخدم جديد'),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => encrypt_screen(context));
          },
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
