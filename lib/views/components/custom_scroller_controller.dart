import 'package:flutter/material.dart';

///[CustomScrollController] To avoid showing blue bars when scrolling
class CustomScrollController extends MaterialScrollBehavior {

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}