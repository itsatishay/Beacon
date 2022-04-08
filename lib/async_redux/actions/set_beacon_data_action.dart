import 'package:async_redux/async_redux.dart';
import 'package:beacon/async_redux/app_state.dart';
import 'package:beacon/dataClasses/beacon_data.dart';

/// To set beacon data in app state
class SetBeaconDataAction extends ReduxAction<AppState> {
  SetBeaconDataAction({required this.beaconData});

  final BeaconData beaconData;

  @override
  Future<AppState> reduce() async{
    return state.copy(beaconData: beaconData);
  }
}

