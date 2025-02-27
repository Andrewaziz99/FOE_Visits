import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';

Widget visitData(context, event, data) => AlertDialog(
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
                          visitDestination,
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
                          data['visitDestination'],
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
      ],
    );
