import 'package:equatable/equatable.dart';

abstract class PrayerEvent extends Equatable {}

class FetchPrayerEvent extends PrayerEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

//class FetchPrayerEventWithMethod extends PrayerEvent {
//
//  final int method;
//  FetchPrayerEventWithMethod(this.method);
//  @override
//  // TODO: implement props
//  List<Object> get props => null;
//}
