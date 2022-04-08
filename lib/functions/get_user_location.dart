import 'package:location/location.dart';

/// [GetUserLocation] will get realtime location of user
class GetUserLocation{

  static Future<dynamic> getLocation() async{
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;


    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    LocationData locationData;
    locationData = await location.getLocation();
    if(locationData.longitude == null || locationData.latitude == null){
      return null;
    }
    return locationData;
  }

}