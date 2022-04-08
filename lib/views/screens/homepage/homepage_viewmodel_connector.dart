import 'package:async_redux/async_redux.dart';
import 'package:beacon/async_redux/actions/set_beacon_data_action.dart';
import 'package:beacon/async_redux/app_state.dart';
import 'package:beacon/dataClasses/beacon_data.dart';
import 'package:beacon/functions/typedef.dart';
import 'package:beacon/views/screens/homepage/homepage.dart';
import 'package:flutter/material.dart';

/// Connector for [Homepage]
class HomepageConnector extends StatelessWidget {
  /// Constructor for [HomepageConnector]
  const HomepageConnector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomepageViewModel>(
      model: HomepageViewModel(),
      builder: (BuildContext bc, HomepageViewModel vm) => Homepage(
          userName: vm.userName,
          setBeaconData: vm.setBeaconData)

    );
  }
}

/// View Model for [Homepage]
class HomepageViewModel extends BaseModel<AppState> {
  /// Constructor for [HomepageViewModel]
  HomepageViewModel();

  late String userName;
  late SetBeaconData setBeaconData;

  ///
  HomepageViewModel.build({required this.userName, required this.setBeaconData}) : super(equals: <dynamic>[userName]);

  @override
  HomepageViewModel fromStore() => HomepageViewModel.build(
    userName: state.userName,
    setBeaconData: (BeaconData beaconData){
      dispatch!(SetBeaconDataAction(beaconData: beaconData));
    }
  );
}