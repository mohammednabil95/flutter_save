import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  @override
  NotificationState get initialState => InitialNotificationState();

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
