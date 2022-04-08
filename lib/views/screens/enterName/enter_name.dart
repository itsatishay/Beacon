import 'package:beacon/functions/show_snackbar.dart';
import 'package:beacon/functions/typedef.dart';
import 'package:beacon/hardcoded/hardcoded_colors.dart';
import 'package:beacon/hardcoded/hardcoded_strings.dart';
import 'package:beacon/views/screens/homepage/homepage_viewmodel_connector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnterName extends StatefulWidget {
  const EnterName({Key? key, required this.setUserName}) : super(key: key);

  final SetUserName setUserName;

  @override
  State<EnterName> createState() => _EnterNameState();
}

class _EnterNameState extends State<EnterName> {

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(height: height * 0.4),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width * 0.75,
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'EnterName.msg_enter_name'.tr(),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: submitPressed,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: HardcodedColors.black,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text("EnterName.btn_submit".tr(), style: const TextStyle(
                          color: HardcodedColors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20
                      ),),
                    ),
                  )
                ]
              )

            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitPressed() async{
    if(checkForm()){
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString(HardcodedStrings.userNameLocalSaved, nameController.text);
      widget.setUserName(nameController.text);
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomepageConnector()));
    }
  }

  bool checkForm(){
    if(nameController.text.isEmpty){
      ShowSnackBar.show(context, "EnterName.error_enter_name".tr());
      return false;
    }
    if(nameController.text.length < 3){
      ShowSnackBar.show(context, "EnterName.error_enter_name".tr());
      return false;
    }
    return true;
  }

}
