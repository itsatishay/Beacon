import 'dart:ui';
import 'package:beacon/dataClasses/beacon_data.dart';
import 'package:beacon/functions/check_beacon_id.dart';
import 'package:beacon/functions/typedef.dart';
import 'package:beacon/hardcoded/hardcoded_colors.dart';
import 'package:beacon/views/components/animated_button.dart';
import 'package:beacon/views/screens/locateBeacon/locate_beacon_viewmodel_connector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EnterBeaconId extends StatefulWidget {
  const EnterBeaconId({Key? key, required this.setBeaconData}) : super(key: key);

  final SetBeaconData setBeaconData;

  @override
  State<EnterBeaconId> createState() => _EnterBeaconIdState();
}

class _EnterBeaconIdState extends State<EnterBeaconId> {

  TextEditingController beaconId = TextEditingController();
  bool isLoading = false;
  String error = "";

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: HardcodedColors.white,
              borderRadius: BorderRadius.circular(10)
          ),
          width: width * 0.85,
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: HardcodedColors.red,
                          shape: BoxShape.circle
                      ),
                      child: Image.asset("assets/images/cross_icon.png"),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20),

              TextField(
                controller: beaconId,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'EnterBeaconId.msg_enter_beacon_id'.tr(),
                ),
              ),

              const SizedBox(height: 30),

              if(error.isNotEmpty)Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(error,style: const TextStyle(
                    color: HardcodedColors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),),
                ],
              ),

              if(error.isNotEmpty)const SizedBox(height: 15),

              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    AnimatedButton(
                        buttonTextColor: HardcodedColors.white,
                        onPressFunction: submitPressed,
                        isLoading: isLoading,
                        buttonText: "EnterBeaconId.btn_submit".tr(),
                        buttonColor: HardcodedColors.black)

                  ]
              )

            ],
          ),
        ),
      ),
    );
  }

  void submitPressed() async{
    if(checkForm()){
      setState(() {
        isLoading = true;
      });
      dynamic checkResult = await CheckBeaconId.check(beaconId.text);
      setState(() {
        isLoading = false;
      });
      if(checkResult == null){
        changeError("EnterBeaconId.error_incorrect_id".tr());
      }else{
        BeaconData data = checkResult as BeaconData;
        widget.setBeaconData(data);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LocateBeaconConnector()));
      }
    }
  }

  bool checkForm(){
    if(beaconId.text.isEmpty){
      changeError("EnterBeaconId.error_enter_beacon_id".tr());
      return false;
    }
    return true;
  }

  void changeError(String error){
    setState(() {
      this.error = error;
    });
    Future.delayed(const Duration(seconds: 5), (){
      setState(() {
        this.error = "";
      });
    });
  }
}
