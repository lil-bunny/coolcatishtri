import 'dart:ffi';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ishtri_db/models/AddService.dart';
import 'package:ishtri_db/models/DBrate.dart';
import 'package:ishtri_db/models/Data.dart';
import 'package:ishtri_db/ApiRequest/ApiRequestPost.dart';
import 'package:ishtri_db/models/Laundry.dart';
import 'package:ishtri_db/models/LaundryActive.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/statemanagemnt/LaundryService.dart';

class LaundryDataProvider with ChangeNotifier {
  bool loading = false;
  dynamic dataLS;
  dynamic dataTax;
  Laundry? laundry;
  DBrate? dBrate;
  AddService? addService;
  LaundryActive? laundryActive;
  fetchData(context, dynamic data) async {
    print('call...');
    dataLS = data;
    notifyListeners();
  }

  taxData(context, data) async {
    print('call...');
    dataTax = data;
    notifyListeners();
  }

  addLaundryData(context, dynamic data, product, token) async {
    log('call... $product');
    loading = true;
    addService =
        await LaundryService.addLaundryData(context, data, product, token);
    print('call... $laundry');
    loading = false;
    notifyListeners();
  }

  viewLaundryData(context) async {
    print('call...');
    loading = true;
    laundryActive = await LaundryService.viewLaundryData(context);
    print('call... $laundry');
    loading = false;
    notifyListeners();
  }

  serviceData(context) async {
    // print('call...');
    loading = true;
    dBrate = await LaundryService.serviceLaundryData(context);
    print('call...1${dBrate}');
    loading = false;
    notifyListeners();
  }

  getprofileData(context) async {
    // print('call...');
    loading = true;
    print('call...');
    dBrate = await LaundryService.serviceLaundryData(context);
    loading = false;
    notifyListeners();
  }
}
