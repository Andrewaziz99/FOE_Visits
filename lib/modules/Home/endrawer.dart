import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:visits/modules/Home/cubit/cubit.dart';
import 'package:visits/modules/Home/password.dart';
import 'package:visits/shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/encrypt.dart';
import '../Visits/cubit/states.dart';


Widget menu(context, cubit, AuthCubit, state) => Drawer(
  child: Stack(
    fit: StackFit.expand,
    children: [
      // Background image
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/logo_transparent.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),

      ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ConditionalBuilder(
            condition: state is! getUserDataLoading,
            builder: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: (){
                    cubit.pickImage();
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(cubit.user.image!),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  cubit.user.username!,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                const SizedBox(height: 20),
                myDivider(color: Colors.grey),
                const SizedBox(height: 20),
                Center(child: Image.asset('assets/images/logo1.png', width: 300, height: 300)),
              ],
            ),
            fallback: (context) => const Center(child: CircularProgressIndicator()),
          ),
        ),
        ListTile(
          leading: Icon(Icons.person_add_alt_rounded),
          title: Text(
            'إضافة مستخدم جديد',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          onTap: () {
            showDialog(context: context, builder: (context) => encrypt_screen(context));
          },
        ),
        // ListTile(
        //   leading: Icon(Icons.password_rounded),
        //   title: Text(
        //     'تغيير كلمة المرور',
        //     style: TextStyle(color: Colors.black, fontSize: 20),
        //   ),
        //   onTap: () {
        //     showDialog(context: context, builder: (context) => change_password(context, homeCubit()));
        //   },
        // ),
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
    ],
  ),
);