import 'package:flutter_save/models/AthanTimes.dart';

class Ticker {
  Stream<int> tick({int ticks}) {
    return Stream.periodic(Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}

NextPrayer getNextPrayer(Timings timing){
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

  if(timeNow.isBefore(timeFajr)){return getTimeRemaining("Fajr", timeFajr, timeYesterdayIsha);}
  if(timeNow.isAfter(timeFajr)&&(timeNow.isBefore(timeDhuhr))){return getTimeRemaining("Dhuhr", timeDhuhr, timeFajr);}
  if(timeNow.isAfter(timeDhuhr)&&(timeNow.isBefore(timeAsr))){return getTimeRemaining("Asr", timeAsr, timeDhuhr);}
  if(timeNow.isAfter(timeAsr)&&(timeNow.isBefore(timeMaghrib))){return getTimeRemaining("Maghrib", timeMaghrib, timeAsr);}
  if(timeNow.isAfter(timeMaghrib)&&(timeNow.isBefore(timeIsha))){return getTimeRemaining("Isha", timeIsha, timeMaghrib);}
  if(timeNow.isAfter(timeIsha)&&(timeNow.isBefore(timeTomorrowFajr))){return getTimeRemaining("Fajr", timeTomorrowFajr, timeIsha);}
  // all cases did not match:
  return null;
}
class NextPrayer {
  String prayerName;
  Duration duration;
  double percent;
  NextPrayer(this.prayerName, this.duration, this.percent);

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