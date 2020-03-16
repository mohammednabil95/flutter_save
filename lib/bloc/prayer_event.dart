import 'package:equatable/equatable.dart';

abstract class PrayerEvent extends Equatable {}

class FetchPrayerEvent extends PrayerEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class FetchPrayerMethodEvent extends PrayerEvent {

  int method;


  FetchPrayerMethodEvent({this.method});

  @override
  // TODO: implement props
  List<Object> get props => [method];
}


