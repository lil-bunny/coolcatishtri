import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ishtri_db/models/City.dart';
import 'package:ishtri_db/ApiRequest/ApiRequestPost.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/statemanagemnt/SignupService.dart';

class AddLaundryDataProvider with ChangeNotifier {
  bool loading = false;
  City? city;

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

  serviceData(context, data) async {
    // print('call...');
    loading = true;
    city = await Services.fetchData(context, data);
    print('call...1${city}');
    loading = false;
    notifyListeners();
  }
}
