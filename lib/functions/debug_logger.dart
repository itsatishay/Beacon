/// [DebugLogger] to print logs
class DebugLogger{

  static const bool allowLogging = false;

  static void log(String msg){
    if(allowLogging){
      print(msg);
    }
  }

}