// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:ishtri_db/models/City.dart';
// import 'package:ishtri_db/ApiRequest/ApiRequestPost.dart';
// import 'package:ishtri_db/models/Customer.dart';
// import 'package:ishtri_db/models/CustomerView.dart';
// import 'package:ishtri_db/services/Api.dart';
// import 'package:ishtri_db/statemanagemnt/CustomerService.dart';
// import 'package:ishtri_db/statemanagemnt/SignupService.dart';

// class DBDataProvider with ChangeNotifier {
//   bool loading = false;
//   Customer? customer;
//   CustomerView? customerView;
//   var location = '';

//   addCustomerData(context, dynamic data, token) async {
//     print('call... $data');
//     loading = true;
//     customer = await CustomerService.addCustomerData(context, data, token);
//     print('call...1${customer}');
//     loading = false;
//     notifyListeners();
//   }

//   customerData(context, data) async {
//     loading = true;
//     print('data $data');
//     customerView = await CustomerService.customerData(context, data);
//     print('call...1 ${customerView}');
//     loading = false;
//     notifyListeners();
//   }

//   locationShareGet(context, String value) async {
//     print('call... ');
//     location = value;

//     print('call...1 ${location}');
//     notifyListeners();
//   }
// }
