import 'package:visits/models/Engineers/engineers_model.dart';

abstract class homeStates {}

class homeInitialState extends homeStates {}

class getUserDataLoading extends homeStates {}

class getUserDataSuccess extends homeStates {}

class getUserDataError extends homeStates {}

class getVisitorsLoading extends homeStates {}

class getVisitorsSuccess extends homeStates {}

class getVisitorsError extends homeStates {}

class countVisitsLoading extends homeStates {}

class countVisitsSuccess extends homeStates {}

class countVisitsError extends homeStates {}

class addVisitorLoading extends homeStates {}

class addVisitorSuccess extends homeStates {}

class addVisitorError extends homeStates {}

class addVisitLoading extends homeStates {}

class addVisitSuccess extends homeStates {}

class addVisitError extends homeStates {}

class ImagePickerLoading extends homeStates {}

class ImagePickerSuccess extends homeStates {}

class ImagePickerError extends homeStates {}

class UpdateUserDataLoading extends homeStates {}

class UpdateUserDataSuccess extends homeStates {}

class UpdateUserDataError extends homeStates {}

class ImageUploadLoading extends homeStates {}

class ImageUploadSuccess extends homeStates {}

class ImageUploadError extends homeStates {}

class searchByPhoneLoading extends homeStates {}

class searchByPhoneSuccess extends homeStates {}

class searchByPhoneError extends homeStates {}

class searchByNameLoading extends homeStates {}

class searchByNameSuccess extends homeStates {}

class searchByNameError extends homeStates {}

class searchBySubjectLoading extends homeStates {}

class searchBySubjectSuccess extends homeStates {}

class searchBySubjectError extends homeStates {}

class getVisitorLoading extends homeStates {}

class getVisitorSuccess extends homeStates {}

class getVisitorError extends homeStates {}

class changePasswordLoading extends homeStates {}

class changePasswordSuccess extends homeStates {}

class changePasswordError extends homeStates {}

class getVisitsByDateLoading extends homeStates {}

class getVisitsByDateSuccess extends homeStates {}

class getVisitsByDateError extends homeStates {}

class getRealTimeVisitsByDateLoading extends homeStates {}

class getRealTimeVisitsByDateSuccess extends homeStates {}

class getRealTimeVisitsByDateError extends homeStates {}

class getSubjectsLoading extends homeStates {}

class getSubjectsSuccess extends homeStates {}

class getSubjectsError extends homeStates {}

class addSubjectLoading extends homeStates {}

class addSubjectSuccess extends homeStates {}

class addSubjectError extends homeStates {}

class getDepartmentsLoading extends homeStates {}

class getDepartmentsSuccess extends homeStates {}

class getDepartmentsError extends homeStates {}

class addDepartmentLoading extends homeStates {}

class addDepartmentSuccess extends homeStates {}

class addDepartmentError extends homeStates {}

class getEngineersLoading extends homeStates {}

class getEngineersSuccess extends homeStates {}

class getEngineersError extends homeStates {}

class EngineersUpdatedState extends homeStates {
  final List<EngineersModel> engineers;

  EngineersUpdatedState(this.engineers);
}

// States for modifying visitor
class modifyVisitorLoading extends homeStates {}

class modifyVisitorSuccess extends homeStates {}

class modifyVisitorError extends homeStates {}

// States for modifying visit
class modifyVisitLoading extends homeStates {}

class modifyVisitSuccess extends homeStates {}

class modifyVisitError extends homeStates {}

// States for deleting visit
class deleteVisitLoading extends homeStates {}

class deleteVisitSuccess extends homeStates {}

class deleteVisitError extends homeStates {}
