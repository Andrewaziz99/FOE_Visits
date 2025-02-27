import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';

TextEditingController oldPasswordController = TextEditingController();
TextEditingController newPasswordController = TextEditingController();
final _formkey = GlobalKey<FormState>();

Widget change_password(context, cubit) {
  return BlurryContainer(
    child: AlertDialog(
      backgroundColor: Colors.white70,
      title: Center(child: const Text(changePassword)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.2,

        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                defaultFormField(
                  labelColor: Colors.redAccent,
                  textColor: Colors.black,
                  radius: BorderRadius.circular(10),
                  controller: oldPasswordController,
                  type: TextInputType.visiblePassword,
                  label: oldPassword,
                  isPassword: true,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return passwordError;
                    }
                    else if (value != pass) {
                      return wrongPass;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                defaultFormField(
                  labelColor: Colors.redAccent,
                  textColor: Colors.black,
                  radius: BorderRadius.circular(10),
                  controller: newPasswordController,
                  type: TextInputType.visiblePassword,
                  label: newPassword,
                  isPassword: true,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return passwordError;
                    }
                    return null;
                  },
                  onSubmit: (value) {
                    if (_formkey.currentState!.validate()) {
                      cubit.changePassword(
                        oldPassword: oldPasswordController.text,
                        newPassword: newPasswordController.text,
                      );
                    }
                  },
                ),
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
            Navigator.pop(context);
          },
        ),
        defaultButton(
          width: 200,
          radius: 15,
          fSize: 20,
          background: Colors.blue,
          tColor: Colors.white,
          text: confirm,
          function: () {
            if (_formkey.currentState!.validate()) {

            }
          },
        ),
      ],
    ),
  );
}