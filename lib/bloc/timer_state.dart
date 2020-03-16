import 'package:equatable/equatable.dart';

abstract class TimerState extends Equatable {
  final int duration;

  const TimerState(this.duration);

  @override
  List<Object> get props => [duration];
}

class Running extends TimerState {
  const Running(int duration) : super(duration);

  @override
  String toString() => 'Running { duration: $duration}';
}

class NextP extends TimerState {
  const NextP(int duration) : super(duration);

  @override
  String toString() => 'Running { duration: $duration}';
}

