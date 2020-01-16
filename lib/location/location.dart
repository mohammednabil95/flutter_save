import 'package:geolocator/geolocator.dart';

class DeviceLocation{

  String latitude;
  String logitude;

  void getLocation() async{

    Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    this.latitude = position.latitude.toString();
    this.logitude = position.longitude.toString();
  }

  Future<void> getFutureLocation() async{
    Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    this.latitude = position.latitude.toString();
    this.logitude = position.longitude.toString();
  }
}