import 'package:beacon/dataClasses/user_location_data.dart';

/// [BeaconData] is json for locating or creating a beacon
class BeaconData{

  BeaconData.withoutParams();

  BeaconData({
    required this.userLocationData,
    required this.createdOn,
    required this.createdBy,
    required this.expiry,
    required this.beaconId});

  BeaconData.fromJson(Map<String, dynamic> json){
    createdBy = json['createdBy'] as String;
    createdOn = json['createdOn'] as int;
    expiry = json['expiry'] as int;
    beaconId = json['beaconId'] as String;
    userLocationData = UserLocationData.fromJson(json['location']);
  }

  String createdBy = "";
  int createdOn = 0;
  int expiry = 0;
  String beaconId = "";
  UserLocationData userLocationData = UserLocationData.withoutParams();

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = {};
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['expiry'] = expiry;
    data['beaconId'] = beaconId;
    data['location'] = userLocationData.toJson();
    return data;
  }


}