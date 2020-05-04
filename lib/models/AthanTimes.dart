// To parse this JSON data, do
//
//     final athanTime = athanTimeFromJson(jsonString);

import 'dart:convert';

AthanTime athanTimeFromJson(String str) => AthanTime.fromJson(json.decode(str));

String athanTimeToJson(AthanTime data) => json.encode(data.toJson());

class AthanTime {
  int code;
  String status;
  List<Datum> data;

  AthanTime({
    this.code,
    this.status,
    this.data,
  });

  factory AthanTime.fromJson(Map<String, dynamic> json) => AthanTime(
    code: json["code"],
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Timings timings;
  Date date;
  Meta meta;

  Datum({
    this.timings,
    this.date,
    this.meta,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    timings: Timings.fromJson(json["timings"]),
    date: Date.fromJson(json["date"]),
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "timings": timings.toJson(),
    "date": date.toJson(),
    "meta": meta.toJson(),
  };
}

class Date {
  String readable;
  String timestamp;
  Gregorian gregorian;
  Hijri hijri;

  Date({
    this.readable,
    this.timestamp,
    this.gregorian,
    this.hijri,
  });

  factory Date.fromJson(Map<String, dynamic> json) => Date(
    readable: json["readable"],
    timestamp: json["timestamp"],
    gregorian: Gregorian.fromJson(json["gregorian"]),
    hijri: Hijri.fromJson(json["hijri"]),
  );

  Map<String, dynamic> toJson() => {
    "readable": readable,
    "timestamp": timestamp,
    "gregorian": gregorian.toJson(),
    "hijri": hijri.toJson(),
  };
}

class Gregorian {
  String date;
  Format format;
  String day;
  GregorianWeekday weekday;
  GregorianMonth month;
  String year;
  Designation designation;

  Gregorian({
    this.date,
    this.format,
    this.day,
    this.weekday,
    this.month,
    this.year,
    this.designation,
  });

  factory Gregorian.fromJson(Map<String, dynamic> json) => Gregorian(
    date: json["date"],
    format: formatValues.map[json["format"]],
    day: json["day"],
    weekday: GregorianWeekday.fromJson(json["weekday"]),
    month: GregorianMonth.fromJson(json["month"]),
    year: json["year"],
    designation: Designation.fromJson(json["designation"]),
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "format": formatValues.reverse[format],
    "day": day,
    "weekday": weekday.toJson(),
    "month": month.toJson(),
    "year": year,
    "designation": designation.toJson(),
  };
}

class Designation {
  Abbreviated abbreviated;
  Expanded expanded;

  Designation({
    this.abbreviated,
    this.expanded,
  });

  factory Designation.fromJson(Map<String, dynamic> json) => Designation(
    abbreviated: abbreviatedValues.map[json["abbreviated"]],
    expanded: expandedValues.map[json["expanded"]],
  );

  Map<String, dynamic> toJson() => {
    "abbreviated": abbreviatedValues.reverse[abbreviated],
    "expanded": expandedValues.reverse[expanded],
  };
}

enum Abbreviated { AD, AH }

final abbreviatedValues = EnumValues({
  "AD": Abbreviated.AD,
  "AH": Abbreviated.AH
});

enum Expanded { ANNO_DOMINI, ANNO_HEGIRAE }

final expandedValues = EnumValues({
  "Anno Domini": Expanded.ANNO_DOMINI,
  "Anno Hegirae": Expanded.ANNO_HEGIRAE
});

enum Format { DD_MM_YYYY }

final formatValues = EnumValues({
  "DD-MM-YYYY": Format.DD_MM_YYYY
});

class GregorianMonth {
  int number;
  PurpleEn en;

  GregorianMonth({
    this.number,
    this.en,
  });

  factory GregorianMonth.fromJson(Map<String, dynamic> json) => GregorianMonth(
    number: json["number"],
    en: purpleEnValues.map[json["en"]],
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "en": purpleEnValues.reverse[en],
  };
}

enum PurpleEn { MAY }

final purpleEnValues = EnumValues({
  "May": PurpleEn.MAY
});

class GregorianWeekday {
  String en;

  GregorianWeekday({
    this.en,
  });

  factory GregorianWeekday.fromJson(Map<String, dynamic> json) => GregorianWeekday(
    en: json["en"],
  );

  Map<String, dynamic> toJson() => {
    "en": en,
  };
}

class Hijri {
  String date;
  Format format;
  String day;
  HijriWeekday weekday;
  HijriMonth month;
  String year;
  Designation designation;
  List<String> holidays;

  Hijri({
    this.date,
    this.format,
    this.day,
    this.weekday,
    this.month,
    this.year,
    this.designation,
    this.holidays,
  });

  factory Hijri.fromJson(Map<String, dynamic> json) => Hijri(
    date: json["date"],
    format: formatValues.map[json["format"]],
    day: json["day"],
    weekday: HijriWeekday.fromJson(json["weekday"]),
    month: HijriMonth.fromJson(json["month"]),
    year: json["year"],
    designation: Designation.fromJson(json["designation"]),
    holidays: List<String>.from(json["holidays"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "format": formatValues.reverse[format],
    "day": day,
    "weekday": weekday.toJson(),
    "month": month.toJson(),
    "year": year,
    "designation": designation.toJson(),
    "holidays": List<dynamic>.from(holidays.map((x) => x)),
  };
}

class HijriMonth {
  int number;
  FluffyEn en;
  Ar ar;

  HijriMonth({
    this.number,
    this.en,
    this.ar,
  });

  factory HijriMonth.fromJson(Map<String, dynamic> json) => HijriMonth(
    number: json["number"],
    en: fluffyEnValues.map[json["en"]],
    ar: arValues.map[json["ar"]],
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "en": fluffyEnValues.reverse[en],
    "ar": arValues.reverse[ar],
  };
}

enum Ar { EMPTY, AR }

final arValues = EnumValues({
  "شَوّال": Ar.AR,
  "رَمَضان": Ar.EMPTY
});

enum FluffyEn { RAMAN, SHAWWL }

final fluffyEnValues = EnumValues({
  "Ramaḍān": FluffyEn.RAMAN,
  "Shawwāl": FluffyEn.SHAWWL
});

class HijriWeekday {
  String en;
  String ar;

  HijriWeekday({
    this.en,
    this.ar,
  });

  factory HijriWeekday.fromJson(Map<String, dynamic> json) => HijriWeekday(
    en: json["en"],
    ar: json["ar"],
  );

  Map<String, dynamic> toJson() => {
    "en": en,
    "ar": ar,
  };
}

class Meta {
  double latitude;
  double longitude;
  Timezone timezone;
  Method method;
  LatitudeAdjustmentMethod latitudeAdjustmentMethod;
  MidnightMode midnightMode;
  MidnightMode school;
  Offset offset;

  Meta({
    this.latitude,
    this.longitude,
    this.timezone,
    this.method,
    this.latitudeAdjustmentMethod,
    this.midnightMode,
    this.school,
    this.offset,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    timezone: timezoneValues.map[json["timezone"]],
    method: Method.fromJson(json["method"]),
    latitudeAdjustmentMethod: latitudeAdjustmentMethodValues.map[json["latitudeAdjustmentMethod"]],
    midnightMode: midnightModeValues.map[json["midnightMode"]],
    school: midnightModeValues.map[json["school"]],
    offset: Offset.fromJson(json["offset"]),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "timezone": timezoneValues.reverse[timezone],
    "method": method.toJson(),
    "latitudeAdjustmentMethod": latitudeAdjustmentMethodValues.reverse[latitudeAdjustmentMethod],
    "midnightMode": midnightModeValues.reverse[midnightMode],
    "school": midnightModeValues.reverse[school],
    "offset": offset.toJson(),
  };
}

enum LatitudeAdjustmentMethod { ANGLE_BASED }

final latitudeAdjustmentMethodValues = EnumValues({
  "ANGLE_BASED": LatitudeAdjustmentMethod.ANGLE_BASED
});

class Method {
  int id;
  Name name;
  Params params;

  Method({
    this.id,
    this.name,
    this.params,
  });

  factory Method.fromJson(Map<String, dynamic> json) => Method(
    id: json["id"],
    name: nameValues.map[json["name"]],
    params: Params.fromJson(json["params"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": nameValues.reverse[name],
    "params": params.toJson(),
  };
}

enum Name { UMM_AL_QURA_UNIVERSITY_MAKKAH }

final nameValues = EnumValues({
  "Umm Al-Qura University, Makkah": Name.UMM_AL_QURA_UNIVERSITY_MAKKAH
});

class Params {
  double fajr;
  ParamsIsha isha;

  Params({
    this.fajr,
    this.isha,
  });

  factory Params.fromJson(Map<String, dynamic> json) => Params(
    fajr: json["Fajr"].toDouble(),
    isha: paramsIshaValues.map[json["Isha"]],
  );

  Map<String, dynamic> toJson() => {
    "Fajr": fajr,
    "Isha": paramsIshaValues.reverse[isha],
  };
}

enum ParamsIsha { THE_90_MIN }

final paramsIshaValues = EnumValues({
  "90 min": ParamsIsha.THE_90_MIN
});

enum MidnightMode { STANDARD }

final midnightModeValues = EnumValues({
  "STANDARD": MidnightMode.STANDARD
});

class Offset {
  int imsak;
  int fajr;
  int sunrise;
  int dhuhr;
  int asr;
  int maghrib;
  int sunset;
  dynamic isha;
  int midnight;

  Offset({
    this.imsak,
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.maghrib,
    this.sunset,
    this.isha,
    this.midnight,
  });

  factory Offset.fromJson(Map<String, dynamic> json) => Offset(
    imsak: json["Imsak"],
    fajr: json["Fajr"],
    sunrise: json["Sunrise"],
    dhuhr: json["Dhuhr"],
    asr: json["Asr"],
    maghrib: json["Maghrib"],
    sunset: json["Sunset"],
    isha: json["Isha"],
    midnight: json["Midnight"],
  );

  Map<String, dynamic> toJson() => {
    "Imsak": imsak,
    "Fajr": fajr,
    "Sunrise": sunrise,
    "Dhuhr": dhuhr,
    "Asr": asr,
    "Maghrib": maghrib,
    "Sunset": sunset,
    "Isha": isha,
    "Midnight": midnight,
  };
}

enum IshaIsha { THE_30_MIN }

final ishaIshaValues = EnumValues({
  "30 min": IshaIsha.THE_30_MIN
});

enum Timezone { EUROPE_LONDON }

final timezoneValues = EnumValues({
  "Europe/London": Timezone.EUROPE_LONDON
});

class Timings {
  String fajr;
  String sunrise;
  String dhuhr;
  String asr;
  String sunset;
  String maghrib;
  String isha;
  String imsak;
  Midnight midnight;

  Timings({
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.sunset,
    this.maghrib,
    this.isha,
    this.imsak,
    this.midnight,
  });

  factory Timings.fromJson(Map<String, dynamic> json) => Timings(
    fajr: json["Fajr"],
    sunrise: json["Sunrise"],
    dhuhr: json["Dhuhr"],
    asr: json["Asr"],
    sunset: json["Sunset"],
    maghrib: json["Maghrib"],
    isha: json["Isha"],
    imsak: json["Imsak"],
    midnight: midnightValues.map[json["Midnight"]],
  );

  Map<String, dynamic> toJson() => {
    "Fajr": fajr,
    "Sunrise": sunrise,
    "Dhuhr": dhuhrValues.reverse[dhuhr],
    "Asr": asr,
    "Sunset": sunset,
    "Maghrib": maghrib,
    "Isha": isha,
    "Imsak": imsak,
    "Midnight": midnightValues.reverse[midnight],
  };
}

enum Dhuhr { THE_1258_BST, THE_1257_BST }

final dhuhrValues = EnumValues({
  "12:57 (BST)": Dhuhr.THE_1257_BST,
  "12:58 (BST)": Dhuhr.THE_1258_BST
});

enum Midnight { THE_0058_BST, THE_0057_BST, THE_0059_BST }

final midnightValues = EnumValues({
  "00:57 (BST)": Midnight.THE_0057_BST,
  "00:58 (BST)": Midnight.THE_0058_BST,
  "00:59 (BST)": Midnight.THE_0059_BST
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

class NextPrayer {
  String prayerName;
  Duration duration;
  double percent;
  NextPrayer(this.prayerName, this.duration, this.percent);
}