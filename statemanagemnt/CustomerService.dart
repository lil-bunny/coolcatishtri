import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ishtri_db/models/City.dart';
import 'package:ishtri_db/ApiRequest/ApiRequestPost.dart';
import 'package:ishtri_db/models/Customer.dart';
import 'package:ishtri_db/models/CustomerDetails.dart';
import 'package:ishtri_db/models/CustomerView.dart';
import 'package:ishtri_db/models/DBDeleteUser.dart';
import 'package:ishtri_db/models/Helper.dart';
import 'package:ishtri_db/models/Login.dart';
import 'package:ishtri_db/models/AddHelperDb.dart';
import 'package:ishtri_db/models/Signup.dart';
import 'package:ishtri_db/models/ViewHelper.dart';
import 'package:ishtri_db/services/Api.dart';

class CustomerService {
  static Future<Customer?> addCustomerData(context, data, token) async {
    Customer? result;

    print('call... 222$data');
    try {
      var cityres = await ApiService.posttoken(
          'v1/delivery-boy/customer/add-customer', "", data);
      print('result ${cityres}');
      result = Customer.fromJson(cityres);
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<CustomerView?> customerData(context) async {
    CustomerView? result;
    try {
      var resPro =
          await ApiService.getToken('v1/delivery-boy/customer/customer-list');
      print('result 33 ${resPro}');
      result = CustomerView.fromJson(resPro);
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<CustomerDetails?> viewcustomerData(context, data) async {
    CustomerDetails? result;
    var token = '';
    try {
      var resPro = await ApiService.getToken(
          'v1/delivery-boy/customer/customer-details/${data}');
      print('result 33 ${resPro}');
      result = CustomerDetails.fromJson(resPro);
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<ViewHelper?> viewHelperData(context, data) async {
    ViewHelper? result;
    print('call...1');
    try {
      var resPro = await ApiService.post('user/helper-details', data);
      print('result resPro${resPro}');
      result = ViewHelper.fromJson(resPro);
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<DBDeleteUser?> deleteCSData(context, data) async {
    DBDeleteUser? result;
    print('call...1 $data');
    try {
      var resPro = await ApiService.deleteData(
          'v1/delivery-boy/customer/delete-user', data);
      print('result resPro ${resPro}');
      result = DBDeleteUser.fromJson(resPro);
    } catch (e) {
      print(e);
    }
    return result;
  }
}
