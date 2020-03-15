import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_save/bloc/notification_event.dart';
import 'package:flutter_save/bloc/notification_state.dart';
import 'package:flutter_save/models/AthanTimes.dart';
import 'package:flutter_save/models/notification1.dart';
import 'package:flutter_save/repository/notifications_repository.dart';
import 'package:meta/meta.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationsRepositoryImp notificationsRepository;

  NotificationBloc({@required this.notificationsRepository});

  @override
  NotificationState get initialState => InitialNotificationState();

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event,) async* {
    if (event is FetchNotificationEvent) {
      try {
        NotificationModle notification = await notificationsRepository.getNotifications();
        yield NotificationLoadedState(notification: notification);
      }
      catch (e) {
        yield NotificationErrorState(message1: e.toString());
      }
    }
    else if (event is SelectNotificationEvent) {
      try {
        await notificationsRepository.saveNotifications(event.notificationModle);
        NotificationModle notification = await notificationsRepository.getNotifications();
        yield NotificationLoadedState(notification: notification);
        //yield NotificationSavedState(notification: event.notificationModle);
      }
      catch (e){
        yield NotificationErrorState(message1: e.toString());
      }
    }
    else{
      yield InitialNotificationState();
    }
  }
}