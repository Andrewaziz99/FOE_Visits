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
  final String? attachments;
  final String? specialistName;
  final String? specialistPhone;
  final String? compDepartment;
  // Assuming status is an integer representing the complaint status
  final int? status;
  final String? registrationNumber;
  final String? registrarName;
  final String? registrarPhone;
  final String? registrarNationalId;

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
    this.attachments,
    this.specialistName,
    this.specialistPhone,
    this.compDepartment,
    this.status,
    this.registrationNumber,
    this.registrarName,
    this.registrarPhone,
    this.registrarNationalId,
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
    'attachments': attachments,
    'specialistName': specialistName,
    'specialistPhone': specialistPhone,
    'compDepartment': compDepartment,
    'status': status,
    'registrationNumber': registrationNumber,
    'registrarName': registrarName,
    'registrarPhone': registrarPhone,
    'registrarNationalId': registrarNationalId,
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
    attachments: json['attachments'],
    specialistName: json['specialistName'],
    specialistPhone: json['specialistPhone'],
    compDepartment: json['compDepartment'],
    status: json['status'],
    registrationNumber: json['registrationNumber'],
    registrarName: json['registrarName'],
    registrarPhone: json['registrarPhone'],
    registrarNationalId: json['registrarNationalId'],

  );

  ComplainingModel copyWith({
    String? name,
    String? nationalId,
    String? phone,
    String? phone2,
    String? address,
    String? department,
    String? subject,
    DateTime? submitDate,
    DateTime? reminderTime,
    String? docPath,
    String? attachments,
    String? specialistName,
    String? specialistPhone,
    String? compDepartment,
    int? status,
    String? registrationNumber,
    String? registrarName,
    String? registrarPhone,
    String? registrarNationalId,
  }) {
    return ComplainingModel(
      name: name ?? this.name,
      nationalId: nationalId ?? this.nationalId,
      phone: phone ?? this.phone,
      phone2: phone2 ?? this.phone2,
      address: address ?? this.address,
      department: department ?? this.department,
      subject: subject ?? this.subject,
      submitDate: submitDate ?? this.submitDate,
      reminderTime: reminderTime ?? this.reminderTime,
      docPath: docPath ?? this.docPath,
      attachments: attachments ?? this.attachments,
      specialistName: specialistName ?? this.specialistName,
      specialistPhone: specialistPhone ?? this.specialistPhone,
      compDepartment: compDepartment ?? this.compDepartment,
      status: status ?? this.status,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      registrarName: this.registrarName,
      registrarPhone: this.registrarPhone,
      registrarNationalId: this.registrarNationalId,
    );
  }
}


