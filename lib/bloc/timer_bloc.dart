import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_save/models/ticker.dart';


class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  final int _duration = 10;

  StreamSubscription<int> _tickerSubscription;

  TimerBloc({@required Ticker ticker})
      : assert(ticker != null),
        _ticker = ticker;

  @override
  TimerState get initialState => Running(_duration);

  @override
  void onTransition(Transition<TimerEvent, TimerState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  @override
  Stream<TimerState> mapEventToState(
      TimerEvent event,
      ) async* {
    if (event is Start) {

      yield* _mapStartToState(event);
    }  else if (event is Tick) {
      yield* _mapTickToState(event);
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  Stream<TimerState> _mapStartToState(Start start) async* {
    yield Running(_duration);
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: start.duration)
        .listen((duration) => add(Tick(duration: duration)));
  }


  Stream<TimerState> _mapTickToState(Tick tick) async* {
    if(tick.duration > 0 ){
      yield Running(tick.duration);
    }else{
      yield Running(tick.duration);
      _tickerSubscription?.cancel();
      _tickerSubscription = _ticker.tick(ticks: _duration).listen((duration)
      => add(Tick(duration: duration)));
    }
  }

}