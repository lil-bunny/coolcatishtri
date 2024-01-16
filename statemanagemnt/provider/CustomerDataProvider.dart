import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ishtri_db/models/City.dart';
import 'package:ishtri_db/ApiRequest/ApiRequestPost.dart';
import 'package:ishtri_db/models/Customer.dart';
import 'package:ishtri_db/models/CustomerDetails.dart';
import 'package:ishtri_db/models/CustomerView.dart';
import 'package:ishtri_db/models/DBDeleteUser.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/statemanagemnt/CustomerService.dart';
import 'package:ishtri_db/statemanagemnt/SignupService.dart';

class CustomerDataProvider with ChangeNotifier {
  bool loading = false;
  Customer? customer;
  CustomerView? customerView;
  DBDeleteUser? dbDeleteUser;
  CustomerDetails? customerDetails;
  var location = '';
  var customer_id = '';

  addCustomerData(context, dynamic data, token) async {
    print('call... $data');
    loading = true;
    customer = await CustomerService.addCustomerData(context, data, token);
    print('call...1${customer}');
    loading = false;
    notifyListeners();
  }

  customerData(context) async {
    loading = true;
    print('data');
    customerView = await CustomerService.customerData(context);
    print('call...1 ${customerView}');
    loading = false;
    notifyListeners();
  }

  viewCustomerData(context, data) async {
    loading = true;
    print('data');
    customerDetails = await CustomerService.viewcustomerData(context, data);
    print('call...1 ${customerDetails}');
    loading = false;
    notifyListeners();
  }

  deletecustomerData(context, data) async {
    loading = true;
    print('data $data');
    dbDeleteUser = await CustomerService.deleteCSData(context, data);
    print('call...1 ${dbDeleteUser}');
    loading = false;
    notifyListeners();
  }

  locationShareGet(context, String value) async {
    print('call... ');
    location = value;

    print('call...1 ${location}');
    notifyListeners();
  }
}
