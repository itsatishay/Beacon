import 'dart:async';
import 'package:beacon/dataClasses/beacon_data.dart';
import 'package:beacon/hardcoded/hardcoded_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [AppState] represents the overall Redux state of the application.
class AppState {

  /// Constructor for [AppState]
  AppState({
    required this.userName,
    required this.beaconData
});

  final String userName;
  final BeaconData beaconData;

  /// the set the initial value for the corresponding variables if any
  static Future<AppState> initialState() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return AppState(
      userName: sharedPreferences.getString(HardcodedStrings.userNameLocalSaved) ?? "",
      beaconData: BeaconData.withoutParams()
    );
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppState &&
              runtimeType == other.runtimeType &&
              userName == other.userName &&
              beaconData == other.beaconData;


  @override
  int get hashCode =>
    userName.hashCode ^
    beaconData.hashCode;


  /// Copy Constructor creates a copy of the variable and stores the value into it
  AppState copy({
    String? userName,
    BeaconData? beaconData
  }) =>
      AppState(
          userName: userName ?? this.userName,
          beaconData: beaconData ?? this.beaconData
      );
}
