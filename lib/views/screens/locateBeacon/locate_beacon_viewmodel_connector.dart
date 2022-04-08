import 'package:async_redux/async_redux.dart';
import 'package:beacon/async_redux/actions/get_beacon_data_action.dart';
import 'package:beacon/async_redux/actions/set_beacon_data_action.dart';
import 'package:beacon/async_redux/app_state.dart';
import 'package:beacon/dataClasses/beacon_data.dart';
import 'package:beacon/functions/typedef.dart';
import 'package:beacon/views/screens/locateBeacon/locate_beacon.dart';
import 'package:flutter/material.dart';

/// Connector for [LocateBeacon]
class LocateBeaconConnector extends StatelessWidget {
  /// Constructor for [LocateBeaconConnector]
  const LocateBeaconConnector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LocateBeaconViewModel>(
      model: LocateBeaconViewModel(),
      builder: (BuildContext bc, LocateBeaconViewModel vm) => LocateBeacon(
          beaconData: vm.beaconData,
          getBeaconData: vm.getBeaconData,
          setBeaconData: vm.setBeaconData)

    );
  }
}

/// View Model for [LocateBeacon]
class LocateBeaconViewModel extends BaseModel<AppState> {
  /// Constructor for [LocateBeaconViewModel]
  LocateBeaconViewModel();

  late BeaconData beaconData;
  late GetBeaconData getBeaconData;
  late SetBeaconData setBeaconData;

  ///
  LocateBeaconViewModel.build({
    required this.beaconData,
    required this.getBeaconData,
    required this.setBeaconData}) : super(equals: <dynamic>[beaconData]);

  @override
  LocateBeaconViewModel fromStore() => LocateBeaconViewModel.build(
    beaconData: state.beaconData,
    getBeaconData: (String id){
      dispatch!(GetBeaconDataAction(id: id));
    },
    setBeaconData: (BeaconData beaconData){
      dispatch!(SetBeaconDataAction(beaconData: beaconData));
    }
  );
}