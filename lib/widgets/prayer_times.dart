//import 'package:flutter/material.dart';
//import 'package:flutter_save/services/presentation/my_flutter_app_icons.dart';
//import 'package:easy_localization/easy_localization.dart';
//
//Widget singleTimeCard(String timeName, String time, IconData icon, Color color){
//
//
//  return Padding(
//    padding: const EdgeInsets.all(16.0),
//    child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget> [
//          Row(
//            children: <Widget>[
//              Icon(icon, color: color,),
//              SizedBox(width: 10,),
//              Text(timeName,style: TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold),),
//            ],
//          ),
//          Text(time,style: TextStyle(fontSize: 20, color: Colors.black54),),
//        ]
//    ),
//  );
//}
//
//class TimeCard extends StatefulWidget {
//  TimeCard({
//    @required this.data,
//    Key key,
//  }) : super(key: key);
//
//  //Data data;
//
//  @override
//  _TimeCardState createState() => _TimeCardState();
//}
//
//class _TimeCardState extends State<TimeCard> {
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      children: <Widget>[
//        singleTimeCard(AppLocalizations.of(context).tr('Fajr'),
//            formatTime(widget.data.timings.fajr),
//            MyFlutterApp.sunrise, Color(0xFFe5bf07)),
//        singleTimeCard(AppLocalizations.of(context).tr('Dhuhr'),
//            formatTime(widget.data.timings.dhuhr),
//            MyFlutterApp.sun, Color(0xFFe5bf07)),
//        singleTimeCard(AppLocalizations.of(context).tr('Asr'),
//            formatTime(widget.data.timings.asr),
//            MyFlutterApp.sun_inv, Color(0xFFe5bf07)),
//        singleTimeCard(AppLocalizations.of(context).tr('Maghrib'),
//            formatTime(widget.data.timings.maghrib),
//            MyFlutterApp.fog_sun, Color(0xFFe5bf07)),
//        singleTimeCard(AppLocalizations.of(context).tr('Isha'),
//            formatTime(widget.data.timings.isha),
//            MyFlutterApp.fog_moon, Color(0xFF86a4c3)),
//      ],
//    );
//  }
//
//  String formatTime(String time){
//    List<String> timeData= to12Hour(time);
//    String formattedTime = timeData[0];
//    Localizations.localeOf(context).languageCode == "ar"
//        ? formattedTime = formattedTime + timeData[2]
//        : formattedTime = formattedTime + timeData[1];
//
//
//
//    return formattedTime;
//  }
//
//  List<String> to12Hour(String time){
//    List<String> time12hour = new List<String>();
//    String noon = " AM";
//    String noonAr = " ص";
//    int hour = int.parse(time.substring(0,2));
//    if (hour >= 12) {
//      hour = hour - 12;
//      noon = " PM";
//      noonAr = " م";
//    }
//    if (hour == 0) {
//      hour = 12;
//    }
//    time12hour.add(hour.toString() + time.substring(2,5));
//    time12hour.add(noon);
//    time12hour.add(noonAr);
//    return time12hour;
//  }
//
//
//}