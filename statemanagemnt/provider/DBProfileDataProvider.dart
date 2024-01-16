import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ishtri_db/models/City.dart';
import 'package:ishtri_db/ApiRequest/ApiRequestPost.dart';
import 'package:ishtri_db/models/DBUpdate.dart';
import 'package:ishtri_db/models/DBdetails.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/statemanagemnt/DBProfileService.dart';
import 'package:ishtri_db/statemanagemnt/SignupService.dart';

class DBProfileDataProvider with ChangeNotifier {
  bool loading = false;
  DBdetails? dBdetails;
  DBUpdate? dbUpdate;

  profileData(context) async {
    loading = true;
    dBdetails = await DBProfileService.viewDBData(context);
    print('call...1${dBdetails}');
    loading = false;
    notifyListeners();
  }

  updateData(context, data, image) async {
    loading = true;
    dbUpdate = await DBProfileService.updateDbData(context, data, image);
    print('call...1 ${dbUpdate?.data![0]}');
    loading = false;
    notifyListeners();
  }
}
