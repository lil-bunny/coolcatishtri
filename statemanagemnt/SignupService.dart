import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ishtri_db/models/City.dart';
import 'package:ishtri_db/ApiRequest/ApiRequestPost.dart';
import 'package:ishtri_db/models/Login.dart';
import 'package:ishtri_db/models/Otp.dart';
import 'package:ishtri_db/models/Signup.dart';
import 'package:ishtri_db/models/State.dart';
import 'package:ishtri_db/services/Api.dart';

class Services {
  static Future<City?> fetchData(context, data) async {
    City? result;
    print('call...');
    // var isLoading = true;
    try {
      var cityres =
          await ApiService.post('v1/delivery-boy/auth/city-list', data);
      result = City.fromJson(cityres);
      print('result${cityres}');
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<States?> fetchDataState(context) async {
    States? result;
    print('call...');
    try {
      var cityres = await ApiService.get('v1/delivery-boy/auth/state-list');
      result = States.fromJson(cityres);
      print('result${cityres}');
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<Registration?> postData(context, data, File? image) async {
    Registration? result;
    print('call...1');
    // var isLoading = true;
    try {
      var resPro = await ApiService.postUpload(
          'v1/delivery-boy/auth/create-user', data, image);
      print('result 33 ${resPro}');
      result = Registration.fromJson(resPro);
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<Login?> loginPhoneNumberData(context, data) async {
    Login? result;
    print('call...1');
    try {
      var resPro = await ApiService.post('v1/delivery-boy/auth/db-login', data);
      print('result resPro${resPro}');
      result = Login.fromJson(resPro);
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<Otp?> loginOtpData(context, data) async {
    Otp? result;
    print('call...1');
    try {
      var resPro = await ApiService.post('user/confirm-otp', data);
      print('result ${resPro}');
      result = Otp.fromJson(resPro);
    } catch (e) {
      print(e);
    }
    return result;
  }
}
