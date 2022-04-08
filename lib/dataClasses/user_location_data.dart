/// [UserLocationData] is json for location values within beacon data
class UserLocationData{

  UserLocationData.withoutParams();

  UserLocationData({
    required this.longitude,
    required this.latitude,
    required this.updatedOn});

  UserLocationData.fromJson(Map<String, dynamic> json){
    latitude = json['latitude'] as double;
    longitude = json['longitude'] as double;
    updatedOn = json['updatedOn'] as int;
  }

  double latitude = 0;
  double longitude = 0;
  int updatedOn = 0;

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = {};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['updatedOn'] = updatedOn;
    return data;
  }

}