import 'package:beacon/dataClasses/beacon_data.dart';
import 'package:beacon/functions/debug_logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// [UpdateBeaconDatabase] to set and update beacon json in Firestore
class UpdateBeaconDatabase{

  static Future<bool> setBeaconData(BeaconData beaconData) async{
    try{
      await FirebaseFirestore.instance.collection("beacons").doc(beaconData.beaconId).set(beaconData.toJson());
      return true;
    }catch(e){
      DebugLogger.log("Error caught while setting beacon data: ${e.toString()}");
      return false;
    }
  }

  static Future<bool> updateBeaconData(BeaconData beaconData) async{
    try{
      await FirebaseFirestore.instance.collection("beacons").doc(beaconData.beaconId).update(beaconData.toJson());
      return true;
    }catch(e){
      DebugLogger.log("Error caught while updating beacon data: ${e.toString()}");
      return false;
    }
  }

}