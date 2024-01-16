import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ishtri_db/main.dart';
import 'package:ishtri_db/screens/Orders.dart';
import 'package:ishtri_db/screens/Welcome.dart';
import 'package:ishtri_db/screens/auth/WelcomeSignup.dart';
import 'package:ishtri_db/services/Constent.dart';
import 'package:flutter/material.dart';
import 'package:ishtri_db/services/global.dart';
import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_info_plus/device_info_plus.dart';

const String API_TOKEN_KEY = 'api_token';
const String USER_LOGIN_KEY = 'user_login_det';
const String IS_NEW_USER_FLAG = 'is_new_user';
dynamic subscription;
BuildContext? _context;
//show loader by context
void showLoader(context) {
  MyApp.showLoader(context, true, '');
  _context = context;
  //DialogHelper.showLoading('Please Wait...');
}

//hide loader by context
void hideLoader(context) {
  try {
    MyApp.showLoader(context, false, '');
    //DialogHelper.hideLoading();
  } catch (ex) {}
}

FirebaseMessaging messaging = FirebaseMessaging.instance;
Future<String?> getFirebaseToken() async {
  try {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    String? token = await messaging.getToken() ?? '';
    log("Device Token: $token");
    return token;
  } catch (e) {
    log('@@@ ${e}');
  }
  return null;
}

void registerNotification() async {
  late final FirebaseMessaging _messaging;
  // 1. Initialize the Firebase app
  await Firebase.initializeApp();

  // 2. Instantiate Firebase Messaging
  _messaging = FirebaseMessaging.instance;

  // 3. On iOS, this helps to take the user permissions
  NotificationSettings settings = await _messaging.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
    // TODO: handle the received notifications
  } else {
    print('User declined or has not accepted permission');
  }
}

var _intLoad;
showInternetLoading(msg) {
  _intLoad = showSimpleNotification(
    Center(child: Text(msg)),
    background: Colors.red,
    autoDismiss: false,
    position: NotificationPosition.top,
    contentPadding: EdgeInsets.only(top: 0),
  );
  // EasyLoading.show(status: '');
  isInternetConnected = false;
  // DialogHelper.showLoading(msg);
  //_entry.dismiss();
}

//hide loader using getX dialog helper
var _firstLoad = true;
hideInternetLoading(msg) {
  isInternetConnected = true;
  if (_intLoad != null) {
    _intLoad.dismiss();
    if (!_firstLoad) {
      showSimpleNotification(Center(child: Text(msg)),
          background: Colors.green,
          duration: Duration(milliseconds: 3000),
          contentPadding: EdgeInsets.all(0));
    } else {
      _firstLoad = false;
    }

    //DialogHelper.hideLoading();
    // EasyLoading.dismiss();
  }
}

//Set  User api token for future purpose
Future<String> setApiToken(String token) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(API_TOKEN_KEY, token);
  print('token set ${token}');
  return token;
}

//Get  User api token form local
Future<String> getApiToken() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String token = _prefs.getString(API_TOKEN_KEY) ?? "";
  return token;
}

String capitalizeEachWord(String text) {
  String capText = '';
  String temp = '';
  List<dynamic> words = text.split(' ');

  for (int i = 0; i < words.length; i++) {
    if (words[i].isNotEmpty) {
      words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      capText = words[i][0].toUpperCase() + words[i].substring(1);
    }
    temp = temp + ' ' + capText;
  }
  return words.join(' ');
}

checkInternetStatus() async {
  bool isNetwork;
  subscription = Connectivity()
      .onConnectivityChanged
      .listen((ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      log('no int Stat@@@ $result');
      showInternetLoading('You are offline');
      isNetwork = false;
    } else {
      //if (!firstLoad){
      log('active int@@@ $result');
      hideInternetLoading("Back to online");
      isNetwork = true;
      // }
    }
    print('connect status result :: ${result}');
  });
}

toast(String name) {
  return Fluttertoast.showToast(
    msg: name,
    // toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black,
    textColor: Colors.white,
  );
}

Future<void> logout() async {
  Navigator.of(_context!).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const WelcomeSignup()),
      (Route route) => false);

  await Provider.of<SignupDataProvider>(_context!, listen: false).logout();
}

