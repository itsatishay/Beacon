import 'package:async_redux/async_redux.dart';
import 'package:beacon/async_redux/actions/set_beacon_data_action.dart';
import 'package:beacon/async_redux/app_state.dart';
import 'package:beacon/dataClasses/beacon_data.dart';
import 'package:beacon/functions/typedef.dart';
import 'package:beacon/views/screens/enterBeaconId/enter_beacon_id.dart';
import 'package:flutter/material.dart';

/// Connector for [EnterBeaconId]
class EnterBeaconIdConnector extends StatelessWidget {
  /// Constructor for [EnterBeaconIdConnector]
  const EnterBeaconIdConnector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, EnterBeaconIdViewModel>(
      model: EnterBeaconIdViewModel(),
      builder: (BuildContext bc, EnterBeaconIdViewModel vm) => EnterBeaconId(setBeaconData: vm.setBeaconData)

    );
  }
}

/// View Model for [EnterBeaconId]
class EnterBeaconIdViewModel extends BaseModel<AppState> {
  /// Constructor for [EnterBeaconIdViewModel]
  EnterBeaconIdViewModel();

  late SetBeaconData setBeaconData;

  ///
  EnterBeaconIdViewModel.build({required this.setBeaconData}) : super(equals: <dynamic>[]);

  @override
  EnterBeaconIdViewModel fromStore() => EnterBeaconIdViewModel.build(
    setBeaconData: (BeaconData beaconData){
      dispatch!(SetBeaconDataAction(beaconData: beaconData));
    }
  );
}