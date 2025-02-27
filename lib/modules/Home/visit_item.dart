import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

Widget visitItem(index, visitor, visit) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      Text('${index + 1}'),
      const Spacer(),
      Text(visitor.name),
      const Spacer(),
      Text(visitor.phone_number),
      const Spacer(),
      Text(visitor.additional_phone_number),
      const Spacer(),
      Text(visitor.department),
      const Spacer(),
      Text(visit.subject),
      const Spacer(),
      Text(visit.visitDestination),
      const Spacer(),
      Text(DateFormat('yyyy-MM-dd hh:mma').format(DateTime.parse(visit.visitDate))),
    ],
  ),
);