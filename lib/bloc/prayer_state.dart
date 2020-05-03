
import 'package:flutter_save/models/AthanTimes.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class PrayerState extends Equatable {
  const PrayerState();
}

class InitialPrayerState extends PrayerState {
  @override
  List<Object> get props => [];
}

class PrayerLoadedState extends PrayerState {
  Timings item;
  NextPrayer nextPrayer;
  PrayerLoadedState({@required this.item, @required this.nextPrayer});
  @override
  List<Object> get props => [item];
}

class PrayerErrorState extends PrayerState {
  String message1;
  var bib;
  PrayerErrorState({@required this.message1});
  @override
  List<Object> get props => [message1];
}
