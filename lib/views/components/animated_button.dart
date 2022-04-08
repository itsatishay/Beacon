import 'package:beacon/hardcoded/hardcoded_colors.dart';
import 'package:flutter/material.dart';

class AnimatedButton extends StatelessWidget {
  const AnimatedButton({
    Key? key,
    required this.buttonTextColor,
    required this.onPressFunction,
    required this.isLoading,
    required this.buttonText,
    required this.buttonColor,
    this.loadingColor = HardcodedColors.white}) : super(key: key);

  final Color buttonColor;
  final String buttonText;
  final bool isLoading;
  final Color buttonTextColor;
  final VoidCallback onPressFunction;
  final Color loadingColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: !isLoading ? const StadiumBorder() : const CircleBorder(),
            primary: buttonColor
        ),
        onPressed: (){
          if(!isLoading){
            onPressFunction();
          }
          },
        child: Padding(
          padding: !isLoading ? const EdgeInsets.fromLTRB(20, 15, 20, 15) : const EdgeInsets.all(15),
          child: isLoading ? CircularProgressIndicator(
            color: loadingColor,
            strokeWidth: 3,
          ) : Text(buttonText, style: TextStyle(
              color: buttonTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w700
          ),),
        ),
      ),
    );
  }

}


