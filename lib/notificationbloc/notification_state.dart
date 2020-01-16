import 'package:equatable/equatable.dart';
import 'package:prayer_bloc/models/AthanTimes.dart';
import 'package:meta/meta.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
}

class InitialNotificationState extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationLoadedState extends NotificationState {

  Timings item;

  NotificationLoadedState({@required this.item});

  @override
  // TODO: implement props
  List<Object> get props => [item];
}
