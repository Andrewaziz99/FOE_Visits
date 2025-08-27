import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:visits/modules/Home/cubit/states.dart';
import 'package:visits/modules/Home/home_screen.dart';
import 'package:visits/modules/loading_screen.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/image_helper.dart';
import 'cubit/cubit.dart';

TextEditingController oldPasswordController = TextEditingController();
TextEditingController newPasswordController = TextEditingController();
final _formkey = GlobalKey<FormState>();

// Widget change_password(context) {
//   return BlurryContainer(
//     child: AlertDialog(
//       backgroundColor: Colors.white70,
//       title: Center(child: const Text(changePassword)),
//       content: SizedBox(
//         width: MediaQuery.of(context).size.width * 0.5,
//         height: MediaQuery.of(context).size.height * 0.2,
//
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formkey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 defaultFormField(
//                   labelColor: Colors.redAccent,
//                   textColor: Colors.black,
//                   radius: BorderRadius.circular(10),
//                   controller: oldPasswordController,
//                   type: TextInputType.visiblePassword,
//                   label: oldPassword,
//                   isPassword: true,
//                   validate: (value) {
//                     if (value!.isEmpty) {
//                       return passwordError;
//                     }
//                     else if (value != pass) {
//                       return wrongPass;
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 defaultFormField(
//                   labelColor: Colors.redAccent,
//                   textColor: Colors.black,
//                   radius: BorderRadius.circular(10),
//                   controller: newPasswordController,
//                   type: TextInputType.visiblePassword,
//                   label: newPassword,
//                   isPassword: true,
//                   validate: (value) {
//                     if (value!.isEmpty) {
//                       return passwordError;
//                     }
//                     return null;
//                   },
//                   onSubmit: (value) {
//                     if (_formkey.currentState!.validate()) {
//                       homeCubit.get(context).changePassword(oldPasswordController.text, newPasswordController.text);
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       actions: [
//         defaultButton(
//           width: 200,
//           radius: 15,
//           fSize: 20,
//           background: Colors.red,
//           tColor: Colors.white,
//           text: close,
//           function: () {
//             Navigator.pop(context);
//           },
//         ),
//         defaultButton(
//           width: 200,
//           radius: 15,
//           fSize: 20,
//           background: Colors.blue,
//           tColor: Colors.white,
//           text: confirm,
//           function: () {
//             if (_formkey.currentState!.validate()) {
//
//             }
//           },
//         ),
//       ],
//     ),
//   );
// }

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => homeCubit(),
      child: BlocConsumer<homeCubit, homeStates>(
        builder: (BuildContext context, state) {
          var cubit = homeCubit.get(context);

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
                      ImageHelper.getImagePath('assets/images/bar.gif'),
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
                          Text(
                            dailyVisits,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
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
            body: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                } else if (value != pass) {
                                  return wrongPass;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            defaultFormField(
                              maxLength: 4,
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
                                      oldPasswordController.text,
                                      newPasswordController.text);
                                }
                              },
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            defaultButton(
                                function: () {
                                  if (_formkey.currentState!.validate()) {
                                    cubit.changePassword(
                                        oldPasswordController.text,
                                        newPasswordController.text);
                                  }
                                },
                                text: confirm,
                                radius: 20.0,
                                tColor: Colors.white,
                                fSize: 20.0,
                                width: MediaQuery.of(context).size.width * 0.3,
                                background: Colors.green),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (BuildContext context, state) {
          if (state is changePasswordLoading) {
            showDialog(context: context, builder: (context) => loadingDialog(context));
          }
          if (state is changePasswordSuccess) {
            Navigator.pop(context);
            QuickAlert.show(
                width: MediaQuery.of(context).size.width * 0.2,
                borderRadius: 15,
                animType: QuickAlertAnimType.scale,
                context: context,
                type: QuickAlertType.success,
                autoCloseDuration: Duration(seconds: 3),
                title: changePasswordDone,
                confirmBtnText: done).then((value) {navigateAndFinish(context, HomeScreen(is_admin: true,));});

            oldPasswordController.clear();
            newPasswordController.clear();
          }
          

        },
      ),
    );
  }
}
