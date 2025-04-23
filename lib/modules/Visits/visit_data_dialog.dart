import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_textfield_search/new_textfield_search.dart';
import 'package:quickalert/quickalert.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';

TextEditingController visitorRankController = TextEditingController();
TextEditingController visitorNameController = TextEditingController();
TextEditingController visitorPhoneController = TextEditingController();
TextEditingController visitorAdditionalPhoneController =
    TextEditingController();
TextEditingController visitorDepartmentController = TextEditingController();
TextEditingController visitReasonController = TextEditingController();

Widget visitData(context, event, data, cubit) => AlertDialog(
      backgroundColor: Colors.transparent,
      title: const Text(
        'بيانات الزيارة',
        style: TextStyle(color: Colors.white),
      ),
      content: BlurryContainer(
        blur: 50,
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.2,
        color: Colors.white54,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Table(
              border: TableBorder.all(
                  color: Colors.white60,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              children: [
                //Table Headers
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          rank,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          name,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          phoneNo,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          additionalPhoneNo,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          department,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          visitReason,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          startDate,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          endDate,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ],
                ),

                //Table Data
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['rank'],
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['name'],
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['phoneNo'],
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['additionalPhoneNo'] ?? 'لا يوجد',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['department'],
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['visitReason'],
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          DateFormat('yyyy-MM-dd hh:mma').format(DateTime.parse(
                            '${event.startTime}',
                          )),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          DateFormat('yyyy-MM-dd hh:mma').format(DateTime.parse(
                            '${event.endTime}',
                          )),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        defaultButton(
          width: 200,
          radius: 15,
          fSize: 20,
          background: Colors.black,
          tColor: Colors.white,
          text: back,
          function: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(
          width: 20.0,
        ),
        defaultButton(
          width: 200,
          radius: 15,
          fSize: 20,
          background: Colors.blue,
          tColor: Colors.white,
          text: edit,
          function: () {
            UpdateSheet(context, data, cubit);
          },
        ),
      ],
    );

UpdateSheet(context, data, cubit) {
  visitorRankController.text = data['rank'];
  visitorNameController.text = data['name'];
  visitorPhoneController.text = data['phoneNo'];
  visitorAdditionalPhoneController.text =
      data['additionalPhoneNo'] ?? 'لا يوجد';
  visitorDepartmentController.text = data['department'];
  visitReasonController.text = data['visitReason'];

  QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: editData,
      confirmBtnText: edit,
      cancelBtnText: back,
      showCancelBtn: true,
      onCancelBtnTap: (){Navigator.pop(context);},
      onConfirmBtnTap: () {
        cubit.updateVisit(
          id: data['event_id'],
          visitorRank: visitorRankController.text,
          visitorName: visitorNameController.text,
          visitorPhone: visitorPhoneController.text,
          visitorAdditionalPhone: visitorAdditionalPhoneController.text,
          visitorDepartment: visitorDepartmentController.text,
          visitReason: visitReasonController.text,
        );
        Navigator.pop(context);
      },
      widget: Column(
        children: [
          defaultFormField(
              labelColor: Colors.black,
              textColor: Colors.black,
              controller: visitorRankController,
              type: TextInputType.text,
              label: rank,
              validate: (value) {}),

          SizedBox(height: 20.0,),

          defaultFormField(
              labelColor: Colors.black,
              textColor: Colors.black,
              controller: visitorNameController,
              type: TextInputType.text,
              label: name,
              validate: (value) {}),

          SizedBox(height: 20.0,),

          defaultFormField(
              labelColor: Colors.black,
              textColor: Colors.black,
              controller: visitorPhoneController,
              type: TextInputType.text,
              label: phoneNo,
              validate: (value) {}),

          SizedBox(height: 20.0,),

          defaultFormField(
              labelColor: Colors.black,
              textColor: Colors.black,
              controller: visitorAdditionalPhoneController,
              type: TextInputType.text,
              label: additionalPhoneNo,
              validate: (value) {}),

          SizedBox(height: 20.0,),

          defaultFormField(
              labelColor: Colors.black,
              textColor: Colors.black,
              controller: visitorDepartmentController,
              type: TextInputType.text,
              label: department,
              validate: (value) {}),

          SizedBox(height: 20.0,),

          defaultFormField(
              labelColor: Colors.black,
              textColor: Colors.black,
              controller: visitReasonController,
              type: TextInputType.text,
              label: subject,
              validate: (value) {}),

          SizedBox(height: 20.0,),

        ],
      ));
}
