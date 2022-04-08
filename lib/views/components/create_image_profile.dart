import 'dart:typed_data';
import 'package:beacon/hardcoded/hardcoded_colors.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

///[CreateImageProfile] create image for user profile in Uint8List
class CreateImageProfile{
  static Future<Uint8List> takePicture(String userName) async {
    final controller = ScreenshotController();
    final bytes = await controller.captureFromWidget(
        Material(
          color: HardcodedColors.transparent,
          child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: HardcodedColors.purple,
              shape: BoxShape.circle
          ),
          child: Text(userName[0].toUpperCase(),style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: HardcodedColors.white
          ),),
        ),)
    );
    return bytes;
  }

}