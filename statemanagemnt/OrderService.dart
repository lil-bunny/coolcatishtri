import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ishtri_db/models/City.dart';
import 'package:ishtri_db/ApiRequest/ApiRequestPost.dart';
import 'package:ishtri_db/models/Helper.dart';
import 'package:ishtri_db/models/Login.dart';
import 'package:ishtri_db/models/AddHelperDb.dart';
import 'package:ishtri_db/models/Order.dart';
import 'package:ishtri_db/models/Schedule.dart';
import 'package:ishtri_db/models/ScheduleSelect.dart';
import 'package:ishtri_db/models/ScheduleSelectTime.dart';
import 'package:ishtri_db/models/Signup.dart';
import 'package:ishtri_db/models/ViewHelper.dart';
import 'package:ishtri_db/services/Api.dart';

class OrderService {
  static Future<ScheduleSelect?> scheduleData(context, data) async {
    ScheduleSelect? result;
    print('call...');
    // var isLoading = true;
    try {
      var cityres = await ApiService.posttoken(
          'v1/delivery-boy/delivery-boy/get-db-schedule', "", data);
      result = ScheduleSelect.fromJson(cityres);
      print('result ${cityres}');
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<Schedule?> addScheduleData(context, dynamic data) async {
    Schedule? result;

    print('call...1$data');
    try {
      var resPro = await ApiService.posttoken(
          'v1/delivery-boy/schedule/create-schedule', true, jsonEncode(data));
      print('result 33 ${resPro}');
      result = Schedule.fromJson(resPro);
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<ScheduleSelectTime?> scheduleTimeData(context) async {
    ScheduleSelectTime? result;
    print('call...1');
    try {
      var resPro = await ApiService.getToken(
          'v1/delivery-boy/auth/default-schedule-list');
      print('result resPro${resPro}');
      result = ScheduleSelectTime.fromJson(resPro);
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<Order?> orderData(context) async {
    Order? result;
    print('call...1');
    try {
      var resPro =
          await ApiService.getToken('v1/delivery-boy/customer/schedule-list');
      print('result ${resPro}');
      result = Order.fromJson(resPro);
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<Order?> accregorderData(context, data) async {
    Order? result;
    print('call...1');
    try {
      var resPro = await ApiService.posttoken(
          'v1/delivery-boy/customer/schedule-list', "", data);
      print('result ${resPro}');
      result = Order.fromJson(resPro);
    } catch (e) {
      print(e);
    }
    return result;
  }
}
