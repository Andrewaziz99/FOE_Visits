import 'package:file_picker/file_picker.dart';

abstract class ComplainingStates {}

class ComplainingInitial extends ComplainingStates {}

class ComplainingLoading extends ComplainingStates {}

class ComplainingSuccess extends ComplainingStates {
}

class ComplainingError extends ComplainingStates {
  final String error;

  ComplainingError(this.error);
}

class getVisitorsLoadingState extends ComplainingStates {}

class getVisitorsSuccessState extends ComplainingStates {
}

class getVisitorsErrorState extends ComplainingStates {
  final String error;

  getVisitorsErrorState(this.error);
}

class searchByPhoneLoading extends ComplainingStates {}

class searchByPhoneSuccess extends ComplainingStates {}

class searchByPhoneError extends ComplainingStates {
  final String error;

  searchByPhoneError(this.error);
}

class searchByNameLoading extends ComplainingStates {}

class searchByNameSuccess extends ComplainingStates {}

class searchByNameError extends ComplainingStates {
  final String error;

  searchByNameError(this.error);
}

class getDepartmentsLoading extends ComplainingStates {}

class getDepartmentsSuccess extends ComplainingStates {
  final List<String> departments;

  getDepartmentsSuccess(this.departments);
}

class getDepartmentsError extends ComplainingStates {
  final String error;

  getDepartmentsError(this.error);
}

class printComplaintLoading extends ComplainingStates {}

class printComplaintSuccess extends ComplainingStates {
}

class printComplaintError extends ComplainingStates {
  final String error;

  printComplaintError(this.error);
}

class fetchAllComplaintsLoadingState extends ComplainingStates {}

class fetchAllComplaintsSuccessState extends ComplainingStates {}

class fetchAllComplaintsErrorState extends ComplainingStates {}

class addComplaintLoadingState extends ComplainingStates {}

class addComplaintSuccessState extends ComplainingStates {}

class addComplaintErrorState extends ComplainingStates {
  final String error;

  addComplaintErrorState(this.error);
}

class deleteComplaintLoadingState extends ComplainingStates {}

class deleteComplaintSuccessState extends ComplainingStates {}

class deleteComplaintErrorState extends ComplainingStates {}

class editComplaintLoadingState extends ComplainingStates {}

class editComplaintSuccessState extends ComplainingStates {}

class editComplaintErrorState extends ComplainingStates {}

class getTodaysReminderLoadingState extends ComplainingStates {}

class getTodaysReminderSuccessState extends ComplainingStates {}

class getTodaysReminderErrorState extends ComplainingStates {
  final String error;

  getTodaysReminderErrorState(this.error);
}

class getAttachmentLoadingState extends ComplainingStates {}

class getAttachmentSuccessState extends ComplainingStates {
  final FilePickerResult attachmentUrl;

  getAttachmentSuccessState(this.attachmentUrl);
}

class getAttachmentErrorState extends ComplainingStates {
  final String error;

  getAttachmentErrorState(this.error);
}

class getAttachmentCancelledState extends ComplainingStates {}

class filterComplaintsByDepartmentLoadingState extends ComplainingStates {}

class filterComplaintsByDepartmentSuccessState extends ComplainingStates {}

class filterComplaintsByDepartmentErrorState extends ComplainingStates {
  final String error;

  filterComplaintsByDepartmentErrorState(this.error);
}