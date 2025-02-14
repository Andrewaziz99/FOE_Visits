class VisitModel{
  int? id;
  int? visitor_id;
  String? visitDestination;
  String? subject;
  String? visitDate;
  int? region;

  VisitModel({
    this.id,
    this.visitor_id,
    this.visitDestination,
    this.subject,
    this.visitDate,
    this.region,
  });

  VisitModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    visitor_id = json['visitor_id'];
    visitDestination = json['visitDestination'];
    subject = json['subject'];
    visitDate = json['visitDate'];
    region = json['region'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visitor_id': visitor_id,
      'visitDestination': visitDestination,
      'subject': subject,
      'visitDate': visitDate,
      'region': region,
    };
  }

}