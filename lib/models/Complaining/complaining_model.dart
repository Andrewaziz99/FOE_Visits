class ComplainingModel {
  final String name;
  final String nationalId;
  final String phone;
  final String phone2;
  final String address;
  final String department;
  final String subject;
  final DateTime submitDate;
  final DateTime reminderTime;
  final String? docPath;

  ComplainingModel({
    required this.name,
    required this.nationalId,
    required this.phone,
    required this.phone2,
    required this.address,
    required this.department,
    required this.subject,
    required this.submitDate,
    required this.reminderTime,
    this.docPath,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'nationalId': nationalId,
    'phone': phone,
    'phone2': phone2,
    'address': address,
    'department': department,
    'subject': subject,
    'submit_date': submitDate.toIso8601String(),
    'reminder_time': reminderTime.toIso8601String(),
    'doc_path': docPath,
  };

  factory ComplainingModel.fromJson(Map<String, dynamic> json) => ComplainingModel(
    name: json['name'],
    nationalId: json['nationalId'],
    phone: json['phone'],
    phone2: json['phone2'],
    address: json['address'],
    department: json['department'],
    subject: json['subject'],
    submitDate: DateTime.parse(json['submit_date']),
    reminderTime: DateTime.parse(json['reminder_time']),
    docPath: json['doc_path'],
  );
}


