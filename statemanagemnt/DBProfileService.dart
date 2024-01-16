import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:ishtri_db/models/City.dart';
import 'package:ishtri_db/ApiRequest/ApiRequestPost.dart';
import 'package:ishtri_db/models/DBUpdate.dart';
import 'package:ishtri_db/models/DBdetails.dart';
import 'package:ishtri_db/models/Helper.dart';
import 'package:ishtri_db/models/Login.dart';
import 'package:ishtri_db/models/AddHelperDb.dart';
import 'package:ishtri_db/models/Signup.dart';
import 'package:ishtri_db/models/ViewHelper.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/local_storage.dart';

class DBProfileService {
  static Future<DBdetails?> viewDBData(context) async {
    DBdetails? result;
    print('call...');
    String token1 = await getTokenCustomer();
    print('token1 $token1');
    try {
      var dbpres = await ApiService.getToken('v1/delivery-boy/auth/db-details');
      result = DBdetails.fromJson(dbpres);
      print('result${dbpres}');
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<DBUpdate?> updateDbData(context, data, image) async {
    DBUpdate? result;
    print(data);
    print('call...1');
    try {
      var resPro = await ApiService.postEdit(
          'v1/delivery-boy/auth/update-db-details', data, image);
      print('result 33 ${resPro}');
      result = DBUpdate.fromJson(resPro);
    } catch (e) {
      print(e);
    }
    return result;
  }

  // static Future<ViewHelper?> viewHelperData(context, data) async {
  //   ViewHelper? result;
  //   print('call...1');
  //   try {
  //     var resPro = await ApiService.post('user/helper-details', data);
  //     print('result resPro${resPro}');
  //     result = ViewHelper.fromJson(resPro);
  //   } catch (e) {
  //     print(e);
  //   }
  //   return result;
  // }

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
