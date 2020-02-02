import 'package:geolocator/geolocator.dart';
import 'package:flutter_save/models/AthanTimes.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_save/models/Options.dart';
import 'dart:convert';

import 'package:flutter_save/utilities/file_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CalendarRepository {
  Future<Timings> getItem(DateTime date);
}

class CalendarRepositoryImpl implements CalendarRepository {

  String fileName = 'prayerdata.json';
  @override
  Future<Timings> getItem(DateTime date) async {

    int day = date.day;
    String month = (date.month).toString();
    String year = (date.year).toString();
    String rawData;
    FileUtil fileUtil = new FileUtil(fileName);
    rawData = await fileUtil.readFile();
    var data;
    var resp;
    List<Datum> item;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Options method = Options(prefs.getInt('prayer_method')?? 4);
    if(rawData == null){   // the file doesn't exist, get from API
      resp = await getMonthlyPrayerDataFromAPI(month, year, method.selectedMethod);
      rawData = resp.body;
      if (resp.statusCode == 200) {
        data = json.decode(resp.body);
        item = AthanTime.fromJson(data).data;
      }else {
        throw Exception();
      }
    }else{  // the file exists
      data = json.decode(rawData);
      item = AthanTime.fromJson(data).data;
      if((item[0].date.gregorian.month.number).toString() != month  || item[0].date.gregorian.year != year){ // if not the same month or year
        resp = await getMonthlyPrayerDataFromAPI(month, year, method.selectedMethod);
        rawData = resp.body;
        if (resp.statusCode == 200) {
          data = json.decode(resp.body);
          item = AthanTime.fromJson(data).data;
        }else {
          throw Exception();
        }
      }
    }
      var arrayLocation = 0;
      for(int i=0 ; i< item.length; i++){
        var intDay = int.parse(item[i].date.gregorian.day);
        if( intDay == day ){
          arrayLocation = i;
        }
      }
      Timings timings = item[arrayLocation].timings;

      return timings;

  }

  Future<http.Response> getMonthlyPrayerDataFromAPI(String month, String year, int method) async{
    Position position = await getGPSLocation();
    double lat = position.latitude;
    double long = position.longitude;

    String fullUrl = 'http://api.aladhan.com/v1/calendar?latitude=$lat&longitude=$long&method=$method&month=$month&year=$year'; // add &annual=true to ignore month and get full year.
    final response = await http.get(fullUrl);
    return response;
  }

  Future<Position> getGPSLocation() async{
    Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

}