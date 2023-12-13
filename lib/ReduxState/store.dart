import 'package:ayib/ReduxState/user_reducers.dart';
import 'package:redux/redux.dart';

class AppState {
  late Map<String, dynamic> user;
  late Map<String, dynamic> userToken;
  late Map<String, dynamic> userWallet;
  late String email;

  AppState(
      {required this.email,
      required this.user,
      required this.userToken,
      required this.userWallet});
}

// Combine your reducers into a single reducer
final combinedReducers = combineReducers<AppState>([userReducer]);

// Create the Redux store
final Store<AppState> store = Store<AppState>(
  combinedReducers,
  initialState: AppState(email: '', user: {}, userToken: {}, userWallet: {}),
);
