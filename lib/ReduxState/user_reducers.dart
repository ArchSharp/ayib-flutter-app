import 'package:ayib/ReduxState/actions.dart';
import 'package:ayib/ReduxState/store.dart';

AppState userReducer(AppState state, dynamic action) {
  if (action is UpdateUserAction) {
    return state..user = action.newUser;
  }
  if (action is InitialiseEmail) {
    return state..email = action.email;
  }

  if (action is LogOut) {
    return AppState(email: "", user: {});
  }

  return state;
}
