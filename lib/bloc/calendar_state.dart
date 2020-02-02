import 'package:equatable/equatable.dart';
import 'package:flutter_save/models/AthanTimes.dart';
import 'package:meta/meta.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();
}

class InitialCalendarState extends CalendarState {
  @override
  List<Object> get props => [];
}

class CalendarLoadedState extends CalendarState {

  Timings item;

  CalendarLoadedState({@required this.item});

  @override
  // TODO: implement props
  List<Object> get props => [item];
}

class CalendarErrorState extends CalendarState {

  String message1;
  var bib;
  CalendarErrorState({@required this.message1});

  @override
  // TODO: implement props
  List<Object> get props => [message1];
}
