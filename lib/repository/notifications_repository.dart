
import 'package:flutter_save/models/notification1.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NotificationsRepository {
  Future<NotificationModle> getNotifications();
  Future<void> saveNotifications(NotificationModle notification);
}

class NotificationsRepositoryImp implements NotificationsRepository {

  NotificationModle notification;

  @override
  Future<NotificationModle> getNotifications() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    notification.fajr = await prefs.getBool('n_fajr') ?? false;
    notification.duhur = await prefs.getBool('n_duhur') ?? false;
    notification.asr = await prefs.getBool('n_asr') ?? false;
    notification.magrib = await prefs.getBool('n_magrib') ?? false;
    notification.esha = await prefs.getBool('n_esha') ?? false;

    return notification;
  }
  @override
  Future<void> saveNotifications(NotificationModle notification) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('n_fajr', notification.fajr);
    await prefs.setBool('n_duhur', notification.duhur);
    await prefs.setBool('n_asr', notification.asr);
    await prefs.setBool('n_magrib', notification.magrib);
    await prefs.setBool('n_esha', notification.esha);
  }
}