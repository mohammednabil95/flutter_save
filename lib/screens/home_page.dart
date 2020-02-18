import 'dart:async';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_save/bloc/bloc.dart';
import 'package:flutter_save/bloc/notification_event.dart';
import 'package:flutter_save/bloc/prayer_bloc.dart';
import 'package:flutter_save/bloc/prayer_event.dart';
import 'package:flutter_save/bloc/prayer_state.dart';
import 'package:flutter_save/models/AthanTimes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_save/bloc/notification_bloc.dart';
import 'package:flutter_save/bloc/notification_state.dart';
import 'package:flutter_save/models/notification1.dart';
import 'package:flutter_save/repository/timer_repository.dart';
import 'package:flutter_save/services/presentation/my_flutter_app_icons.dart';
import 'package:hijri/umm_alqura_calendar.dart';
import 'package:flutter_save/repository/prayer_repository.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  Datum data;

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
  int test;

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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
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
                                      child:
                                          BlocBuilder<PrayerBloc, PrayerState>(
                                        builder: (context, state) {
                                          if (state is InitialPrayerState) {
                                            return buildLoading();
                                          } else if (state
                                              is PrayerLoadedState) {
                                            return buildArticleList(state.item);
                                          } else if (state
                                              is PrayerErrorState) {
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
                                          if (state
                                              is InitialNotificationState) {
                                            return buildLoading();
                                          } else if (state
                                              is NotificationLoadedState) {
                                            return NotificationIconBuild(
                                                state.notification);
                                          } else if (state
                                              is NotificationErrorState) {
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
                      Column(
                        children: <Widget>[
                          BlocListener<TimerBloc, TimerState>(
                            listener: (context, state) {},
                            child: BlocBuilder<TimerBloc, TimerState>(
                              builder: (context, state) {
//                                final String minutesStr =
//                                    ((state.duration / 60) % 60)
//                                        .floor()
//                                        .toString()
//                                        .padLeft(2, '0');
                                String nextPrayerMinutes =
                                (getNextPrayer(widget.data.timings).duration.inMinutes % 60).toString();
                                String nextPrayerHours =
                                getNextPrayer(widget.data.timings).duration.inHours.toString();
                                String nextPrayerSeconds =
                                (getNextPrayer(widget.data.timings).duration.inSeconds % 60).toString();
//                                final String secondsStr = (state.duration % 60)
//                                    .floor()
//                                    .toString()
//                                    .padLeft(2, '0');
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  child: Card(
                                    color: Colors.black,
                                    elevation: 12,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 30),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                AppLocalizations.of(context)
                                                    .tr('Next prayer'),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            80),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(4)),
                                              //Nextprayername(data: data)
                                            ],
                                          ),
                                          Stack(
                                            alignment:
                                                AlignmentDirectional.center,
                                            children: <Widget>[
                                              AnimatedCircularChart(
                                                key: _chartKey,
                                                size: Size(80.0, 60.0),
                                                initialChartData: <
                                                    CircularStackEntry>[
                                                  new CircularStackEntry(
                                                    <CircularSegmentEntry>[
//                                                      new CircularSegmentEntry(
//                                                        100 -
//                                                            getNextPrayer(snapshot
//                                                                .data.timings)
//                                                                .percent,
//                                                        Color(0xFFd4a554),
//                                                        rankKey: 'completed',
//                                                      ),
//                                                      new CircularSegmentEntry(
//                                                        getNextPrayer(
//                                                            snapshot.data.timings)
//                                                            .percent,
//                                                        Color(0xFF614729),
//                                                        rankKey: 'completed',
//                                                      ),
                                                    ],
                                                    rankKey: 'progress',
                                                  ),
                                                ],
                                                chartType:
                                                    CircularChartType.Radial,
                                                percentageValues: true,
                                                duration: Duration(seconds: 2),
                                                edgeStyle:
                                                    SegmentEdgeStyle.round,
                                                labelStyle: new TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                             // Center(child: new CountDownTimer(data: data))
                                              Text('$nextPrayerHours:$nextPrayerMinutes:$nextPrayerSeconds',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
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
    return Column(
      children: <Widget>[
        singleTimeCard(AppLocalizations.of(context).tr('Fajr'),
            formatTime(item.fajr), MyFlutterApp.sunrise, Color(0xFFe5bf07)),
        singleTimeCard(AppLocalizations.of(context).tr('Dhuhr'),
            formatTime(item.dhuhr), MyFlutterApp.sun, Color(0xFFe5bf07)),
        singleTimeCard(AppLocalizations.of(context).tr('Asr'),
            formatTime(item.asr), MyFlutterApp.sun_inv, Color(0xFFe5bf07)),
        singleTimeCard(AppLocalizations.of(context).tr('Maghrib'),
            formatTime(item.maghrib), MyFlutterApp.fog_sun, Color(0xFFe5bf07)),
        singleTimeCard(AppLocalizations.of(context).tr('Isha'),
            formatTime(item.isha), MyFlutterApp.fog_moon, Color(0xFF86a4c3)),
      ],
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

  Widget notificationIcon(
      String notification, NotificationModle notificationModle) {
    switch (notification) {
      case "fajr":
        {
          if (notificationModle.fajr == false)
            return IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                notificationModle.fajr = true;
                setState(() {
                  notificationBloc
                      .add(SelectNotificationEvent(notificationModle));
                });
              },
            );
          else
            return IconButton(
              icon: Icon(Icons.notifications_active),
              onPressed: () {
                notificationModle.fajr = false;
                setState(() {
                  notificationBloc
                      .add(SelectNotificationEvent(notificationModle));
                });
              },
            );
        }
        break;
      case "duhur":
        {
          if (notificationModle.duhur == false)
            return IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                notificationModle.duhur = true;
                setState(() {
                  notificationBloc
                      .add(SelectNotificationEvent(notificationModle));
                });
              },
            );
          else
            return IconButton(
              icon: Icon(Icons.notifications_active),
              onPressed: () {
                notificationModle.duhur = false;
                setState(() {
                  notificationBloc
                      .add(SelectNotificationEvent(notificationModle));
                });
              },
            );
        }
        break;
      case "asr":
        {
          if (notificationModle.asr == false)
            return IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                notificationModle.asr = true;
                setState(() {
                  notificationBloc
                      .add(SelectNotificationEvent(notificationModle));
                });
              },
            );
          else
            return IconButton(
              icon: Icon(Icons.notifications_active),
              onPressed: () {
                notificationModle.asr = false;
                setState(() {
                  notificationBloc
                      .add(SelectNotificationEvent(notificationModle));
                });
              },
            );
        }
        break;

      case "magrib":
        {
          if (notificationModle.magrib == false)
            return IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                notificationModle.magrib = true;
                setState(() {
                  notificationBloc
                      .add(SelectNotificationEvent(notificationModle));
                });
              },
            );
          else
            return IconButton(
              icon: Icon(Icons.notifications_active),
              onPressed: () {
                notificationModle.magrib = false;
                setState(() {
                  notificationBloc
                      .add(SelectNotificationEvent(notificationModle));
                });
              },
            );
        }
        break;

      case "esha":
        {
          if (notificationModle.esha == false)
            return IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                notificationModle.esha = true;
                setState(() {
                  notificationBloc
                      .add(SelectNotificationEvent(notificationModle));
                });
              },
            );
          else
            return IconButton(
              icon: Icon(Icons.notifications_active),
              onPressed: () {
                notificationModle.esha = false;
                setState(() {
                  notificationBloc
                      .add(SelectNotificationEvent(notificationModle));
                });
              },
            );
        }
        break;

      default:
        {
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
//                Text(
//                  trimToCityOnly(
//                      snapshot.data.meta.timezone),
//                  style: TextStyle(
//                      fontSize: 12, color: Colors.white),
//                ),
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
                    style: TextStyle(color: Colors.white, fontSize: 12)),
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
                    style: TextStyle(color: Colors.white, fontSize: 12)),
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

  String formatTime(String time) {
    List<String> timeData = to12Hour(time);
    String formattedTime = timeData[0];
    Localizations.localeOf(context).languageCode == "ar"
        ? formattedTime = formattedTime + timeData[2]
        : formattedTime = formattedTime + timeData[1];

    return formattedTime;
  }

  List<String> to12Hour(String time) {
    List<String> time12hour = new List<String>();
    String noon = " AM";
    String noonAr = " ص";
    int hour = int.parse(time.substring(0, 2));
    if (hour >= 12) {
      hour = hour - 12;
      noon = " PM";
      noonAr = " م";
    }
    if (hour == 0) {
      hour = 12;
    }
    time12hour.add(hour.toString() + time.substring(2, 5));
    time12hour.add(noon);
    time12hour.add(noonAr);
    return time12hour;
  }
}

Widget singleTimeCard(
    String timeName, String time, IconData icon, Color color) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                icon,
                color: color,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                timeName,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            time,
            style: TextStyle(fontSize: 20, color: Colors.black54),
          ),
        ]),
  );
}

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({
    Key key,
    @required this.data,
  }) : super(key: key);

  final Datum data;

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  DateTime date;
  var now = new DateTime.now();
  int dateDay;
  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateDay = now.day;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    String nextPrayerHours =
        getNextPrayer(widget.data.timings).duration.inHours.toString();
    String nextPrayerSeconds =
        (getNextPrayer(widget.data.timings).duration.inSeconds % 60).toString();
    String nextPrayerMinutes =
        (getNextPrayer(widget.data.timings).duration.inMinutes % 60).toString();

    return Text(
      "$nextPrayerHours:$nextPrayerMinutes:$nextPrayerSeconds",
      style: TextStyle(
        color: Colors.white,
        fontSize: 14.0,
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}