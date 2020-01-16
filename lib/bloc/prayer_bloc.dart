import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:prayer_bloc/models/AthanTimes.dart';

import 'package:prayer_bloc/repository/prayer_repository.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

class PrayerBloc extends Bloc<PrayerEvent, PrayerState> {
  PrayerRepository repository;

  PrayerBloc({@required this.repository});

  @override
  PrayerState get initialState => InitialPrayerState();

  @override
  Stream<PrayerState> mapEventToState(
    PrayerEvent event,
  ) async* {
    if (event is FetchPrayerEvent) {
      try {
        Timings item = await repository.getItem();
        yield PrayerLoadedState(item: item);
      } catch (e) {
        yield PrayerErrorState(message1: e.toString());
      }
    }
  }
}
