import 'package:beacon/hardcoded/hardcoded_colors.dart';
import 'package:flutter/material.dart';

class ChoiceCard extends StatelessWidget {
  ChoiceCard({Key? key,
    required this.cardName,
    required this.imageIconLocation,
    required this.isLoading}) : super(key: key);

  final String imageIconLocation;
  final String cardName;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(25),
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: HardcodedColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: HardcodedColors.black,
                width: 2
              )
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLoading ? SizedBox(
                      height: height * 0.15,
                      child: const CircularProgressIndicator(
                        color: HardcodedColors.black,
                        strokeWidth: 3
                      ),
                    ) : Image.asset(imageIconLocation, height: height * 0.15),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(cardName, style: TextStyle(
                        color: HardcodedColors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: width * 0.05
                    ),),
                  ],
                )

              ],
            ),
          ),
        ),
      ],
    );
  }
}
