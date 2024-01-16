import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ishtri_db/models/City.dart';
import 'package:ishtri_db/ApiRequest/ApiRequestPost.dart';
import 'package:ishtri_db/models/Login.dart';
import 'package:ishtri_db/models/AddHelperDb.dart';
import 'package:ishtri_db/models/Signup.dart';
import 'package:ishtri_db/models/ViewHelper.dart';
import 'package:ishtri_db/services/Api.dart';

class DashboardService {
  static Future<AddHelperDb?> addHelperData(context, data, token) async {
    AddHelperDb? result;
    print('call...');
    try {
      var cityres = await ApiService.posttoken('user/add-helper', "", data);
      result = AddHelperDb.fromJson(cityres);
      print('result${cityres}');
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<ViewHelper?> helperData(context) async {
    ViewHelper? result;
    print('call...1');
    try {
      var resPro = await ApiService.getToken('user/helper-list');
      print('result 33 ${resPro}');
      result = ViewHelper.fromJson(resPro);
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<ViewHelper?> viewHelperData(context, data) async {
    ViewHelper? result;
    try {
      var resPro = await ApiService.post('user/helper-details', data);
      print('result resPro${resPro}');
      result = ViewHelper.fromJson(resPro);
    } catch (e) {
      print(e);
    }
    return result;
  }
}
