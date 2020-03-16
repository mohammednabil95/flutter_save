import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_save/models/Options.dart';
import 'package:flutter_save/repository/options_repository.dart';
import 'package:flutter_save/repository/prayer_repository.dart';
import './bloc.dart';

class OptionsBloc extends Bloc<OptionsEvent, OptionsState> {

  OptionsRepository optionsRepository;

  OptionsBloc(this.optionsRepository);

  PrayerRepository prayerRepository;

  //PrayerBloc prayerBloc = new PrayerBloc(repository: prayerRepository);
  StreamSubscription prayerSubscription;

  FetchPrayerEvent fetchPrayerEvent = new FetchPrayerEvent();


  @override
  OptionsState get initialState => InitialOptionsState();


  @override
  Stream<OptionsState> mapEventToState(
    OptionsEvent event,
  ) async* {
    if (event is FetchOptionsEvent) {
        Options options = await optionsRepository.getOptions();
        yield OptionsLoadedState(options: options);
    } else if(event is SaveOptionsEvent ){
        await optionsRepository.saveOptions(event.options);
        //prayerBloc.add(fetchPrayerEvent);
        }
    }

}
