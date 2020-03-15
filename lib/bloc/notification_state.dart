import 'package:equatable/equatable.dart';
import 'package:flutter_save/models/AthanTimes.dart';
import 'package:meta/meta.dart';
import 'package:flutter_save/models/notification1.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
}

class InitialNotificationState extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationLoadedState extends NotificationState {

  NotificationModle notification;
  NotificationLoadedState({@required this.notification});

  @override
  // TODO: implement props
  List<Object> get props => [notification];
}

class NotificationSavedState extends NotificationState {

  NotificationModle notification;
  NotificationSavedState({@required this.notification});

  @override
  // TODO: implement props
  List<Object> get props => [notification];
}

class OneNotificationState extends NotificationState{
  Timings timings;
  OneNotificationState({@required this.timings});
  @override
  // TODO: implement props
  List<Object> get props => [timings];

}


class NotificationErrorState extends NotificationState {

  String message1;
  var bib;
  NotificationErrorState({@required this.message1});

  @override
  // TODO: implement props
  List<Object> get props => [message1];
}
