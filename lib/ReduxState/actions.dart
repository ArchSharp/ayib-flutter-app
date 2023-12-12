class UpdateUserAction {
  final Map<String, dynamic> newUser;

  UpdateUserAction(this.newUser);
}

class InitialiseEmail {
  final String email;

  InitialiseEmail(this.email);
}

class LogOut {
  LogOut();
}

class SaveUserToken {
  final Map<String, dynamic> userToken;

  SaveUserToken(this.userToken);
}
