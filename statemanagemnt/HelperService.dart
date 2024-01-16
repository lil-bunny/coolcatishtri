import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ishtri_db/models/City.dart';
import 'package:ishtri_db/ApiRequest/ApiRequestPost.dart';
import 'package:ishtri_db/models/Helper.dart';
import 'package:ishtri_db/models/Login.dart';
import 'package:ishtri_db/models/AddHelperDb.dart';
import 'package:ishtri_db/models/Signup.dart';
import 'package:ishtri_db/models/ViewHelper.dart';
import 'package:ishtri_db/services/Api.dart';

class HelperService {
  static Future<AddHelperDb?> addHelperData(context, data, token) async {
    AddHelperDb? result;
    print('call...');
    // var isLoading = true;
    try {
      var cityres = await ApiService.posttoken(
          'v1/delivery-boy/helper/add-helper', "", data);
      result = AddHelperDb.fromJson(cityres);
      print('result${cityres}');
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<Helper?> helperData(context) async {
    Helper? result;

    print('call...1');
    try {
      var resPro =
          await ApiService.getToken('v1/delivery-boy/helper/helper-list');
      print('result 33 ${resPro}');
      result = Helper.fromJson(resPro);
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<ViewHelper?> viewHelperData(context, data, headers) async {
    ViewHelper? result;
    print('call...1');
    try {
      var resPro = await ApiService.posttoken(
          'v1/delivery-boy/helper/helper-details', "", data);
      print('result resPro ${resPro}');
      result = ViewHelper.fromJson(resPro);
    } catch (e) {
      print(e);
    }
    return result;
  }

  // static Future<Otp?> loginOtpData(context, data) async {
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
