import 'package:async_redux/async_redux.dart';
import 'package:beacon/async_redux/actions/set_user_name_action.dart';
import 'package:beacon/async_redux/app_state.dart';
import 'package:beacon/functions/typedef.dart';
import 'package:beacon/views/screens/enterName/enter_name.dart';
import 'package:flutter/material.dart';

/// Connector for [EnterName]
class EnterNameConnector extends StatelessWidget {
  /// Constructor for [EnterNameConnector]
  const EnterNameConnector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, EnterNameViewModel>(
      model: EnterNameViewModel(),
      builder: (BuildContext bc, EnterNameViewModel vm) => EnterName(
        setUserName: vm.setUserName
      )

    );
  }
}

/// View Model for [EnterName]
class EnterNameViewModel extends BaseModel<AppState> {
  /// Constructor for [EnterNameViewModel]
  EnterNameViewModel();

  late SetUserName setUserName;

  ///
  EnterNameViewModel.build({required this.setUserName}) : super(equals: <dynamic>[]);

  @override
  EnterNameViewModel fromStore() => EnterNameViewModel.build(
    setUserName: (String name){
      dispatch!(SetUserNameAction(userName: name));
    }
  );
}