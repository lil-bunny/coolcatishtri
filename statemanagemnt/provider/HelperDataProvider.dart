import 'package:flutter/material.dart';
import 'package:ishtri_db/models/AddHelperDb.dart';
import 'package:ishtri_db/ApiRequest/ApiRequestPost.dart';
import 'package:ishtri_db/models/Helper.dart';
import 'package:ishtri_db/models/ViewHelper.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/Constent.dart';
import 'package:ishtri_db/statemanagemnt/HelperService.dart';
import 'package:http/http.dart' as http;

// enum Provider {
//   helperid,
// }

class HelperDataProvider with ChangeNotifier {
  bool loading = false;
  bool loading1 = false;
  AddHelperDb? addHelperDb;
  Helper? helper;
  ViewHelper? viewHelper;
  dynamic storedName;
  var helper_id = " ";
  // Provider get helperid => helper_id;
  HelperDataProvider() {}
  addhelperData(context, data, token) async {
    print('call...$data');
    loading = true;
    addHelperDb = await HelperService.addHelperData(context, data, token);
    print('call...$addHelperDb');
    loading = false;
    notifyListeners();
  }

  helperData(context) async {
    print('call...');
    loading = true;
    helper = await HelperService.helperData(context);
    // print('call...  $helper');
    loading = false;
    notifyListeners();
  }

  viewHelperData(context, data, token) async {
    print('call... 44$data');
    loading = true;
    try {
      // var path = 'user/helper-details';
      // final response = await http.post(
      //   Uri.parse('$base_url_dev/$path'),
      //   body: data,
      //   headers: token,
      // );

      viewHelper = await HelperService.viewHelperData(context, data, token);
      print('call... 46 $viewHelper');
    } catch (e) {
      print((e));
    }
    loading = false;
    notifyListeners();
  }

  helperId(context, var data) {
    print('call... $data');
    helper_id = data;
    print(helper_id);

    notifyListeners();
  }
}
