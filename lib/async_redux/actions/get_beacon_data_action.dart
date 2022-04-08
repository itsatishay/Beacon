import 'dart:async';
import 'package:async_redux/async_redux.dart';
import 'package:beacon/async_redux/actions/set_beacon_data_action.dart';
import 'package:beacon/async_redux/app_state.dart';
import 'package:beacon/dataClasses/beacon_data.dart';
import 'package:beacon/functions/debug_logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

///[GetBeaconDataAction] To get beacon data from database
class GetBeaconDataAction extends ReduxAction<AppState> {
  GetBeaconDataAction({required this.id});

  final String id;

  @override
  Future<AppState> reduce() async{
    DebugLogger.log("Firestore beacon id before passing: $id for getting beacon data");
    DocumentReference reference = FirebaseFirestore.instance.collection("beacons").doc(id);
    reference.get().then((value){
      fetchData(value);
    });
    late StreamSubscription<DocumentSnapshot> streamSub;
    streamSub = reference.snapshots().listen((event) {
      int minuteDifference = DateTime.fromMillisecondsSinceEpoch(state.beaconData.expiry).difference(DateTime.now()).inMinutes;
      if(state.beaconData.beaconId.isEmpty || id != state.beaconData.beaconId || minuteDifference <= 0){
        streamSub.pause();
        streamSub.cancel();
      }else{
        fetchData(event);
      }
    });
    return state.copy();
  }

  void fetchData(DocumentSnapshot event){
    try{
      if(event.data() != null){
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;
        DebugLogger.log("beacon updated data received: $data");
        BeaconData beaconData = BeaconData.fromJson(data);
        dispatch(SetBeaconDataAction(beaconData: beaconData));
      }
    }catch(e){
      DebugLogger.log("Caught error while fetching beacon data" + e.toString());
    }
  }
}

