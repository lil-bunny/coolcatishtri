import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ishtri_db/models/City.dart';
import 'package:ishtri_db/ApiRequest/ApiRequestPost.dart';
import 'package:ishtri_db/models/Login.dart';
import 'package:ishtri_db/models/Otp.dart';
import 'package:ishtri_db/models/Signup.dart';
import 'package:ishtri_db/models/State.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/statemanagemnt/SignupService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupDataProvider with ChangeNotifier {
  bool loading = true;
  bool loading1 = false;
  City? city;
  Registration? registration;
  Login? login;
  Otp? otp;
  States? state;
  dynamic ph_number;
  var storedName = '';
  SignupDataProvider() {
    // localStorageGet();
  }
  getDataCity(context, data) async {
    // print('call...');
    loading = true;
    city = await Services.fetchData(context, data);
    print('call...1${city}');
    loading = false;
    notifyListeners();
  }

  getDataState(context) async {
    loading = true;
    state = await Services.fetchDataState(context);
    print('call...1${city}');
    loading = false;
    notifyListeners();
  }

  postSignupData(context, data, File? image) async {
    print('call... $data');
    loading = true;
    registration = await Services.postData(context, data, image);
    loading = false;
    print('call...56 ${registration?.data?.length}');
    notifyListeners();
  }

  postLoginData(context, dynamic data) async {
    print('call... login $data');
    ph_number = data['phone_no'];
    loading = true;
    login = await Services.loginPhoneNumberData(context, data);
    loading = false;

    print('loginPhoneNumberData...1 ${login?.data}');

    notifyListeners();
  }

  postOtpData(context, data) async {
    print('call... $data');
    loading = true;
    otp = await Services.loginOtpData(context, data);
    loading = false;
    print('call...1 ${otp?.data?[0].token}');
    notifyListeners();
  }

  localStorageSave(context, data) async {
    print('call... $data');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(API_TOKEN_KEY, data);

    notifyListeners();
  }

  localStorageGet(context) async {
    print('call... ');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    storedName = prefs.getString('token') ?? '';

    // print('call...local ${storedName.toString().isEmpty}');
    notifyListeners();
  }

  logout() async {
    print('call... ');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(API_TOKEN_KEY, '');
    storedName = '';
    notifyListeners();
  }
}
