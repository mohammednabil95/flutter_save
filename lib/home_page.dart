import 'dart:async';

import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_save/bloc/prayer_bloc.dart';
import 'package:flutter_save/bloc/prayer_event.dart';
import 'package:flutter_save/bloc/prayer_state.dart';
import 'package:flutter_save/models/AthanTimes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_save/notificationbloc/bloc.dart';
import 'package:flutter_save/notificationbloc/notification_bloc.dart';
import 'package:flutter_save/notificationbloc/notification_state.dart';
import 'package:flutter_save/models/notification1.dart';
import 'package:hijri/umm_alqura_calendar.dart';
import 'package:flutter_save/repository/prayer_repository.dart';
import 'package:flutter_save/repository/my_flutter_app_icons.dart';
import 'package:intl/intl.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  PrayerBloc prayerBloc;
  NotificationBloc notificationBloc;
  ummAlquraCalendar hijriDate = new ummAlquraCalendar.now();
  String dateFormat;
  var now = new DateTime.now();
  int dateDay;

  @override
  void initState() {
    super.initState();
    notificationBloc = BlocProvider.of<NotificationBloc>(context);
    prayerBloc = BlocProvider.of<PrayerBloc>(context);
    prayerBloc.add(FetchPrayerEvent());
    notificationBloc.add(FetchNotificationEvent());
    dateDay = now.day;
    dateFormat = DateFormat('dd/MM/yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Container(
            height: 420.0,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 70.0),
                        child: Card(
                          elevation: 10.0,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    BlocListener<PrayerBloc, PrayerState>(
                                      listener: (context, state) {
                                        if (state is PrayerErrorState) {
                                          Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(state.message1),
                                            ),
                                          );
                                        }
                                      },
                                      child: BlocBuilder<PrayerBloc, PrayerState>(
                                        builder: (context, state) {
                                          if (state is InitialPrayerState) {
                                            return buildLoading();
                                          } else if (state is PrayerLoadedState) {
                                            return buildArticleList(state.item);
                                          } else if (state is PrayerErrorState) {
                                            return buildErrorUi(state.message1);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    BlocListener<NotificationBloc,
                                        NotificationState>(
                                      listener: (context, state) {},
                                      child: BlocBuilder<NotificationBloc,
                                          NotificationState>(
                                        builder: (context, state) {
                                          if (state is InitialNotificationState) {
                                            return buildLoading();
                                          } else if (state is NotificationLoadedState) {
                                            return NotificationIconBuild(state.notification);
                                          } else if (state is NotificationErrorState) {
                                            return buildErrorUi(state.message1);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Card(
                          color: Colors.black,
                          elevation: 12,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context)
                                          .tr('Next prayer'),
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              80),
                                    ),
                                    Padding(padding: EdgeInsets.all(4)),
                                    //Nextprayername(data: data)
                                  ],
                                ),
                                Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: <Widget>[
                                    AnimatedCircularChart(
                                      key: _chartKey,
                                      size: Size(80.0, 60.0),
                                      initialChartData: <CircularStackEntry>[
                                        new CircularStackEntry(
                                          <CircularSegmentEntry>[
//                                            new CircularSegmentEntry(
//                                              100 -
//                                                  getNextPrayer()
//                                                      .percent,
//                                              Color(0xFFd4a554),
//                                              rankKey: 'completed',
//                                            ),
//                                            new CircularSegmentEntry(
//                                              getNextPrayer()
//                                                  .percent,
//                                              Color(0xFF614729),
//                                              rankKey: 'completed',
//                                            ),
                                          ],
                                          rankKey: 'progress',
                                        ),
                                      ],
                                      chartType: CircularChartType.Radial,
                                      percentageValues: true,
                                      duration: Duration(seconds: 2),
                                      edgeStyle: SegmentEdgeStyle.round,
                                      labelStyle: new TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    //Center(child: new CountDownTimer())
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Card(
            color: Colors.black,
            elevation: 20,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocListener<PrayerBloc, PrayerState>(
                listener: (context, state) {
                  if (state is PrayerErrorState) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message1),
                      ),
                    );
                  }
                },
                child: BlocBuilder<PrayerBloc, PrayerState>(
                  builder: (context, state) {
                    if (state is InitialPrayerState) {
                      return buildLoading();
                    } else if (state is PrayerLoadedState) {
                      return buildBottomList(state.item);
                    } else if (state is PrayerErrorState) {
                      return buildErrorUi(state.message1);
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget buildArticleList(Timings item) {
    return new Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Fajr",style: TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: EdgeInsets.only(left: 60.0),
                    ),
                    Text(formatTime(item.fajr),style: TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold)),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                ),
                Row(
                  children: <Widget>[
                    Text("Dhuhr",style: TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: EdgeInsets.only(left: 40.0),
                    ),
                    Text(formatTime(item.dhuhr),style: TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold)),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                ),
                Row(
                  children: <Widget>[
                    Text("Asr",style: TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: EdgeInsets.only(left: 60.0),
                    ),
                    Text(formatTime(item.asr),style: TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold)),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                ),
                Row(
                  children: <Widget>[
                    Text("Maghrib",style: TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                    ),
                    Text(formatTime(item.maghrib),style: TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold)),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                ),
                Row(
                  children: <Widget>[
                    Text("Isha",style: TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: EdgeInsets.only(left: 55.0),
                    ),
                    Text(formatTime(item.isha),style: TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold)),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
              ],
            ),
            //Notification()
          ],
        ),
      ),
    );
  }

  Widget NotificationIconBuild(NotificationModle notification) {
    return Column(
      children: <Widget>[
        notificationIcon("fajr", notification),
        notificationIcon("duhur", notification),
        notificationIcon("asr", notification),
        notificationIcon("magrib", notification),
        notificationIcon("esha", notification),
      ],
    );
  }

  Widget notificationIcon(String notification, NotificationModle notificationModle){
    switch(notification) {
      case "fajr": {
        if(notificationModle.fajr == false)
          return IconButton(
            icon: Icon(Icons.notifications),
            onPressed: (){
              notificationModle.fajr = true;
              notificationBloc.add(SelectNotificationEvent(notificationModle));
            },
          );
        else return IconButton(
          icon: Icon(Icons.notifications_active),
          onPressed: (){
            notificationModle.fajr = false;
            notificationBloc.add(SelectNotificationEvent(notificationModle));
          },
        );
      }
      break;
      case "duhur": {
        if(notificationModle.duhur == false)
          return IconButton(
            icon: Icon(Icons.notifications),
            onPressed: (){
              notificationModle.duhur = true;
              notificationBloc.add(SelectNotificationEvent(notificationModle));
            },
          );
        else return IconButton(
          icon: Icon(Icons.notifications_active),
          onPressed: (){
            notificationModle.duhur = false;
            notificationBloc.add(SelectNotificationEvent(notificationModle));
          },
        );
      }
      break;
      case "asr": {
        if(notificationModle.asr == false)
          return IconButton(
            icon: Icon(Icons.notifications),
            onPressed: (){
              notificationModle.asr = true;
              notificationBloc.add(SelectNotificationEvent(notificationModle));
            },
          );
        else return IconButton(
          icon: Icon(Icons.notifications_active),
          onPressed: (){
            notificationModle.asr = false;
            notificationBloc.add(SelectNotificationEvent(notificationModle));
          },
        );
      }
      break;

      case "magrib": {
        if(notificationModle.magrib == false)
          return IconButton(
            icon: Icon(Icons.notifications),
            onPressed: (){
              notificationModle.magrib = true;
              notificationBloc.add(SelectNotificationEvent(notificationModle));
            },
          );
        else return IconButton(
          icon: Icon(Icons.notifications_active),
          onPressed: (){
            notificationModle.magrib = false;
            notificationBloc.add(SelectNotificationEvent(notificationModle));
          },
        );
      }
      break;

      case "esha": {
        if(notificationModle.esha == false)
          return IconButton(
            icon: Icon(Icons.notifications),
            onPressed: (){
              notificationModle.esha = true;
              notificationBloc.add(SelectNotificationEvent(notificationModle));
            },
          );
        else return IconButton(
          icon: Icon(Icons.notifications_active),
          onPressed: (){
            notificationModle.esha = false;
            notificationBloc.add(SelectNotificationEvent(notificationModle));
          },
        );
      }
      break;

      default: {
        //statements;
      }
      break;
    }
  }

  Widget buildBottomList(Timings item) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).tr("Location:"),
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(''),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).tr("Hijri:"),
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text("${hijriDate.toString()}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12)),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).tr("Gregorian:"),
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                SizedBox(
                  height: 4,
                ),
                Text("$dateFormat",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12)),
              ],
            ),
          ],
        ),
        RaisedButton(
            onPressed: () {
              //refreshLocation
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            color: Color(0xFF614729),
            elevation: 10,
            padding: EdgeInsets.all(0),
            child: Row(children: <Widget>[
              Text(
                AppLocalizations.of(context).tr("Refresh"),
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFFd4a554),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Icon(
                Icons.refresh,
                size: 18,
                color: Color(0xFFd4a554),
              ),
            ])),
      ],
    );
  }

  String formatTime(String time){
    List<String> timeData= to12Hour(time);
    String formattedTime = timeData[0];
    Localizations.localeOf(context).languageCode == "ar"
        ? formattedTime = formattedTime + timeData[2]
        : formattedTime = formattedTime + timeData[1];

    return formattedTime;
  }

  List<String> to12Hour(String time){
    List<String> time12hour = new List<String>();
    String noon = " AM";
    String noonAr = " ص";
    int hour = int.parse(time.substring(0,2));
    if (hour >= 12) {
      hour = hour - 12;
      noon = " PM";
      noonAr = " م";
    }
    if (hour == 0) {
      hour = 12;
    }
    time12hour.add(hour.toString() + time.substring(2,5));
    time12hour.add(noon);
    time12hour.add(noonAr);
    return time12hour;
  }

}
