import 'package:flutter/material.dart';
import 'package:visits/models/Complaining/complaining_model.dart';
import 'package:visits/modules/Complaining/cubit/cubit.dart';
import 'package:visits/shared/components/constants.dart';

Widget ComplaintDialog(context, ComplainingModel model, ComplainingCubit cubit) => AlertDialog.adaptive(
  title: Text(complaintDetails),
  content: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10.0,),
        Text('بيانات مقدم الشكوى:', style: TextStyle(fontSize: 24.0, decoration: TextDecoration.underline),),
        const SizedBox(height: 15.0,),
        Text('$name: ${model.name}', style: TextStyle(fontSize: 18.0, color: Color(0xFF595757)),),
        const SizedBox(height: 10.0,),
        Text('$nationalId: ${model.nationalId}', style: TextStyle(fontSize: 18.0, color: Color(0xFF595757)),),
        const SizedBox(height: 10.0,),
        Text('$phoneNo: ${model.phone}', style: TextStyle(fontSize: 18.0, color: Color(0xFF595757)),),
        const SizedBox(height: 10.0,),
        Text('$additionalPhoneNo: ${model.phone2}', style: TextStyle(fontSize: 18.0, color: Color(0xFF595757)),),
        const SizedBox(height: 10.0,),
        Text('$address: ${model.address}', style: TextStyle(fontSize: 18.0, color: Color(0xFF595757)),),
        const SizedBox(height: 10.0,),
        Text('$department: ${model.department}', style: TextStyle(fontSize: 18.0, color: Color(0xFF595757)),),
        const SizedBox(height: 10.0,),
        Text('$complaint: \n\n${model.subject}', style: TextStyle(fontSize: 18.0),),
        const SizedBox(height: 20.0,),

        Text('بيانات مستلم الشكوى:', style: TextStyle(fontSize: 24.0, decoration: TextDecoration.underline),),
        const SizedBox(height: 15.0,),
        Text('$name: ${currentUser.name}', style: TextStyle(fontSize: 18.0, color: Color(0xFF595757)),),
        const SizedBox(height: 10.0,),
        Text('$phoneNo: ${currentUser.phone}', style: TextStyle(fontSize: 18.0, color: Color(0xFF595757)),),
        const SizedBox(height: 10.0,),
        Text('$nationalId: ${currentUser.nationalId}', style: TextStyle(fontSize: 18.0, color: Color(0xFF595757)),),


      ],
    ),
  ),
);