import 'package:ayib/ReduxState/userReducers.dart';
import 'package:redux/redux.dart';

class AppState {
  late Map<String, dynamic> user;
  late String email;
}

// Combine your reducers into a single reducer
final combinedReducers = combineReducers<AppState>([userReducer]);

// Create the Redux store
final Store<AppState> store = Store<AppState>(
  combinedReducers,
  initialState: AppState(),
);
