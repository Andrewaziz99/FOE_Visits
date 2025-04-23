import 'package:visits/models/Visitor/visitor_model.dart';

class VisitDataModel {
  final int? id;
  final int? visitor_id;
  final String visitDestination;
  final String subject;
  final String? visitDate;
  final int? region;
  final VisitorModel? visitors;

  VisitDataModel({
    this.id,
    this.visitor_id,
    this.visitDestination = '', // Default value to avoid null
    this.subject = '', // Default value to avoid null
    this.visitDate,
    this.region,
    this.visitors,
  });

  factory VisitDataModel.fromJson(Map<String, dynamic> json) {
    return VisitDataModel(
      id: json['id'],
      visitDate: json['visitDate'],
      visitor_id: json['visitor_id'],
      visitDestination: json['visitDestination'] ?? '', // Default value
      subject: json['subject'] ?? '', // Default value
      region: json['region'],
      visitors: json['visitors'] != null
          ? VisitorModel.fromJson(json['visitors'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['visitDate'] = visitDate;
    data['visitor_id'] = visitor_id;
    data['visitDestination'] = visitDestination;
    data['subject'] = subject;
    data['region'] = region;
    if (visitors != null) {
      data['visitors'] = visitors!.toJson();
    }
    return data;
  }
}