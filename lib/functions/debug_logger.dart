/// [DebugLogger] to print logs
class DebugLogger{

  static const bool allowLogging = true;

  static void log(String msg){
    if(allowLogging){
      print(msg);
    }
  }

}