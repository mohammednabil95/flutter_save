import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_save/bloc/calendar_bloc.dart';
import 'package:flutter_save/bloc/calendar_event.dart';
import 'package:flutter_save/bloc/calendar_state.dart';
import 'package:flutter_save/models/AthanTimes.dart';
import 'package:flutter_save/repository/calendar_repository.dart';
import 'package:flutter_save/services/presentation/my_flutter_app_icons.dart';
import 'package:hijri/umm_alqura_calendar.dart';
import 'package:intl/intl.dart';
import 'package:hijri_picker/hijri_picker.dart';

class ParentCalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalendarBloc>(
        create: (BuildContext context) => CalendarBloc(calendarRepositoryImpl: CalendarRepositoryImpl()),
        child: CalendarPage());
  }
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}
class _CalendarPageState extends State<CalendarPage> {

  DateTime selectedDateG = DateTime.now();
  ummAlquraCalendar selectedDate = new ummAlquraCalendar.now();
  ummAlquraCalendar temp = new ummAlquraCalendar();
  String dateFormat;
  CalendarBloc calendarBloc;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalendarBloc, CalendarState>(
      listener: (context,state) {},
      child: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context,state) {
          if (state is InitialCalendarState) {
            return buildLoading();
          }
          else if (state is CalendarLoadedState) {
            return buildCalendar(state.item);
          }
          else if (state is CalendarErrorState) {
            return buildErrorUi(state.message1);
          }
          return null;
        },
      ),
    );
  }

  void initState() {
    super.initState();
    calendarBloc = BlocProvider.of<CalendarBloc>(context);
    calendarBloc.add(OpenCalendarEvent());
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

  Widget buildLoading() {
    return Center(
      child: PlatformCircularProgressIndicator(),
    );
  }
  Widget buildCalendar(Timings item) {
    dateFormat = DateFormat('dd-MM-yyyy').format(selectedDateG);
    return Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0,horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(AppLocalizations.of(context).tr('Gregorian'),
                                style: TextStyle(
                                    fontSize: 12,color: Colors.grey),),
                              SizedBox(height: 10,),
                              Text(dateFormat,
                                style: TextStyle(color: Colors.white),),
                            ],
                          ),
                          FlatButton(
                            onPressed: () {
                              _selectDateG(context);
                            },
                            color: Color(0xFF614729),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(AppLocalizations.of(context).tr(
                                'Change date'),style: TextStyle(
                                color: Colors.white,fontSize: 12),),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0,horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(AppLocalizations.of(context).tr('Hijri'),
                                style: TextStyle(
                                    fontSize: 12,color: Colors.grey),),
                              SizedBox(height: 10,),
                              Text(selectedDate.toString(),
                                style: TextStyle(color: Colors.white),),
                            ],
                          ),
                          FlatButton(
                            onPressed: () => _selectDate(context),
                            color: Color(0xFF614729),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(AppLocalizations.of(context).tr(
                                'Change date'),style: TextStyle(
                                color: Colors.white,fontSize: 12),),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            buildPrayerTimes(item),
          ],
        )
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

  Widget singleTimeCard(String timeName, String time, IconData icon, Color color){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget> [
            Row(
              children: <Widget>[
                Icon(icon, color: color,),
                SizedBox(width: 10,),
                Text(timeName,style: TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold),),
              ],
            ),
            Text(time,style: TextStyle(fontSize: 20, color: Colors.black54),),
          ]
      ),
    );
  }

  Widget buildPrayerTimes(Timings timings) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16.0,0,16.0,16.0),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      singleTimeCard(AppLocalizations.of(context).tr('Fajr'),
                          formatTime(timings.fajr),
                          MyFlutterApp.sunrise, Color(0xFFe5bf07)),
                      singleTimeCard(AppLocalizations.of(context).tr('Dhuhr'),
                          formatTime(timings.dhuhr),
                          MyFlutterApp.sun, Color(0xFFe5bf07)),
                      singleTimeCard(AppLocalizations.of(context).tr('Asr'),
                          formatTime(timings.asr),
                          MyFlutterApp.sun_inv, Color(0xFFe5bf07)),
                      singleTimeCard(AppLocalizations.of(context).tr('Maghrib'),
                          formatTime(timings.maghrib),
                          MyFlutterApp.fog_sun, Color(0xFFe5bf07)),
                      singleTimeCard(AppLocalizations.of(context).tr('Isha'),
                          formatTime(timings.isha),
                          MyFlutterApp.fog_moon, Color(0xFF86a4c3)),
                    ],
                  ),
                ),
              ),
            );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final ummAlquraCalendar picked = await showHijriDatePicker(
      context: context,
      initialDate: selectedDate,
      lastDate: new ummAlquraCalendar()
        ..hYear = 1442
        ..hMonth = 9
        ..hDay = 25,
      firstDate: new ummAlquraCalendar()
        ..hYear = 1438
        ..hMonth = 12
        ..hDay = 25,
      initialDatePickerMode: DatePickerMode.day,
    );
    DateTime date = temp.hijriToGregorian(picked.hYear, picked.hMonth, picked.hDay);
    print(picked);
    if (picked != null && picked!=selectedDate){
        selectedDate=picked;
    }
      calendarBloc.add(GetCalendarEvent(date));
  }

  Future<Null> _selectDateG(BuildContext context) async {
    DateTime today = DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(2015,8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked !=selectedDateG) {
        selectedDateG=picked;
      calendarBloc.add(GetCalendarEvent(picked));
    }
  }
}