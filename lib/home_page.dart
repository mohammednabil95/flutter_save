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



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PrayerBloc prayerBloc;
  NotificationBloc notificationBloc;

  @override
  void initState() {

    super.initState();
    notificationBloc = BlocProvider.of<NotificationBloc>(context);
    prayerBloc = BlocProvider.of<PrayerBloc>(context);
    prayerBloc.add(FetchPrayerEvent());
    notificationBloc.add(FetchNotificationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
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
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Container(
              height: 500,
              width: 200,
              color: Colors.white,
              child: BlocListener<NotificationBloc, NotificationState>(
                listener: (context, state) {
                },
                child: BlocBuilder<NotificationBloc, NotificationState>(
                  builder: (context, state) {
                    if(state is InitialNotificationState) {
                      return buildLoading();
                    }
                    else if (state is NotificationLoadedState) {
                      return NotificationIconBuild(state.notification);
                    }
                    else if(state is NotificationErrorState) {
                      return buildErrorUi(state.message1);
                    }
                  },
                ),
              ),
            )
          ],
        )
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
    return new Container(
      width: 200.0,
      child: new Center(
        child: new Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Fajr"),
                        Padding(
                          padding: EdgeInsets.only(left: 50.0),
                        ),
                        Text(item.fajr),
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
            notificationModle.duhur = false;
            notificationBloc.add(SelectNotificationEvent(notificationModle));
          },
        );
      }
      break;
      case "duhur": {
        if(notificationModle.fajr == false)
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
        if(notificationModle.fajr == false)
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
      case "esha": {
        if(notificationModle.fajr == false)
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

      default: {
        //statements;
      }
      break;
    }

  }


}
