import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ishtri_db/models/AddService.dart';
import 'package:ishtri_db/models/City.dart';
import 'package:ishtri_db/ApiRequest/ApiRequestPost.dart';
import 'package:ishtri_db/models/DBrate.dart';
import 'package:ishtri_db/models/Helper.dart';
import 'package:ishtri_db/models/Laundry.dart';
import 'package:ishtri_db/models/LaundryActive.dart';
import 'package:ishtri_db/models/Login.dart';
import 'package:ishtri_db/models/AddHelperDb.dart';
import 'package:ishtri_db/models/Signup.dart';
import 'package:ishtri_db/models/ViewHelper.dart';
import 'package:ishtri_db/services/Api.dart';

class LaundryService {
  static Future<AddService?> addLaundryData(
      context, dynamic data, product, image) async {
    AddService? result;
    print('call...$product');
    // var isLoading = true;
    try {
      var cityres = await ApiService.postAddLaundry(
          'v1/delivery-boy/laundry-service/add-laundry-service',
          data,
          product,
          image);
      result = AddService.fromJson(cityres);
      print('result${cityres}');
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<Helper?> laundryData(context) async {
    Helper? result;

    print('call...1');
    try {
      var resPro = await ApiService.getToken(
          'v1/delivery-boy/laundry-service/helper-list');
      print('result 33 ${resPro}');
      result = Helper.fromJson(resPro);
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<LaundryActive?> viewLaundryData(context) async {
    LaundryActive? result;
    print('call...1');
    try {
      var resPro = await ApiService.getToken(
          'v1/delivery-boy/laundry-service/laundry-list');
      log('result resPro ${resPro}');
      result = LaundryActive.fromJson(resPro);
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<DBrate?> serviceLaundryData(context) async {
    DBrate? result;
    print('call...1');
    try {
      var resPro = await ApiService.getToken(
          'v1/delivery-boy/laundry-service/get-laundry-default-rate');
      print('result resPro ${resPro}');
      result = DBrate.fromJson(resPro);
    } catch (e) {
      print(e);
    }
    return result;
  }

  // static Future<Otp?> helperProfileData(context, data) async {
  //   Otp? result;
  //   print('call...1');
  //   try {
  //     var resPro = await ApiService.post('user/confirm-otp', data);
  //     print('result ${resPro}');
  //     result = Otp.fromJson(resPro);
  //   } catch (e) {
  //     print(e);
  //   }
  //   return result;
  // }
}
