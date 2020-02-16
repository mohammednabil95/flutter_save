import 'package:equatable/equatable.dart';
import 'package:flutter_save/models/notification1.dart';

abstract class NotificationEvent extends Equatable {

}
// it's a to get the prayer time just like in prayer_event bloc
class FetchNotificationEvent extends NotificationEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class SelectNotificationEvent extends NotificationEvent {

  NotificationModle notificationModle;

  SelectNotificationEvent(this.notificationModle);

  @override
  // TODO: implement props
  List<Object> get props => [notificationModle];

}
