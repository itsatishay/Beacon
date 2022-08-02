import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'package:beacon/dataClasses/beacon_data.dart';
import 'package:beacon/functions/get_user_location.dart';
import 'package:beacon/functions/typedef.dart';
import 'package:beacon/hardcoded/hardcoded_colors.dart';
import 'package:beacon/views/components/create_image_profile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocateBeacon extends StatefulWidget {
  const LocateBeacon({Key? key, required this.beaconData, required this.getBeaconData, required this.setBeaconData}) : super(key: key);
  final BeaconData beaconData;
  final GetBeaconData getBeaconData;
  final SetBeaconData setBeaconData;

  @override
  State<LocateBeacon> createState() => _LocateBeaconState();
}

class _LocateBeaconState extends State<LocateBeacon> {

  @override
  void initState(){
    getUserLocation();
    widget.getBeaconData(widget.beaconData.beaconId);
    cameraPosition = CameraPosition(target: LatLng(widget.beaconData.userLocationData.latitude, widget.beaconData.userLocationData.longitude), zoom: 15);
    buildMarkers();
    super.initState();
  }

  @override
  void didUpdateWidget(LocateBeacon old) {
    super.didUpdateWidget(old);
    buildMarkers();
  }

  final Completer<GoogleMapController> _controller = Completer();
  /// global controller will be used to change view or animate in google maps view
  late GoogleMapController globalController;
  late CameraPosition cameraPosition;
  late Uint8List userImage;
  bool userImageAssigned = false;
  HashSet<Marker> globalMarkers = HashSet<Marker>();

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
                    markers: globalMarkers,
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
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: (){
                  globalController.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: LatLng(
                          widget.beaconData.userLocationData.latitude,
                          widget.beaconData.userLocationData.longitude),
                          zoom: 15)));
                },
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
                          Text("LocateBeacon.label_beacon_id".tr() + widget.beaconData.beaconId, style: const TextStyle(
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
                          Text("LocateBeacon.label_host".tr() + widget.beaconData.createdBy, style: const TextStyle(
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
            )

          ],
        ),
      ),
    );
  }

  Future<bool> backButtonPressed() async{
    widget.setBeaconData(BeaconData.withoutParams());
    Navigator.pop(context);
    return true;
  }

  String beaconExpiryTime(){
    int minuteDifference = DateTime.fromMillisecondsSinceEpoch(widget.beaconData.expiry).difference(DateTime.now()).inMinutes;
    if(minuteDifference > 0){
      return "LocateBeacon.msg_beacon_expire".tr() + "$minuteDifference minutes";
   }else{
      return "LocateBeacon.msg_beacon_expired".tr();
    }
  }

  void buildMarkers() async{
    if(!userImageAssigned){
      userImage = await CreateImageProfile.takePicture(widget.beaconData.createdBy);
      userImageAssigned = true;
    }
    DateTime locationUpdatedTime = DateTime.fromMillisecondsSinceEpoch(widget.beaconData.userLocationData.updatedOn);
    Marker marker = Marker(
      markerId: const MarkerId("PersonLocation"),
      position: LatLng(widget.beaconData.userLocationData.latitude, widget.beaconData.userLocationData.longitude),
      infoWindow: InfoWindow(
          title: widget.beaconData.createdBy,
          snippet: "${locationUpdatedTime.hour}:${locationUpdatedTime.minute}"
      ),
      icon: BitmapDescriptor.fromBytes(userImage),
    );
    globalMarkers = HashSet<Marker>();
    setState(() {
      globalMarkers.add(marker);
    });
  }

  void getUserLocation() async{
    await GetUserLocation.getLocation();
  }

  /// function to animate camera to user's current location
  void animateCameraToUsersLocation({double zoomLevel = 17}) async{
    LocationData locationData = await GetUserLocation.getLocation() as LocationData;
    cameraPosition =  CameraPosition(
        target: LatLng(locationData.latitude ?? 0.0,
            locationData.longitude ?? 0.0),
        zoom: zoomLevel
    );
    globalController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }
}
