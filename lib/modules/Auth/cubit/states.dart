abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthSuccessState extends AuthStates {}

class AuthErrorState extends AuthStates {}

class AuthRegisterLoadingState extends AuthStates {}

class AuthRegisterSuccessState extends AuthStates {}

class AuthRegisterErrorState extends AuthStates {}

class AuthLogoutState extends AuthStates {}

class AuthCreateUserLoadingState extends AuthStates {}

class AuthCreateUserSuccessState extends AuthStates {}

class AuthCreateUserErrorState extends AuthStates {}

class AuthGetUserLoadingState extends AuthStates {}

class AuthGetUserSuccessState extends AuthStates {}

class AuthGetUserErrorState extends AuthStates {}

class AuthUpdateUserLoadingState extends AuthStates {}

class AuthUpdateUserSuccessState extends AuthStates {}

class AuthUpdateUserErrorState extends AuthStates {}

class AuthGetUsersLoadingState extends AuthStates {}

class AuthGetUsersSuccessState extends AuthStates {}

class AuthGetUsersErrorState extends AuthStates {}