Future<bool?> showConfirmPopup(
    context, heading, title, textOK, textCancel) async {
  Widget okButton = InkWell(
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: themeBlueColor),
        borderRadius: BorderRadius.all(
            Radius.circular(5.0) //                 <--- border radius here
            ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 7.0),
        child: Text(
          textOK,
          style: TextStyle(color: themeBlueColor, fontSize: 18.0),
        ),
      ),
    ),
    onTap: () {
      Navigator.of(context).pop(true);
      // true here means you clicked ok
    },
  );
  Widget cancelButton = InkWell(
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: redColor,
        ),
        color: redColor,
        borderRadius: BorderRadius.all(
            Radius.circular(5.0) //                 <--- border radius here
            ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 35.0, right: 35.0, top: 8.0, bottom: 7.0),
        child: Container(
          child: Text(
            textCancel,
            style: TextStyle(color: whiteColor, fontSize: 18.0),
          ),
        ),
      ),
    ),
    onTap: () {
      Navigator.of(context).pop(false);
      // false here means you clicked cancel
    },
  );

  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: whiteColor,
        elevation: 5,
        actionsAlignment: MainAxisAlignment.center,
        scrollable: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(heading),
        content: Text(title),
        actions: [
          okButton,
          cancelButton,
        ],
      );
    },
  );
}

Future<Object?> getId() async {
  log('heloo world');
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    log('@@@ ${androidDeviceInfo.androidId}');
    return androidDeviceInfo.androidId; // unique ID on Android
  }
  return false;
}

bool validatePhoneNumber(String phoneNumber) {
  // Define a regex pattern for a typical international phone number
  // You may need to adjust this pattern based on your specific validation requirements
  String pattern = r'^[0-9]{10}$';

  // Create a RegExp object
  final RegExp regex = RegExp(pattern);
  log('@@@ ${phoneNumber}${regex.hasMatch(phoneNumber)}');
  // Test the input against the regex pattern
  return regex.hasMatch(phoneNumber);
}

bool validateStringWithoutNumbers(String input) {
  // Define a regex pattern to match strings without numbers
  String pattern = r'^[^\d]+$';

  // Create a RegExp object
  RegExp regex = RegExp(pattern);

  // Test the input against the regex pattern
  return regex.hasMatch(input);
}

bool validatePincode(String pincode) {
  // Define a regex pattern for a typical international phone number
  // You may need to adjust this pattern based on your specific validation requirements
  String pattern = r'^[0-9]{6}$';

  // Create a RegExp object
  final RegExp regex = RegExp(pattern);
  log('@@@ 28 ${pincode}${regex.hasMatch(pincode)}');
  // Test the input against the regex pattern
  return regex.hasMatch(pincode);
}

Future navigateScreen() async {
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    log('Got a message whilst in the opened app!');
    log('Message data 122: ${message.data.containsValue('order_accept')}');
    Map<String, dynamic> data = message.data;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (data.containsValue('order_ready')) {
        log('nmbvncxvxc');
        Future.delayed(const Duration(milliseconds: 2900), () async {
          // Navigator.pushNamed(context, '/screens/Orders');
          try {
            Navigator.push(
                _context!, MaterialPageRoute(builder: (context) => Orders()));
          } catch (e) {}
        });
      } else if (data.containsValue('order_pickup_request')) {
        Future.delayed(const Duration(milliseconds: 2900), () async {
          try {
            Navigator.push(
                _context!, MaterialPageRoute(builder: (context) => Orders()));
          } catch (e) {}
        });
      } else if (data.containsValue('service_fee_request')) {
        // Navigator.pushNamed(_context!, '/screens/Orders');
      } else if (data.containsValue('rating')) {
        Navigator.pushNamed(_context!, '/screens/DeliveryBoyProfile');
      } else if (data.containsValue('payment')) {
        Navigator.pushNamed(_context!, '/screens/Orders');
      } else if (data.containsValue('onboarding_request')) {
        Navigator.pushNamed(_context!, '/screens/Customers');
      }
    });
  });
  return true;
}

Future<bool?> showErrorPopup(context, heading, title) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      Widget okButton = InkWell(
        child: Text("OK"),
        onTap: () {
          Navigator.pop(context);
        },
      );

      return Dialog(
        backgroundColor: whiteColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Stack(children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 20.0,
              ),
              Center(
                  child: Text(
                heading,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              )),
              SizedBox(
                height: 20.0,
              ),
              Center(
                  child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                ),
              )),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: Colors.black),
                ),
              ),
            ),
          ),
        ]),
      );
    },
  );
}
