import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter_save/models/AthanTimes.dart';

import 'package:flutter_save/repository/prayer_repository.dart';
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
    if (event is FetchPrayerEvent ) {
      try {
        Timings item = await repository.getItem();
        NextPrayer nextPrayer = repository.getNextPrayer(item);
        yield PrayerLoadedState(item: item, nextPrayer: nextPrayer);
      } catch (e) {
        yield PrayerErrorState(message1: e.toString());
      }
    }else if(event is FetchPrayerMethodEvent){
      try {
        Timings item = await repository.getItem(method: event.method);
        NextPrayer nextPrayer = repository.getNextPrayer(item);
        //yield InitialPrayerState();
        yield PrayerLoadedState(item: item, nextPrayer: nextPrayer);
      } catch (e) {
        yield PrayerErrorState(message1: e.toString());
      }
    }else if(event is RefreshPrayerEvent){
      try {
        Timings item = await repository.getItem();
        NextPrayer nextPrayer = repository.getNextPrayer(item);
        yield InitialPrayerState();
        yield PrayerLoadedState(item: item, nextPrayer: nextPrayer);
      } catch (e) {
        yield PrayerErrorState(message1: e.toString());
      }
    }
  }
}
