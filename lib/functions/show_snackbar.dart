import 'package:flutter/material.dart';

/// [ShowSnackBar] custom class to show snackBar
class ShowSnackBar{

  static show(BuildContext context, String msg){
    final snackBar = SnackBar(
      content: Text(msg)
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}