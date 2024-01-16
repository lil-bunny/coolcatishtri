// import 'package:flutter/material.dart';
// import 'package:ishtri_db/models/AddHelperDb.dart';
// import 'package:ishtri_db/ApiRequest/ApiRequestPost.dart';
// import 'package:ishtri_db/models/ViewHelper.dart';
// import 'package:ishtri_db/services/Api.dart';
// import 'package:ishtri_db/statemanagemnt/HelperService.dart';

// class DBUpdateDataProvider with ChangeNotifier {
//   bool loading = false;
//   bool loading1 = false;
//   AddHelperDb? addHelperDb;
//   // Helper? helper;
//   ViewHelper? viewHelper;
//   dynamic storedName;

//   addhelperData(context, data, token) async {
//     print('call...$data');
//     loading = true;
//     addHelperDb = await HelperService.addHelperData(context, data, token);
//     print('call...$addHelperDb');
//     loading = false;
//     notifyListeners();
//   }

//   // helperData(context) async {
//   //   print('call...');
//   //   loading = true;
//   //   viewHelper = await HelperService.helperData(context);
//   //   print('call...$viewHelper');
//   //   loading = false;
//   //   notifyListeners();
//   // }

//   // viewHelperData(context, data) async {
//   //   // print('call...');
//   //   loading = true;
//   //   viewHelper = await HelperService.viewHelperData(context, data);
//   //   // print('call...$post');
//   //   loading = false;
//   //   notifyListeners();
//   // }
// }
