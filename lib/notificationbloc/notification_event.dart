import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
}
// it's a to get the prayer time just like in prayer_event bloc
class FetchNotificationEvent extends NotificationEvent {  // this is an optional if you don't like it then remove......
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class SelectNotificationEvent extends NotificationEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class UnSelectNotificationEvent extends NotificationEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}
