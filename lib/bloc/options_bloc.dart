import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:prayer_bloc/models/Options.dart';
import 'package:prayer_bloc/repository/options_repository.dart';
import './bloc.dart';

class OptionsBloc extends Bloc<OptionsEvent, OptionsState> {

  OptionsRepository optionsRepository;


  OptionsBloc(this.optionsRepository);

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
    }

  }
}
