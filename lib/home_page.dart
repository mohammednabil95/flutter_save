import 'package:prayer_bloc/bloc/prayer_bloc.dart';
import 'package:prayer_bloc/bloc/prayer_event.dart';
import 'package:prayer_bloc/bloc/prayer_state.dart';
import 'package:prayer_bloc/models/AthanTimes.dart';
//import 'package:prayer_bloc/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:prayer_bloc/repository/options_repository.dart';
import 'package:prayer_bloc/repository/prayer_repository.dart';
import 'package:prayer_bloc/settings_page.dart';

import 'bloc/options_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PrayerBloc prayerBloc;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    prayerBloc = BlocProvider.of<PrayerBloc>(context);
    prayerBloc.add(FetchPrayerEvent());

  }

  @override
  Widget build(BuildContext context) {
    return     Container(
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
                          return buildArticleList(state.item);
                        } else if (state is PrayerErrorState) {
                          return buildErrorUi(state.message1);
                        }
                      },
                    ),
                  ),

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
        return new Container(
          child: new Center(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Container(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                          ),
                          Row(
                            children: <Widget>[
                              Text("Fajr"),
                              Padding(
                                padding: EdgeInsets.only(left: 50.0),
                              ),
                              Text(item.fajr),
                              IconButton(
                                icon: Icon(Icons.notifications),
                                onPressed: () {},
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                          ),
                          Row(
                            children: <Widget>[
                              Text("Dhuhr"),
                              Padding(
                                padding: EdgeInsets.only(left: 30.0),
                              ),
                              Text(item.dhuhr),
                              IconButton(
                                icon: Icon(Icons.notifications),
                                onPressed: () {

                                },
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                          ),
                          Row(
                            children: <Widget>[
                              Text("Asr"),
                              Padding(
                                padding: EdgeInsets.only(left: 55.0),
                              ),
                              Text(item.asr),
                              //2:45 pm
                              //api = item[pos].asr.split(':');
                              //api=item[pos].asr.split(':'),
                              //api2=api,

                              //Text(data),
                              IconButton(
                                icon: Icon(Icons.notifications),
                                onPressed: () {
                                  //_showSnackBar();
                                  List<String> arr = item.asr.split(':');
                                  int aa = int.parse(arr[0]);
                                  //int bb = int.parse(arr[1]);
                                  print(aa);

                                  //print(num[1]);


                                  //asrnotification();
                                  var time = new Time(aa, 40, 0);
                                  var android = new AndroidNotificationDetails(
                                      'Channel Id', 'Channel Name', 'Channel Des',);
                                  var iOS = new IOSNotificationDetails();
                                  var platform = new NotificationDetails(android, iOS);
                                  flutterLocalNotificationsPlugin.showDailyAtTime(0, 'show daily title',
                                      'Daily notification shown at approximately', time, platform);
                                },
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                          ),
                          Row(
                            children: <Widget>[
                              Text("Maghrib"),
                              Padding(
                                padding: EdgeInsets.only(left: 25.0),
                              ),
                              Text(item.maghrib),
                              IconButton(
                                icon: Icon(Icons.notifications),
                                onPressed: () {},
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                          ),
                          Row(
                            children: <Widget>[
                              Text("Isha"),
                              Padding(
                                padding: EdgeInsets.only(left: 50.0),
                              ),
                              Text(item.isha),
                              IconButton(
                                icon: Icon(Icons.notifications),
                                onPressed: () {},
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                          ),
//                          Builder(
//                            builder: (context)=>
//                                RaisedButton(
//                                  onPressed: (){
//                                    Navigator.push(
//                                      context,
//                                      MaterialPageRoute(builder: (context) => SettingsPage()),
//                                    );
//                                  },
//                                ),
//                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
  }
}
