import '../Visitor/visitor_model.dart';

class EngineersModel {
  final int id;
  final VisitorModel? visitor;

  EngineersModel({
    required this.id,
    this.visitor,
  });

  factory EngineersModel.fromJson(Map<String, dynamic> json) {
    return EngineersModel(
      id: json['id'] as int,
      visitor: json['visitors'] != null
          ? VisitorModel.fromJson(json['visitors'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (visitor != null) 'visitors': visitor!.toJson(),
    };
  }
}