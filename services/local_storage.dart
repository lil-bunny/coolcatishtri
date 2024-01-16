import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishtri_db/screens/Welcome.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _Key {
  user,
}

Future<String> getTokenCustomer() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var storedName = prefs.getString(API_TOKEN_KEY) ?? '';
  // print('storedName$storedName');
  return storedName;
}

class LocalStorageService {
  SharedPreferences? _sharedPreferences;
  Future<LocalStorageService> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }

  // User? get user {
  //   final rawJson = _sharedPreferences?.getString(_Key.user.toString());
  //   if (rawJson == null) {
  //     return null;
  //   }
  //   Map<String, dynamic> map = jsonDecode(rawJson);
  //   return User.fromJson(map);
  // }

  // set user(User? value) {
  //   if (value != null) {
  //     _sharedPreferences?.setString(
  //         _Key.user.toString(), json.encode(value.toJson()));
  //   } else {
  //     _sharedPreferences?.remove(_Key.user.toString());
  //   }
  // }
}
