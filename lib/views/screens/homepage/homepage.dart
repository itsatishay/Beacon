import 'dart:math';
import 'package:beacon/dataClasses/beacon_data.dart';
import 'package:beacon/dataClasses/user_location_data.dart';
import 'package:beacon/functions/calculate_expiry_time.dart';
import 'package:beacon/functions/debug_logger.dart';
import 'package:beacon/functions/get_user_location.dart';
import 'package:beacon/functions/show_snackbar.dart';
import 'package:beacon/functions/typedef.dart';
import 'package:beacon/functions/update_beacon_database.dart';
import 'package:beacon/views/components/choice_card.dart';
import 'package:beacon/views/screens/createdBeacon/created_beacon.dart';
import 'package:beacon/views/screens/enterBeaconId/enter_beacon_id_viewmodel_connector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key, required this.userName, required this.setBeaconData}) : super(key: key);

  final String userName;
  final SetBeaconData setBeaconData;

  @override
  Widget build(BuildContext context) {

    bool createBeaconLoading = false;
    final double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(height: height * 0.15),

              StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                return InkWell(
                  onTap: () async{
                    if(!createBeaconLoading){
                      setState(() => createBeaconLoading = true);
                      CreateBeaconTapResponse result = await createBeacon(context);
                      setState(() => createBeaconLoading = false);
                      if(result.completed){
                        setBeaconData(result.beaconData);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CreatedBeacon(beaconData: result.beaconData)));
                      }
                    }
                  },
                  child: ChoiceCard(
                      isLoading: createBeaconLoading,
                      cardName: "Homepage.label_create_beacon".tr(),
                      imageIconLocation: "assets/images/beacon_icon.png"
                  ),
                );
              }),

              InkWell(
                onTap: (){
                  locateBeacon(context);
                },
                child: ChoiceCard(
                    isLoading: false,
                    cardName: "Homepage.label_locate_beacon".tr(),
                    imageIconLocation: "assets/images/locate_icon.png"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<CreateBeaconTapResponse> createBeacon(BuildContext context) async{
    Random random = Random();
    int randomNumber = random.nextInt(10000000);
    DebugLogger.log("Beacon Id before creating: $randomNumber");
    dynamic currentLocation = await GetUserLocation.getLocation();
    if(currentLocation != null){
      LocationData locationData = currentLocation as LocationData;
      int currentTime = DateTime.now().millisecondsSinceEpoch;

      UserLocationData userLocationData = UserLocationData(
          longitude: locationData.longitude ?? 0.0,
          latitude: locationData.latitude ?? 0.0,
          updatedOn: currentTime);

      int expiryTime = CalculateExpiryTime.expiry(currentTime);
      BeaconData beaconData = BeaconData(
          userLocationData: userLocationData,
          createdOn: currentTime,
          createdBy: userName,
          expiry: expiryTime,
          beaconId: "$randomNumber");

      bool setComplete = await UpdateBeaconDatabase.setBeaconData(beaconData);
      if(!setComplete){
        ShowSnackBar.show(context, "Homepage.error_unable_set_beacon_data".tr());
      }
      CreateBeaconTapResponse createBeaconTapResponse = CreateBeaconTapResponse(beaconData: beaconData, completed: setComplete);
      return createBeaconTapResponse;
    }else{
      ShowSnackBar.show(context, "Homepage.error_fetching_user_location".tr());
      CreateBeaconTapResponse createBeaconTapResponse = CreateBeaconTapResponse(beaconData: BeaconData.withoutParams(), completed: false);
      return createBeaconTapResponse;
    }
  }

  void locateBeacon(BuildContext context){
    showDialog(context: context, builder: (_) => const EnterBeaconIdConnector());
  }
}

class CreateBeaconTapResponse{
  CreateBeaconTapResponse({required this.beaconData, required this.completed});
  bool completed = false;
  BeaconData beaconData = BeaconData.withoutParams();
}
