import 'dart:async';
import 'package:beacon/dataClasses/beacon_data.dart';
import 'package:beacon/dataClasses/user_location_data.dart';
import 'package:beacon/functions/debug_logger.dart';
import 'package:beacon/functions/show_snackbar.dart';
import 'package:beacon/functions/update_beacon_database.dart';
import 'package:beacon/hardcoded/hardcoded_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CreatedBeacon extends StatefulWidget {
  const CreatedBeacon({Key? key, required this.beaconData}) : super(key: key);
  final BeaconData beaconData;

  @override
  State<CreatedBeacon> createState() => _CreatedBeaconState();
}

class _CreatedBeaconState extends State<CreatedBeacon> {

  @override
  void initState(){
    lastLocationUpdateTime = DateTime.now();
    beaconData = widget.beaconData;
    cameraPosition = CameraPosition(target: LatLng(beaconData.userLocationData.latitude, beaconData.userLocationData.longitude), zoom: 15);
    observeUserLocationChanges();
    super.initState();
  }

  final Completer<GoogleMapController> _controller = Completer();
  /// global controller will be used to change view or animate in google maps view
  late GoogleMapController globalController;
  BeaconData beaconData = BeaconData.withoutParams();
  late CameraPosition cameraPosition;
  late StreamSubscription<LocationData> locationSubscription;
  late Location liveLocation;
  late DateTime lastLocationUpdateTime;

  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: backButtonPressed,
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    myLocationEnabled: true,
                    mapType: MapType.normal,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: cameraPosition,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      setState(() {
                        globalController = controller;
                      });
                    },
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: backButtonPressed,
                child: Container(
                  margin: EdgeInsets.only(left: width * 0.02, top: height * 0.05),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HardcodedColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: HardcodedColors.black.withOpacity(0.25),
                          spreadRadius: 3,
                          blurRadius: 8,
                          offset: const Offset(0,5),
                        )
                      ]
                  ),
                  child: Icon(Icons.arrow_back, color: HardcodedColors.black, size: width * 0.07),
                ),
              ),
            ),

            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: (){
                  animateCameraToUsersLocation(zoomLevel: 15);
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  margin: EdgeInsets.only(right: width * 0.02, top: height * 0.05),
                  width: width * 0.1,
                  height: width * 0.1,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HardcodedColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: HardcodedColors.black.withOpacity(0.25),
                          spreadRadius: 3,
                          blurRadius: 8,
                          offset: const Offset(0,5),
                        )
                      ]
                  ),
                  child: const Center(
                    child: Icon(Icons.my_location, color: HardcodedColors.black)
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: HardcodedColors.white,
                width: width,
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("CreatedBeacon.label_beacon_id".tr() + beaconData.beaconId, style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: HardcodedColors.black
                        ),),
                      ],
                    ),

                    const SizedBox(height: 15,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(beaconExpiryTime(), style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: HardcodedColors.red
                        ),),
                      ],
                    )

                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  Future<void> observeUserLocationChanges() async{
    liveLocation = Location();
    // change notification options for the notification that is shown when accessing background location
    await enableBackgroundMode(liveLocation);
    locationSubscription = liveLocation.onLocationChanged.listen((LocationData currentLocation) async{
      if(currentLocation.longitude != null && currentLocation.latitude != null){
        UserLocationData userLocationData = UserLocationData(
            longitude: currentLocation.longitude ?? 0.0,
            latitude: currentLocation.latitude ?? 0.0,
            updatedOn: DateTime.now().millisecondsSinceEpoch);
        setState(() {
          beaconData.userLocationData = userLocationData;
        });
        // update location in database
        int minuteDifference = DateTime.fromMillisecondsSinceEpoch(beaconData.expiry).difference(DateTime.now()).inMinutes;
        // location to update in database after every 20 seconds
        // delay time can be customized
        int lastUpdateDifference = DateTime.now().difference(lastLocationUpdateTime).inSeconds;
        if(minuteDifference > 0 && lastUpdateDifference > 20){
          bool result = await UpdateBeaconDatabase.updateBeaconData(beaconData);
          lastLocationUpdateTime = DateTime.now();
          if(!result){
            ShowSnackBar.show(context, "CreatedBeacon.error_updating_location_database".tr());
          }
        }
      }
    });
  }

  Future<bool> backButtonPressed() async{
    liveLocation.enableBackgroundMode(enable: false);
    locationSubscription.pause();
    locationSubscription.cancel();
    Navigator.pop(context);
    return true;
  }

  /// permission getter for background location access
  Future<bool> enableBackgroundMode(Location location) async {
    bool _bgModeEnabled = await location.isBackgroundModeEnabled();
    if (_bgModeEnabled) {
      return true;
    } else {
      try {
        await location.enableBackgroundMode();
      } catch (e) {
        DebugLogger.log(e.toString());
      }
      try {
        _bgModeEnabled = await location.enableBackgroundMode();
      } catch (e) {
        DebugLogger.log(e.toString());
      }
      DebugLogger.log("is location enabled : $_bgModeEnabled");
      return _bgModeEnabled;
    }
  }

  /// function to animate camera to user's current location
  void animateCameraToUsersLocation({double zoomLevel = 17}){
    cameraPosition =  CameraPosition(
        target: LatLng(beaconData.userLocationData.latitude,
            beaconData.userLocationData.longitude),
        zoom: zoomLevel
    );
    globalController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  String beaconExpiryTime(){
    int minuteDifference = DateTime.fromMillisecondsSinceEpoch(beaconData.expiry).difference(DateTime.now()).inMinutes;
    if(minuteDifference > 0){
      return "CreatedBeacon.msg_beacon_expire".tr() + "$minuteDifference minutes";
    }else{
      return "CreatedBeacon.msg_beacon_expired".tr();
    }
  }
}
