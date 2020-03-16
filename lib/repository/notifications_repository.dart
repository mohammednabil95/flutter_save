import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_save/models/AthanTimes.dart';
import 'package:flutter_save/models/notification1.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NotificationsRepository {
  Future<NotificationModle> getNotifications();
  Future<void> saveNotifications(NotificationModle notification);
  Future<void> getNotify(Timings timings);

}

class NotificationsRepositoryImp implements NotificationsRepository {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  Future<NotificationModle> getNotifications() async {
    NotificationModle notification=NotificationModle(false,false,false,false,false);

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

  @override
  Future<void> getNotify(Timings timings) async{
    List<String> arr = timings.fajr.split(':');
    int aa = int.parse(arr[0]);
    //int bb = int.parse(arr[1]);
    print(aa);
    var time = new Time(aa, 40, 0);
    var android = new AndroidNotificationDetails(
      'Channel Id', 'Channel Name', 'Channel Des',);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    flutterLocalNotificationsPlugin.showDailyAtTime(0, 'show daily title',
        'Daily notification shown at approximately', time, platform);
  }
}