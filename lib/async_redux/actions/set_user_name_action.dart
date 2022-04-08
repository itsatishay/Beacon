import 'package:async_redux/async_redux.dart';
import 'package:beacon/async_redux/app_state.dart';

/// To set user name in app state
class SetUserNameAction extends ReduxAction<AppState> {
  SetUserNameAction({required this.userName});

  final String userName;

  @override
  Future<AppState> reduce() async{
    return state.copy(userName: userName);
  }
}

