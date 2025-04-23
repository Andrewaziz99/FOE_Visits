import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../shared/components/constants.dart';

Widget visitDialog(context, visits, visitors) => AlertDialog(
      title: Text(visits_data),
      content: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Table(
                  border: TableBorder.all(
                      color: Colors.black45,
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
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              name,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              phoneNo,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              additionalPhoneNo,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              department,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              visitReason,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
          //DATE
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              visitDate,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),

          //Table Data
                    for(var visit in visits)
                      for(var visitor in visitors)
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              visitor.rank!,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              visitor.name!,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              visitor.phone_number!,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              visitor.additional_phone_number ?? '',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              visitor.department!,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              visit.subject!,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              DateFormat('yyyy-MM-dd hh:mma').format(
                                  DateTime.parse(visit.visitDate.toString())),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
