import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
import 'package:flutter_save/services/presentation/my_flutter_app_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/umm_alqura_calendar.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

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
  int test;
  String minutesStr, secondsStr, hoursStr;
  TimerBloc timerBloc;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  String _currentAddress;
  var location = Location();
  LocationData _locationData;

  Future openLocationSetting() async {
    if(!await location.serviceEnabled()){
      location.requestService();
    }
  }

  Future getCurrentLocation() async{
    _locationData=await location.getLocation();
    _getAddressFromLatLng();
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(_locationData.latitude, _locationData.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress = place.locality;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    prayerBloc = BlocProvider.of<PrayerBloc>(context);
    prayerBloc.add(FetchPrayerEvent());
    notificationBloc = BlocProvider.of<NotificationBloc>(context);
    notificationBloc.add(FetchNotificationEvent());
    dateDay = now.day;
    dateFormat = DateFormat('dd/MM/yyyy').format(now);
    super.initState();
    openLocationSetting();
    getCurrentLocation();
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
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 70.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 10.0,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50.0, bottom: 10, left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    child: BlocListener<PrayerBloc,PrayerState>(
                                      listener: (context,state){},
                                      child: BlocBuilder<PrayerBloc, PrayerState>(
                                        builder: (context, state) {
                                          if (state is InitialPrayerState) {
                                            return buildLoading();
                                          } else if (state is PrayerLoadedState) {
                                            timerBloc = BlocProvider.of<TimerBloc>(context);
                                            timerBloc.add(Start(duration: state.nextPrayer.duration.inSeconds));
                                            prayerBloc.add(FetchPrayerMethodEvent());
                                            return buildArticleList(state.item);
                                          }else if (state is PrayerErrorState) {
                                            return buildErrorUi(state.message1);
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                BlocBuilder<NotificationBloc, NotificationState>(
                                  builder: (context, state) {
                                    if (state is InitialNotificationState) {
                                      return buildLoading();
                                    } else if (state is NotificationLoadedState) {
                                      return notificationIconBuild(state.notification);
                                    } else if (state is NotificationErrorState) {
                                      return buildErrorUi(state.message1);
                                    } else if (state is NotificationSavedState) {
                                      return notificationIconBuild(state.notification);
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      BlocBuilder<PrayerBloc, PrayerState>(
                          builder: (context, state) {
                            if (state is PrayerLoadedState) {
                              return buildProgress(state.nextPrayer);
                            }
                            else {
                              return Container();
                            }
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            color: Colors.black,
            elevation: 20,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Row(
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
                    if (_currentAddress != null) Text(_currentAddress,style: TextStyle(color: Colors.white,fontSize: 12.0),),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
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
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding buildProgress(NextPrayer nextPrayer) {
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
                        fontSize: MediaQuery.of(context).size.height / 80),
                  ),
                  Padding(
                      padding: EdgeInsets.all(4)),
                  Text(
                    AppLocalizations.of(context).tr(nextPrayer.prayerName),
                    style: TextStyle(color: Colors.white, fontSize: 20),),
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
                          new CircularSegmentEntry(
                            100 - nextPrayer.percent,
                            Color(0xFFd4a554),
                            rankKey: 'completed',
                          ),
                          new CircularSegmentEntry(
                            nextPrayer.percent,
                            Color(0xFF614729),
                            rankKey: 'completed',
                          ),
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

                  BlocBuilder<TimerBloc, TimerState> (
                    builder: (context,state) {
                      hoursStr = ((state.duration / 60 / 60) % 12)
                          .floor()
                          .toString();
                      //.padLeft(2,'0');
                      minutesStr = ((state.duration / 60) % 60)
                          .floor()
                          .toString()
                          .padLeft(2,'0');
                      secondsStr = (state.duration % 60)
                          .floor()
                          .toString()
                          .padLeft(2,'0');
                      return Center(
                        child: Text(
                          '$hoursStr:$minutesStr:$secondsStr',style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),// Center(child: new CountDownTimer(data: data))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: PlatformCircularProgressIndicator(),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
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

  Widget notificationIconBuild(NotificationModel notification) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
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
      String notification, NotificationModel notificationModel) {
    switch (notification) {
      case "fajr":
        {
          if (notificationModel.fajr == false)
            return PlatformIconButton(
              iosIcon: Icon(
                CupertinoIcons.bell,
              ),
              androidIcon: Icon(Icons.notifications),
              onPressed: () {
                notificationModel.fajr = true;
                notificationBloc.add(SelectNotificationEvent(notificationModel));
              },
            );
          else
            return PlatformIconButton(
              iosIcon: Icon(
                CupertinoIcons.bell_solid,
              ),
              androidIcon: Icon(Icons.notifications_active),
              onPressed: () {
                notificationModel.fajr = false;
                notificationBloc.add(SelectNotificationEvent(notificationModel));

              },
            );
        }
        break;
      case "duhur":
        {
          if (notificationModel.duhur == false)
            return PlatformIconButton(
              iosIcon: Icon(
                CupertinoIcons.bell,
              ),
              androidIcon: Icon(Icons.notifications),
              onPressed: () {
                notificationModel.duhur = true;
                notificationBloc.add(SelectNotificationEvent(notificationModel));
              },
            );
          else
            return PlatformIconButton(
              iosIcon: Icon(
                CupertinoIcons.bell_solid,
              ),
              androidIcon: Icon(Icons.notifications_active),
              onPressed: () {
                notificationModel.duhur = false;
                notificationBloc.add(SelectNotificationEvent(notificationModel));
              },
            );
        }
        break;
      case "asr":
        {
          if (notificationModel.asr == false)
            return PlatformIconButton(
              iosIcon: Icon(
                CupertinoIcons.bell,
              ),
              androidIcon: Icon(Icons.notifications),
              onPressed: () {
                notificationModel.asr = true;
                notificationBloc.add(SelectNotificationEvent(notificationModel));
              },
            );
          else
            return PlatformIconButton(
                iosIcon: Icon(
                  CupertinoIcons.bell_solid,
                ),
                androidIcon: Icon(Icons.notifications_active),
                onPressed: () {
                  notificationModel.asr = false;
                  notificationBloc.add(
                      SelectNotificationEvent(notificationModel));
                }
            );
        }
        break;

      case "magrib":
        {
          if (notificationModel.magrib == false)
            return PlatformIconButton(
              iosIcon: Icon(
                CupertinoIcons.bell,
              ),
              androidIcon: Icon(Icons.notifications),
              onPressed: () {
                notificationModel.magrib = true;
                notificationBloc.add(SelectNotificationEvent(notificationModel));
              },
            );
          else
            return PlatformIconButton(
              iosIcon: Icon(
                CupertinoIcons.bell_solid,
              ),
              androidIcon: Icon(Icons.notifications_active),
              onPressed: () {
                notificationModel.magrib = false;
                notificationBloc.add(SelectNotificationEvent(notificationModel));
              },
            );
        }
        break;

      case "esha":
        {
          if (notificationModel.esha == false)
            return PlatformIconButton(
              iosIcon: Icon(
                CupertinoIcons.bell,
              ),
              androidIcon: Icon(Icons.notifications),
              onPressed: () {
                notificationModel.esha = true;
                notificationBloc.add(SelectNotificationEvent(notificationModel));
              },
            );
          else
            return PlatformIconButton(
              iosIcon: Icon(
                CupertinoIcons.bell_solid,
              ),
              androidIcon: Icon(Icons.notifications_active),
              onPressed: () {
                notificationModel.esha = false;
                notificationBloc.add(SelectNotificationEvent(notificationModel));
              },
            );
        }
        break;
      default:
        {}
        break;
    }
    return null;
  }

  Widget buildBottomList(Timings item) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
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
            onPressed: () async {
              if(!await location.serviceEnabled()){
              location.requestService();
              }else {
                prayerBloc.add(RefreshPrayerEvent(item));
              }
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
              Icon(context.platformIcons.refresh,size: 18.0,color: Color(0xFFd4a554),)
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

  String trimToCityOnly(String timezone){
    if(timezone.contains('/')){
      return timezone.substring(timezone.indexOf('/')+1);
    }else{
      return timezone;
    }
  }
}

Widget singleTimeCard(
    String timeName, String time, IconData icon, Color color) {
  return Padding(
    padding: const EdgeInsets.only(left: 10 ,bottom: 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        SizedBox(
          width: 10,
        ),
        Text(
          time,
          style: TextStyle(fontSize: 20, color: Colors.black54),
        ),
      ],
    ),
  );
}