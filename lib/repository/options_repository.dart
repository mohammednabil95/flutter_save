

import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:flutter_save/models/AthanTimes.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_save/models/Options.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_save/utilities/file_util.dart';

abstract class OptionsRepository {
  Future<Options> getOptions();
  Future<void> saveOptions(Options options);
}

class OptionsRepositoryImp implements OptionsRepository {

  @override
  Future<Options> getOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int selectedM = await prefs.getInt('prayer_method') ?? 4;
    Options method = Options(selectedM);
    return method;
  }
  @override
  Future<void> saveOptions(Options options) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('prayer_method', options.selectedMethod);
  }

}