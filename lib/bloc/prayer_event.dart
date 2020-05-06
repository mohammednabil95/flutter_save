import 'package:equatable/equatable.dart';
import 'package:flutter_save/models/AthanTimes.dart';

abstract class PrayerEvent extends Equatable {}

class FetchPrayerEvent extends PrayerEvent {
  @override
  List<Object> get props => null;
}

class RefreshPrayerEvent extends PrayerEvent {
  Timings items;
  RefreshPrayerEvent(this.items);
  @override
  List<Object> get props => [items];
}

class FetchPrayerMethodEvent extends PrayerEvent {
  int method;
  FetchPrayerMethodEvent({this.method});
  @override
  List<Object> get props => [method];
}


