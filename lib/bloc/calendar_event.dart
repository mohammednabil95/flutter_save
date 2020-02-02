import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();
}


class GetCalendarEvent extends CalendarEvent {

  DateTime dateTime;

  GetCalendarEvent(this.dateTime);

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class OpenCalendarEvent extends CalendarEvent {

  OpenCalendarEvent();

  @override
  // TODO: implement props
  List<Object> get props => null;
}