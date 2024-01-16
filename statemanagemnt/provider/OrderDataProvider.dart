import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ishtri_db/models/City.dart';
import 'package:ishtri_db/ApiRequest/ApiRequestPost.dart';
import 'package:ishtri_db/models/Order.dart';
import 'package:ishtri_db/models/Schedule.dart';
import 'package:ishtri_db/models/ScheduleSelect.dart';
import 'package:ishtri_db/models/ScheduleSelectTime.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/statemanagemnt/OrderService.dart';
import 'package:ishtri_db/statemanagemnt/SignupService.dart';

class OrderDataProvider with ChangeNotifier {
  bool loading = false;
  Schedule? schedule;
  ScheduleSelect? scheduleSelect;
  ScheduleSelectTime? scheduleSelectTime;
  Order? order;
  dynamic issue;

  // Future<City> fetchData(context) async {
  //   City result = City();
  //   print('call...');
  //   var isLoading = true;
  //   try {
  //     ApiService.get('user/city-list').then((data) {
  //       result = City.fromJson(data);
  //       print('result${result.data!.length}');
  //     }).catchError((error) {
  //       // Handle error
  //     }).whenComplete(() {
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  //   return result;
  // }

  addscheduleData(context, dynamic data) async {
    print('call...');
    loading = true;
    schedule = await OrderService.addScheduleData(context, data);
    print('call...1${schedule}');
    loading = false;
    notifyListeners();
  }

  fetchscheduleallData(context, data) async {
    // print('call...');
    loading = true;
    scheduleSelect = await OrderService.scheduleData(context, data);
    print('call...1 ${scheduleSelect}');
    loading = false;
    notifyListeners();
  }

  fetchscheduleTimeData(context) async {
    // print('call...');
    loading = true;
    scheduleSelectTime = await OrderService.scheduleTimeData(context);
    print('call...1${schedule}');
    loading = false;
    notifyListeners();
  }

  // fetchTowerData(context) async {
  //   // print('call...');
  //   loading = true;
  //   scheduleSelectTime = await OrderService.scheduleTimeData(context);
  //   print('call...1${schedule}');
  //   loading = false;
  //   notifyListeners();
  // }
  fetchOrderData(context) async {
    // print('call...');
    loading = true;
    order = await OrderService.orderData(context);
    print('call...1${order}');
    loading = false;
    notifyListeners();
  }

  acceptOrderData(context, data) async {
    // print('call...');
    loading = true;
    order = await OrderService.orderData(context);
    print('call...1${order}');
    loading = false;
    notifyListeners();
  }

  issueData(context, data) async {
    loading = true;
    issue = data;
    print('call...1${issue}');
    loading = false;
    notifyListeners();
  }
}
