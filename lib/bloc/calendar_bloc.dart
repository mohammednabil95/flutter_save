import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_save/models/AthanTimes.dart';
import 'package:flutter_save/repository/calendar_repository.dart';
import 'package:flutter_save/models/AthanTimes.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {

  CalendarRepositoryImpl calendarRepositoryImpl;

  CalendarBloc({@required this.calendarRepositoryImpl});

  @override
  CalendarState get initialState => InitialCalendarState();

  @override
  Stream<CalendarState> mapEventToState(
    CalendarEvent event,
      ) async* {
    if (event is GetCalendarEvent ) {
      try {
        Timings item = await calendarRepositoryImpl.getItem(event.dateTime);
        yield CalendarLoadedState(item: item);
      } catch (e) {
        yield CalendarErrorState(message1: e.toString());
      }
    }else if (event is OpenCalendarEvent ){
      DateTime today = DateTime.now();
      Timings item = await calendarRepositoryImpl.getItem(today);
      yield CalendarLoadedState(item: item);
    }
  }
}
