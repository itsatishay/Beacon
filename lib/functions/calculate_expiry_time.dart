import 'package:beacon/hardcoded/hardcoded_strings.dart';

/// [CalculateExpiryTime] to calculate expiry time for a beacon
class CalculateExpiryTime{

  static int expiry(int currentTime){
    DateTime currTime = DateTime.fromMillisecondsSinceEpoch(currentTime);
    int expiryTime = currTime.add(const Duration(minutes: HardcodedStrings.expiryLimitInMinutes)).millisecondsSinceEpoch;
    return expiryTime;
  }

}