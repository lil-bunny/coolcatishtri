import 'package:flutter/material.dart';
import 'package:ishtri_db/models/Data.dart';
import 'package:ishtri_db/ApiRequest/ApiRequestPost.dart';
import 'package:ishtri_db/services/Api.dart';

class PostDataProvider with ChangeNotifier {
  bool loading = false;
  Data post = Data();

  Future<Data> fetchData(context) async {
    Data result = Data();
    print('call...');
    var isLoading = true;
    try {
      ApiService.getparams('?page=`${1}').then((data) {
        result = Data.fromJson(data);
        print('result${result.firstName}');
      }).catchError((error) {
        // Handle error
      }).whenComplete(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
    return result;
  }

  getPostData(context) async {
    // print('call...');
    loading = true;
    post = await fetchData(context);
    print('call...$post');
    loading = false;
    notifyListeners();
  }
}
