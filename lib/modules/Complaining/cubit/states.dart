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