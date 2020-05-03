import 'package:geolocator/geolocator.dart';
import 'package:flutter_save/models/AthanTimes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_save/models/Options.dart';
import 'dart:convert';
import 'package:flutter_save/utilities/file_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PrayerRepository {
  Future<Timings> getItem({int method});
  NextPrayer getNextPrayer(Timings timing);
}

class PrayerRepositoryImpl implements PrayerRepository {
  String fileName = 'prayerdata.json';
  @override
  Future<Timings> getItem({int method}) async {
    DateTime today = DateTime.now();
    int day = today.day;
    int month = today.month;
    int year = today.year;
    String rawData;
    FileUtil fileUtil = new FileUtil(fileName);
    rawData = await fileUtil.readFile();
    var data;
    var resp;
    List<Datum> item;
    if(rawData == null || method != null){
      resp = await updatePrayerDataFileUsingAPI();
      rawData = resp.body;
      if (resp.statusCode == 200) {
        data = json.decode(resp.body);
        item = AthanTime.fromJson(data).data;
      }else {
        throw Exception();
      }
    }else{
      data = json.decode(rawData);
      item = AthanTime.fromJson(data).data;
      if(item[0].date.gregorian.month.number != month || int.parse(item[0].date.gregorian.year) != year){ // if not the same month or year
        resp = await updatePrayerDataFileUsingAPI();
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

  Future<http.Response> updatePrayerDataFileUsingAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Options method = Options(prefs.getInt('prayer_method')?? 4);
    print("************** Prayer method = $method");
    DateTime today = DateTime.now();
    String year = today.year.toString().padLeft(4,'0');
    String month = today.month.toString().padLeft(2,'0');
    FileUtil fileUtil = new FileUtil(fileName);
    var rawData = await getMonthlyPrayerDataFromAPI(month,year,method.selectedMethod);
    await fileUtil.writeToFile(rawData.body);
    return rawData;
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

  NextPrayer getNextPrayer(Timings timing) {
    DateTime timeNow = DateTime.now();
    String nowYear = timeNow.year.toString().padLeft(4,'0');
    String nowMonth = timeNow.month.toString().padLeft(2,'0');
    String nowDay = timeNow.day.toString().padLeft(2,'0');

    DateTime timeFajr = convertToDateTime("timeFajr", nowYear,nowMonth,nowDay,timing.fajr);
    DateTime timeDhuhr = convertToDateTime("timeDhuhr", nowYear,nowMonth,nowDay,timing.dhuhr);
    DateTime timeAsr = convertToDateTime("timeAsr", nowYear,nowMonth,nowDay,timing.asr);
    DateTime timeMaghrib = convertToDateTime("timeMaghrib", nowYear,nowMonth,nowDay,timing.maghrib);
    DateTime timeIsha = convertToDateTime("timeIsha", nowYear,nowMonth,nowDay,timing.isha);

    //TODO: Tomorow's Fajr should be taken from next day:
    DateTime timeTomorrowFajr = timeFajr.add(Duration(days: 1));
    //TODO: Yesterday's Isha should be taken from previous day:
    DateTime timeYesterdayIsha = timeIsha.subtract(Duration(days: 1));

    if(timeNow.isBefore(timeFajr)){return  getTimeRemaining("Fajr", timeFajr, timeYesterdayIsha);}
    if(timeNow.isAfter(timeFajr)&&(timeNow.isBefore(timeDhuhr))){return getTimeRemaining("Dhuhr", timeDhuhr, timeFajr);}
    if(timeNow.isAfter(timeDhuhr)&&(timeNow.isBefore(timeAsr))){return getTimeRemaining("Asr", timeAsr, timeDhuhr);}
    if(timeNow.isAfter(timeAsr)&&(timeNow.isBefore(timeMaghrib))){return getTimeRemaining("Maghrib", timeMaghrib, timeAsr);}
    if(timeNow.isAfter(timeMaghrib)&&(timeNow.isBefore(timeIsha))){return getTimeRemaining("Isha", timeIsha, timeMaghrib);}
    if(timeNow.isAfter(timeIsha)&&(timeNow.isBefore(timeTomorrowFajr))){return getTimeRemaining("Fajr", timeTomorrowFajr, timeIsha);}
    // all cases did not match:
    return null;
  }

  DateTime convertToDateTime(String prayerName, String year,String month,String day,String prayerClock){
    DateTime prayer = DateTime.parse('$year-$month-$day ${prayerClock.substring(0,5)}:00');
    return prayer;
  }

   NextPrayer getTimeRemaining(String prayerName ,DateTime nextPrayer, DateTime prevPrayer){
    DateTime timeNow = DateTime.now();
    Duration timeRemaining = nextPrayer.difference(timeNow);
    Duration totalTime = nextPrayer.difference(prevPrayer);
    double percent = timeRemaining.inMinutes / totalTime.inMinutes * 100;
    return new NextPrayer(prayerName, timeRemaining, percent);
  }
}



