import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:visits/modules/Auth/cubit/states.dart';
import 'package:visits/modules/Auth/login/login_screen.dart';
import 'package:visits/shared/components/components.dart';
import 'package:visits/shared/playSound.dart';
import '../../../shared/components/constants.dart';
import '../../Home/home_screen.dart';
import '../cubit/cubit.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController regionValueController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      builder: (BuildContext context, state) {
        var cubit = AuthCubit.get(context);
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
                    image: AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Blur effect
              Center(
                child: BlurryContainer(
                  shadowColor: Colors.black.withAlpha(65),
                  elevation: 10,
                  borderRadius: BorderRadius.circular(20),
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            CustomDropDownMenu(
                              textColor: Colors.white,
                              titleColor: Colors.white,
                              title: region,
                              controller: regionController,
                              screenWidth:
                                  MediaQuery.of(context).size.width * 0.3,
                              screenRatio:
                                  MediaQuery.of(context).devicePixelRatio,
                              entries: [
                                for (var item in regions)
                                  DropdownMenuEntry(
                                    value: item.value,
                                    label: item.label,
                                  )
                              ],
                              onSelected: (value) {
                                regionValueController.text = value.toString();
                                print(regionValueController.text);
                              },
                            ),
                            SizedBox(height: 30),
                            defaultFormField(
                              radius: BorderRadius.circular(20),
                              controller: userNameController,
                              type: TextInputType.text,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return usernameError;
                                }
                                return null;
                              },
                              label: username,
                              prefix: Icons.person,
                            ),
                            SizedBox(height: 30),
                            defaultFormField(
                              radius: BorderRadius.circular(20),
                              controller: passwordController,
                              type: TextInputType.visiblePassword,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return passwordError;
                                }
                                return null;
                              },
                              label: password,
                              prefix: Icons.lock,
                              isPassword: true,
                              onSubmit: (value) {
                                if (_formKey.currentState!.validate()) {
                                  cubit.login(
                                    username: userNameController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                            ),
                            SizedBox(height: 30),
                            defaultButton(
                              radius: 20.0,
                              fSize: 20.0,
                              text: login,
                              function: () {
                                if (_formKey.currentState!.validate()) {
                                  cubit.register(
                                    username: userNameController.text,
                                    password: passwordController.text,
                                    region: int.parse(regionValueController.text),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      listener: (BuildContext context, state) {
        if (state is AuthRegisterLoadingState) {
          showLoadingDialog(context);
        }

        if (state is AuthRegisterSuccessState) {
          playSound('sfx/login.mp3');
          Toastification().show(
            type: ToastificationType.error,
            style: ToastificationStyle.flatColored,
            backgroundColor: Colors.green,
            borderSide: BorderSide(color: Colors.green, width: 1.0),
            showIcon: true,
            showProgressBar: false,
            title: Text(loginSuccess,
                style: TextStyle(color: Colors.white, fontSize: 18)),
            borderRadius: BorderRadius.circular(20.0),
            dragToClose: true,
            autoCloseDuration: const Duration(seconds: 3),
            applyBlurEffect: true,
            direction: TextDirection.rtl,
            icon: Icon(Icons.check_circle, color: Colors.green),
            alignment: Alignment.topCenter,
          );
          navigateAndFinish(context, LoginScreen());
        }

        if (state is AuthRegisterErrorState) {
          Navigator.pop(context);
          Toastification().show(
            style: ToastificationStyle.flatColored,
            type: ToastificationType.error,
            backgroundColor: Colors.red,
            borderSide: BorderSide(color: Colors.red, width: 1.0),
            showIcon: true,
            showProgressBar: false,
            title: Text(loginError,
                style: TextStyle(color: Colors.white, fontSize: 18)),
            borderRadius: BorderRadius.circular(20.0),
            dragToClose: true,
            autoCloseDuration: const Duration(seconds: 3),
            applyBlurEffect: true,
            direction: TextDirection.rtl,
            icon: Icon(Icons.error, color: Colors.red),
            alignment: Alignment.topCenter,
          );
        }
      },
    );
  }
}
