import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:visits/modules/Auth/Register/register_screen.dart';

import 'components/components.dart';
import 'components/constants.dart';

TextEditingController controller = TextEditingController();
final _formkey = GlobalKey<FormState>();
Widget encrypt_screen(context) {
  return BlurryContainer(
    child: AlertDialog(
      backgroundColor: Colors.white70,
      title: Center(child: const Text(register)),
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
                    controller: controller,
                    type: TextInputType.visiblePassword,
                    label: password,
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
                  onSubmit: (value) {
                    if (_formkey.currentState!.validate() && controller.text == pass) {
                      navigateTo(context, RegisterScreen());
                      controller.clear();
                    }
                  },
                ),
                SizedBox(height: 20),
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
            if (_formkey.currentState!.validate() && controller.text == pass) {
              navigateTo(context, RegisterScreen());
              controller.clear();
            }
          },
        ),
      ],
    ),
  );
}