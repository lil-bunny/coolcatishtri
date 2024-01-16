import 'dart:ffi';
import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishtri_db/screens/Welcome.dart';
import 'package:ishtri_db/services/Constent.dart';
import 'package:http/http.dart' as http;
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/services/local_storage.dart';
import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
import 'dart:convert';

import 'package:provider/provider.dart';
import 'dart:developer' as developer;

class ApiService {
  final isDevMode = true; //if Production false
  static Future<dynamic> get(String path) async {
    print('$base_url_dev/$path');

    final response = await http.get(
      Uri.parse('$base_url_dev/$path'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      log('Request failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
      if (response.reasonPhrase == 'Unauthorized') {
        logout();
      } else {}
      throw Exception('Failed to load data');
    }
  }

  static Future<dynamic> getToken(String path) async {
    String token = await getTokenCustomer();
    print('$base_url_dev/$path');
    log('@@@ user${token}');
    final response = await http.get(
      Uri.parse('$base_url_dev/$path'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      log('Request failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
      if (response.reasonPhrase == 'Unauthorized') {
        logout();
      } else {}
      throw Exception('Failed to load data');
    }
  }

  static Future<dynamic> putData(String path, data, token) async {
    print('$base_url_dev/$path');

    final response = await http.put(
      Uri.parse('$base_url_dev/$path'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<dynamic> deleteData(String path, data) async {
    print('$base_url_dev/$path');
    String token = await getTokenCustomer();
    print(token);
    final response = await http.delete(
      Uri.parse('$base_url_dev/$path'),
      body: data,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print('response ${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<dynamic> post(String path, data) async {
    final response = await http.post(
      Uri.parse('$base_url_dev/$path'),
      body: data,
    );
    print(response.statusCode);
    if (response.statusCode == 2) {
      return json.decode(response.body);
    } else {
      // throw Exception('Failed to load data');

      log('Request failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
      if (response.reasonPhrase == 'Unauthorized') {
        logout();
      } else {}
      return json.decode(response.body);
    }
  }

  static Future<dynamic> posttoken(String path, content, data) async {
    String token = await getTokenCustomer();
    log('@@@ ${(content)}');

    var headers1;
    if (content == '') {
      headers1 = {
        'Authorization': 'Bearer $token',
      };
    } else {
      headers1 = {
        'Authorization':
            'Bearer $token', // Include the Bearer token in the headers
        'Content-Type': 'application/json',
      };
    }
    print('$base_url_dev/$path');
    // log('data $data');
    print('dev=>>>>>>');
    // developer.log('data $data');
    print('dev>>>>>>>');
    // var dataad = {"id": "9"};
    log('@@${jsonEncode(data)}');
    try {
      final response = await http.post(
        Uri.parse('$base_url_dev/$path'),
        body: data,
        headers: headers1,
      );
      print('data $response');
      if (response.statusCode == 2) {
        return json.decode(response.body);
      } else {
        // throw Exception('Failed to load data');
        return json.decode(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> postformdata(String path) async {
    final response = await http.post(Uri.parse('$base_url_dev/$path'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<dynamic> getparams(String path) async {
    final response = await http.get(Uri.parse('$base_url_dev/$path'));
    // print(response.body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<dynamic> postForm(String path, data, token) async {
    var url = Uri.parse('$base_url_dev/$path');
    print(url);
    var request = http.MultipartRequest('POST', url);

    print('response1 ${request}');
    request.headers['Authorization'] = 'Bearer ${token}';
    request.fields['id'] = data;

    final response = await request.send().then((value) => value);
    final response1 = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      print(response1.body);
      return json.decode(response1.body);
    } else if (response.statusCode == 400) {
      return json.decode(response1.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<dynamic> postUpload(String path, data, File? image) async {
    var url = Uri.parse('$base_url_dev/$path');
    log('@@ ${image?.path.split('/').last}');
    var request = http.MultipartRequest('POST', url);
    var fileStream = http.ByteStream(image!.openRead());
    var fileLength = await image.length();
    var multipartFile = http.MultipartFile('file', fileStream, fileLength,
        filename: image.path.split('/').last);
    request.files.add(multipartFile);
    log('@@! ${request}');
    request.fields['firstName'] = data['firstName'];
    request.fields['lastName'] = data['lastName'];
    request.fields['email'] = data['email'];
    request.fields['dob'] = data['dob'];
    request.fields['primary_phone_no'] = data['primary_phone_no'];
    request.fields['address'] = data['address'];
    request.fields['city'] = data['city'];
    request.fields['pincode'] = data['pincode'];

    final response = await request.send().then((value) => value);
    final response1 = await http.Response.fromStream(response);
    log('response1 ${response1.body}');
    if (response.statusCode == 200) {
      print(response1.body);
      return json.decode(response1.body);
    } else if (response.statusCode == 400) {
      return json.decode(response1.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<dynamic> postEdit(String path, data, File? image) async {
    String token = await getTokenCustomer();
    print('token1 $image');
    var url = Uri.parse('$base_url_dev/$path');
    var request = http.MultipartRequest('POST', url);

    if (image != null) {
      print('image 194 ${image?.path.split('/').last}');
      var fileStream = http.ByteStream(image!.openRead());
      var fileLength = await image.length();
      var multipartFile = http.MultipartFile('file', fileStream, fileLength,
          filename: image.path.split('/').last);
      request.files.add(multipartFile);
    }
    print('Bearer ${token}');
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['firstName'] = data['firstName'];
    request.fields['lastName'] = data['lastName'];
    request.fields['email'] = data['email'];
    request.fields['dob'] = data['dob'];
    request.fields['primary_phone_no'] = data['primary_phone_no'];
    request.fields['address'] = data['address'];
    request.fields['city'] = data['city'];
    request.fields['pincode'] = data['pincode'];

    print('response1${request}');
    final response = await request.send().then((value) => value);
    final response1 = await http.Response.fromStream(response);

    print('response1 ${response1.statusCode}');
    if (response.statusCode == 200) {
      print(response1.body);
      return json.decode(response1.body);
    } else if (response.statusCode == 400) {
      return json.decode(response1.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<dynamic> postAddLaundry(
      String path, data, dynamic product, File? image) async {
    String token = await getTokenCustomer();
    print('token1 $data');
    var url = Uri.parse('$base_url_dev/$path');
    var request = http.MultipartRequest('POST', url);

    // if (image != null) {
    print('image 194 ${image?.path.split('/').last}');
    var fileStream = http.ByteStream(image!.openRead());
    var fileLength = await image.length();
    var multipartFile = http.MultipartFile('file', fileStream, fileLength,
        filename: image.path.split('/').last);
    request.files.add(multipartFile);
    // }
    print('Bearer ${token}');
    request.headers['Authorization'] = 'Bearer $token';

    // "laundryName": laundery['laundryName'],
    // "ownerFirstName": laundery['ownerFirstName'],
    // "ownerLastName": laundery['ownerLastName'],
    // "owner_phone_no": laundery['owner_phone_no'],
    // "laundry_phone_no": laundery['laundry_phone_no'],
    // "address": laundery['address'],
    // "street": laundery['street'],
    // "city": laundery['city'],
    // "pincode": laundery['pincode'],
    // "gst_number": laundery['gst_number'],
    // "sgst": laundery['sgst'],
    // "cgst": laundery['cgst'],
    // List servi = data['service_list'];
    request.fields.addAll({
      'laundryName': data['laundryName'],
      'ownerFirstName': data['ownerFirstName'],
      'ownerLastName': data['ownerLastName'],
      'owner_phone_no': data['owner_phone_no'].toString(),
      'laundry_phone_no': data['laundry_phone_no'].toString(),
      'address': data['address'],
      'city': data['city'].toString(),
      'pincode': data['pincode'].toString(),
      'street': data['street'],
      'gst_number': data['gst_number'],
      'sgst': data['sgst'],
      'cgst': data['cgst'],
      "delivery_charge": "22",
      'service_list': jsonEncode(product),
    });
    // request.fields['pincode'] = data['pincode'];

    print('response1 ${request}');
    final response = await request.send().then((value) => value);
    final response1 = await http.Response.fromStream(response);

    print('response1 ${response1.body}');
    if (response.statusCode == 200) {
      print(response1.body);
      return json.decode(response1.body);
    } else if (response.statusCode == 400) {
      return json.decode(response1.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
  // static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> sendPostRequest(methodName, bodyParams) async {
    // log('is internet :: ${AUTH_TOKEN}');
    var token = await getTokenCustomer();
    if (!isInternetConnected) {
      throw isInternetConnected;
    } else {
      log('url ${isDevMode ? '$base_url_dev$methodName' : '$base_url_live$methodName'} ${token}');
      final response = await http.post(
        Uri.parse(isDevMode
            ? '$base_url_dev$methodName'
            : '$base_url_live$methodName'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(bodyParams),
      );
      try {
        final data = json.decode(response.body);
        if (data != null) {
          return {'data': data, 'status_code': '${response.statusCode}'};
        } else {
          return ({
            'status': 'error',
            'status_code': '${response.statusCode}',
            'error_code': 0,
            'reason': response.reasonPhrase,
            'data': {'status_code': '${response.statusCode}'},
          });
        }
      } catch (ex) {
        log('Request failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
        if (response.reasonPhrase == 'Unauthorized') {
          logout();
        } else {}
        return {
          'status': 'error',
          'status_code': '${response.statusCode}',
          'error_code': 0,
          'reason': response.reasonPhrase,
          'data': {'status_code': '${response.statusCode}'},
        };
      }
    }

    // print(
    //     'Request failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    // throw response;
  }

  Future<dynamic> sendGetRequest(methodName) async {
    var token = await getTokenCustomer();
    print('is internet :: ${token}');
    if (!isInternetConnected) {
      throw isInternetConnected;
    } else {
      log('url ${isDevMode ? '$base_url_dev$methodName' : '$base_url_live$methodName'} token:: $token');
      final response = await http.get(
        Uri.parse(isDevMode
            ? '$base_url_dev$methodName'
            : '$base_url_live$methodName'),
        headers: <String, String>{
          'Authorization': 'Bearer ${token}',
          'content-type': 'application/json'
        },
      );
      try {
        final data = json.decode(response.body);
        if (data != null) {
          return {'data': data, 'status_code': '${response.statusCode}'};
        } else {
          return ({
            'status': 'error',
            'status_code': '${response.statusCode}',
            'error_code': 0,
            'reason': response.reasonPhrase,
            'data': {'status_code': '${response.statusCode}'},
          });
        }
      } catch (ex) {
        log('Request failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
        if (response.reasonPhrase == 'Unauthorized') {
          logout();
        } else {}
        return {
          'status': 'error',
          'status_code': '${response.statusCode}',
          'error_code': 0,
          'reason': response.reasonPhrase,
          'data': {'status_code': '${response.statusCode}'},
        };
      }
    }
    // throw response;
  }
}
