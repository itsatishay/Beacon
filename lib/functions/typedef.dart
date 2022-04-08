import 'package:beacon/dataClasses/beacon_data.dart';

// to set user name in app state
typedef SetUserName = void Function(String name);

// to set beacon data in app state
typedef SetBeaconData = void Function(BeaconData beaconData);

// get beacon data from database
typedef GetBeaconData = void Function(String id);

