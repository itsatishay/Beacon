import 'package:beacon/dataClasses/beacon_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// [CheckBeaconId] to check if the beacon id provided is exists or not
class CheckBeaconId{

  static Future<dynamic> check(String id) async{
    try{
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("beacons").doc(id).get();
      if(!documentSnapshot.exists){
        return null;
      }else{
        Map<String, dynamic> jsonData = documentSnapshot.data() as Map<String, dynamic>;
        BeaconData beaconData = BeaconData.fromJson(jsonData);
        return beaconData;
      }
    }catch(e){
      return null;
    }
  }

}