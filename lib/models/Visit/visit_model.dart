class VisitModel{
  int? id;
  int? visitor_id;
  String? feedback;
  String? subject;
  String? visitDate;
  int? region;

  VisitModel({
    this.id,
    this.visitor_id,
    this.feedback,
    this.subject,
    this.visitDate,
    this.region,
  });

  VisitModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    visitor_id = json['visitor_id'];
    feedback = json['feedback'];
    subject = json['subject'];
    visitDate = json['visitDate'];
    region = json['region'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visitor_id': visitor_id,
      'feedback': feedback,
      'subject': subject,
      'visitDate': visitDate,
      'region': region,
    };
  }

}