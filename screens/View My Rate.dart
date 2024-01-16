import 'dart:collection';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/statemanagemnt/provider/LaundryDataProvider.dart';
import 'package:provider/provider.dart';
import '../../widgets/question.dart';
import '../../widgets/CustomText.dart';
import '../models/Data.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ViewMyRate extends StatefulWidget {
  const ViewMyRate({super.key});

  @override
  State<ViewMyRate> createState() => _ViewMyRateState();
}

class _ViewMyRateState extends State<ViewMyRate> {
  bool isChecked = false;
  dynamic delivery = [];
  dynamic gender = [];
  dynamic product = [];
  dynamic product1 = [];
  Set<String> uniqueId = HashSet<String>();
  Set<String> uniqueId1 = HashSet<String>();
  Set<String> uniqueIdProduct = HashSet<String>();
  dynamic duplicates = [];
  dynamic duplicates1 = [];
  dynamic duplicatesProduct = [];
  dynamic product_view = [];
  String currentindex = '0';
  String currentindexgen = '0';
  dynamic delivery_charges = '';
  String baseImage = '';
  String baseImageProduct = '';
  var cate_id = '', id = '';
  bool isHome = false;
  int page = 1, count = 10;
  dynamic? routes;
  late ScrollController _controller = ScrollController();
  TextEditingController _txtinput = TextEditingController();
  ScrollController _parentController = ScrollController();
  ScrollController _childController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // print("Hello");
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        print(_controller.position.pixels);
      }
    });
    Future.delayed(Duration(seconds: 1), () {
      _category_list();
    });
    Future.delayed(Duration(seconds: 2), () {
      _subcategory_list();
    });
    Future.delayed(Duration(seconds: 3), () {
      _product_list_added();
    });
    _childController.addListener(() {
      if (_childController.position.extentAfter == 0) {
        _parentController.jumpTo(_parentController.position.maxScrollExtent);
      } else {
        if (_childController.position.pixels < 0) {
          _parentController.jumpTo(
            _parentController.offset + _childController.position.pixels,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    // _controller.removeListener(_loadMore);
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  _category_list() async {
    setState(() {
      delivery = [];
    });
    try {
      Future.delayed(Duration(microseconds: 700), () {
        showLoader(context);
      });
      String data1 = '';
      data1 = 'page=${page}' + '&' + 'limit=${count}';
      final data = await ApiService()
          .sendGetRequest('/v1/delivery-boy/product/category-list?${data1}');
      if (kDebugMode) {
        print(data);
      }
      hideLoader(context);
      var arr = [];
      var arr1 = [], arr2 = [], arr3 = [];
      log('@@${data['data']['data']}');
      setState(() {});
      if (data?['data']['status'] == 1) {
        int size = data['data']['data']?.length;
        log('@@ 144 ${size}');
        baseImage = data['data']['image_path'];
        for (int? i = 0; i! < size!; i++) {
          arr.add({
            "id": data['data']['data'][i]['id'],
            "name": data['data']['data'][i]['category_name'],
            "image": data['data']['data'][i]['new_category_image_name'],
            "isSelect": false,
          });
        }
        log('104 ${data['data']['data'][0]?['id']}');
        setState(() {
          delivery = arr;
          cate_id = data['data']['data'][0]['id'].toString();
        });
      } else {
        log("error!");
      }
    } catch (ex) {
      if (kDebugMode) {
        print('x');
      }
      if (kDebugMode) {
        print(ex);
      }
      Future.delayed(const Duration(milliseconds: 200), () {
        hideLoader(context);
      });
    } catch (e) {}
  }

  _subcategory_list() async {
    setState(() {
      gender = [];
    });
    try {
      Future.delayed(Duration(microseconds: 700), () {
        showLoader(context);
      });
      String data1 = '';
      data1 = 'page=${page}' + '&' + 'limit=${count}';
      final data = await ApiService().sendGetRequest(
          '/v1/delivery-boy/product/sub-category-list?${data1}');
      if (kDebugMode) {
        print(data);
      }
      hideLoader(context);
      var arr = [];
      var arr1 = [], arr2 = [], arr3 = [];
      log('@@${data['data']['data']}');
      if (data?['data']['status'] == 1) {
        int size = data['data']['data']?.length;
        log('@@ 144 ${size}');
        for (int? i = 0; i! < size!; i++) {
          log('@@ 57 ${data['data']['data'][i]}');
          arr.add({
            "id": data['data']['data'][i]['id'],
            "sub_category_name":
                data['data']['data'][i]['sub_category_name'].toString(),
            "isSelect": false,
          });
        }
        setState(() {
          gender = arr;
          id = data['data']['data'][0]['id'].toString();
        });
      } else {
        log("error!");
      }
    } catch (ex) {
      if (kDebugMode) {
        print('x');
      }
      if (kDebugMode) {
        print(ex);
      }
      Future.delayed(const Duration(milliseconds: 200), () {
        hideLoader(context);
      });
    } catch (e) {}
  }

  _product_list() async {
    var arr = [];
    var arr1 = [], arr2 = [], arr3 = [];
    var arredit = [];
    Map<int, int> uniqueProductRates = {};

    Set<int> uniqueIds = {};
    List<Map<String, dynamic>> newArray = [];
    Map<int, int> uniqueRates = {};
    List<Map<String, dynamic>> resultArray = [];
    Map<String, dynamic> idMap = {};

    log('@@ ${id}');
    setState(() {
      product = [];
      product1 = [];
      arr = [];
      arr1 = [];
      arr2 = [];
      duplicates1 = [];
      newArray = [];
      resultArray = [];
    });
    uniqueId1.clear();
    try {
      Future.delayed(Duration(microseconds: 700), () {
        showLoader(context);
      });
      String data1 = '';
      data1 = 'category_id=' +
          cate_id.toString() +
          '&' +
          'sub_category_id=' +
          id.toString();
      final data = await ApiService()
          .sendGetRequest('/v1/delivery-boy/product/product-list?${data1}');
      if (kDebugMode) {
        print(data);
      }
      hideLoader(context);
      log('@@ 2 ${data['data']['data']}');

      if (data?['data']['status'] == 1) {
        int size = data['data']['data']?.length;
        int size1 = product_view?.length;
        if (product_view.length > 0) {
          // log('@@ 209 service ${size}');
          // log('@@ 214 edit ${size1}');
          // product_view.removeAt(1);
          // log('remove ${product_view}');
          if (product_view.length >= size) {
            for (dynamic obj in data['data']['data']) {
              for (dynamic objRes in product_view) {
                if (obj['id'] == objRes['product_id']) {
                  if (uniqueId1.add(objRes['product_id'].toString())) {}
                  duplicates1.add({
                    "product_id": objRes['product_id'].toString(),
                    "id": objRes['id'],
                    "rate": objRes['rate'].toString(),
                  });
                  arr.add({
                    "id": objRes['product_id'],
                    "name": obj['product_name'],
                    "image": obj['new_product_image_name'],
                    "rate": objRes['rate'],
                  });
                } else {
                  log('@@@ check uniqueId1 ${uniqueId1.length}');
                  if (uniqueId1.add(obj['id'].toString())) {}
                  duplicates1.add({
                    "product_id": obj['id'].toString(),
                    "rate": '0',
                  });
                  arr.add({
                    "id": obj['id'],
                    "name": obj['product_name'],
                    "image": obj['new_product_image_name'],
                    "rate": "0",
                  });
                }
              }
            }

            for (var i = 0; i < duplicates1.length; i++) {
              if (duplicates1[i]['rate'] != '0') {
                // log('@@ vlc${duplicates1[i]}');
                // log('@@@ product${duplicates1[i]}');
                arr1.add(duplicates1[i]);
              }
            }
            log('<<<<<<======>>>>>>');
            Map<String, int> resultMap = {};
            for (var item in duplicates1) {
              String productId = item["product_id"];
              // String id = item["id"] ?? '';
              int rate = int.tryParse(item["rate"]) ?? 0;

              if (!resultMap.containsKey(productId) ||
                  rate > resultMap[productId]!) {
                resultMap[productId] = rate;
              }
            }
            List<Map<String, String>> finalResult = resultMap.entries
                .map((entry) =>
                    {"product_id": entry.key, "rate": entry.value.toString()})
                .toList();
            log('@@ res${resultMap}');

            resultMap.forEach((productId, rate) {
              resultArray.add({"product_id": productId, "rate": rate});
            });

            log('@@ ${resultArray}');
            log('@@ ${duplicates1}');
            for (var item in duplicates1) {
              int rate = int.parse(item["rate"]);
              if (rate > 0) {
                String productId = item["product_id"].toString();
                idMap[productId] = item["id"];
              }
            }

            // Add the "id" field to the first array where "rate" is greater than 0
            for (var item in resultArray) {
              int rate = item["rate"];
              String productId = item["product_id"].toString();
              if (rate > 0 && idMap.containsKey(productId)) {
                item["id"] = idMap[productId];
              }
            }

            log('@@ ${resultArray}');
            // log('@@ ${arr}');

            for (var item in resultArray) {
              int productId = int.parse(item["product_id"]);
              if (item["rate"] > 0 && !uniqueIds.contains(productId)) {
                uniqueIds.add(productId);

                // Find the matching item in the second array by 'id'
                var matchingItem = arr.firstWhere(
                    (element) => element["id"] == productId,
                    orElse: () => null);

                if (matchingItem != null) {
                  // Merge data from the first and second arrays
                  Map<String, dynamic> mergedData = {...matchingItem, ...item};
                  newArray.add(mergedData);
                }
              } else {
                uniqueIds.add(productId);

                // Find the matching item in the second array by 'id'
                var matchingItem = arr.firstWhere(
                    (element) => element["id"] == productId,
                    orElse: () => null);

                if (matchingItem != null) {
                  // Merge data from the first and second arrays
                  Map<String, dynamic> mergedData = {...matchingItem, ...item};
                  newArray.add(mergedData);
                }
              }
            }
            log('@@ newArray${newArray}');
          } else {
            for (dynamic obj in data['data']['data']) {
              for (dynamic objRes in product_view) {
                if (obj['id'] == objRes['product_id']) {
                  if (uniqueId1.add(objRes['product_id'].toString())) {}
                  duplicates1.add({
                    "product_id": objRes['product_id'].toString(),
                    "id": objRes['id'],
                    "rate": objRes['rate'].toString(),
                  });
                  arr.add({
                    "id": objRes['product_id'],
                    "name": obj['product_name'],
                    "image": obj['new_product_image_name'],
                    "rate": objRes['rate'],
                  });
                } else {
                  log('@@@ check uniqueId1 ${uniqueId1.length}');
                  if (uniqueId1.add(obj['id'].toString())) {}
                  duplicates1.add({
                    "product_id": obj['id'].toString(),
                    "rate": '0',
                  });
                  arr.add({
                    "id": obj['id'],
                    "name": obj['product_name'],
                    "image": obj['new_product_image_name'],
                    "rate": "0",
                  });
                }
              }
            }

            for (var i = 0; i < duplicates1.length; i++) {
              if (duplicates1[i]['rate'] != '0') {
                // log('@@ vlc${duplicates1[i]}');
                // log('@@@ product${duplicates1[i]}');
                arr1.add(duplicates1[i]);
              }
            }
            log('<<<<<<======>>>>>>');
            Map<String, int> resultMap = {};
            for (var item in duplicates1) {
              String productId = item["product_id"];
              // String id = item["id"] ?? '';
              int rate = int.tryParse(item["rate"]) ?? 0;

              if (!resultMap.containsKey(productId) ||
                  rate > resultMap[productId]!) {
                resultMap[productId] = rate;
              }
            }
            List<Map<String, String>> finalResult = resultMap.entries
                .map((entry) =>
                    {"product_id": entry.key, "rate": entry.value.toString()})
                .toList();
            log('@@ res${resultMap}');

            resultMap.forEach((productId, rate) {
              resultArray.add({"product_id": productId, "rate": rate});
            });

            log('@@ ${resultArray}');
            log('@@ ${duplicates1}');
            Map<String, dynamic> idMap = {};

            for (var item in duplicates1) {
              int rate = int.parse(item["rate"]);
              if (rate > 0) {
                String productId = item["product_id"].toString();
                idMap[productId] = item["id"];
              }
            }

            // Add the "id" field to the first array where "rate" is greater than 0
            for (var item in resultArray) {
              int rate = item["rate"];
              String productId = item["product_id"].toString();
              if (rate > 0 && idMap.containsKey(productId)) {
                item["id"] = idMap[productId];
              }
            }

            log('@@ ${resultArray}');
            // log('@@ ${arr}');

            for (var item in resultArray) {
              int productId = int.parse(item["product_id"]);
              if (item["rate"] > 0 && !uniqueIds.contains(productId)) {
                uniqueIds.add(productId);

                // Find the matching item in the second array by 'id'
                var matchingItem = arr.firstWhere(
                    (element) => element["id"] == productId,
                    orElse: () => null);

                if (matchingItem != null) {
                  // Merge data from the first and second arrays
                  Map<String, dynamic> mergedData = {...matchingItem, ...item};
                  newArray.add(mergedData);
                }
              } else {
                uniqueIds.add(productId);

                // Find the matching item in the second array by 'id'
                var matchingItem = arr.firstWhere(
                    (element) => element["id"] == productId,
                    orElse: () => null);

                if (matchingItem != null) {
                  // Merge data from the first and second arrays
                  Map<String, dynamic> mergedData = {...matchingItem, ...item};
                  newArray.add(mergedData);
                }
              }
            }
            log('@@ newArray${newArray}');
          }
        } else {
          int size = data['data']['data']?.length;
          log('@@ 207 ${size}');
          // baseImageProduct = data['data']['image_path'];
          for (int? i = 0; i! < size!; i++) {
            log('@@ 57 ${data['data']['data'][i]}');
            newArray.add({
              "id": data['data']['data'][i]['id'],
              "name": data['data']['data'][i]['product_name'],
              "image": data['data']['data'][i]['new_product_image_name'],
              "rate": "0",
            });
            arr1.add({
              "product_id": data['data']['data'][i]['id'].toString(),
              "rate": "0",
            });
          }
        }

        if (duplicates.length > 0) {
          for (int i = 0; i < newArray.length; i++) {
            for (int j = 0; j < duplicates.length; j++) {
              log('@@@ tes1 ${duplicates}');
              // log('>>>>>>>>>>>>>>>>>>>>>>>>>>>> ${duplicates[i]['product_id'].toString() + ' ' + newArray[i]['product_id'].toString()}');
              if (newArray[i]['product_id'].toString() ==
                  duplicates[j]['product_id'].toString()) {
                // log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>${arr[i]['rate']}');
                newArray[i]['rate'] = duplicates[j]['rate'];
                resultArray[i]['rate'] = duplicates[j]['rate'];
              }
            }
          }
        } else {}
        setState(() {
          product = newArray;
          product1 = resultArray.isEmpty ? arr1 : resultArray;
          // duplicates1 = [];
        });
      } else {
        log("error!");
      }
    } catch (ex) {
      if (kDebugMode) {
        print('x');
      }
      if (kDebugMode) {
        print(ex);
      }
      Future.delayed(const Duration(milliseconds: 200), () {
        hideLoader(context);
      });
    } catch (e) {}
  }

  _product_list_added() async {
    var arr = [];
    var arr1 = [], arr2 = [], arr3 = [];
    log('@@ ${id}');
    setState(() {
      product_view = [];
      arr = [];
    });
    try {
      Future.delayed(Duration(microseconds: 700), () {
        showLoader(context);
      });
      String data1 = '';
      data1 = 'category_id=' +
          cate_id.toString() +
          '&' +
          'sub_category_id=' +
          id.toString();
      final data = await ApiService()
          .sendGetRequest('/v1/delivery-boy/product/product-list-with-price');
      if (kDebugMode) {
        print(data);
      }
      hideLoader(context);
      log('@@ 266${data['data']}');
      if (data?['data']['status'] == 1) {
        int size = data['data']['data']?.length;
        log('@@ 144 ${size}');
        for (int? i = 0; i! < size!; i++) {
          log('@@ 472 ${data['data']['data'][i]}');
          arr.add({
            "id": data['data']['data'][i]['id'],
            "product_id": data['data']['data'][i]['product_id'],
            "rate": data['data']['data'][i]['rate'],
          });
        }
        log('@@@ charge ${data?['data']['delivery_charge']}');
        setState(() {
          product_view = arr;
          _txtinput.text = data['data']['delivery_charge'].toString();
        });
        log('@@ 282 ${product_view}');
      } else {
        log("error!");
      }
      Future.delayed(Duration(microseconds: 1200), () {
        _product_list();
      });
    } catch (ex) {
      if (kDebugMode) {
        print('x');
      }
      if (kDebugMode) {
        print(ex);
      }
      Future.delayed(const Duration(milliseconds: 200), () {
        hideLoader(context);
      });
    } catch (e) {
      log('@@@ ${e}');
    }
  }

  int currentDateSelectedIndex = 0; //For Horizontal Date
  ScrollController scrollController = ScrollController();
  List<FocusNode> _focusNodes = List.generate(10, (index) => FocusNode());

  bool isSelect = false;
  bool isSelect1 = false;
  bool isSelect2 = false;
  bool isSelect3 = false;

  submit() async {
    var arr = [];
    Map<String, dynamic> data1;
    log('@@ ${product1}');
    // for (var i = 0; i < product1.length; i++) {
    //   if (product1[i]['rate'] != '0') {
    //     arr.add(product1[i]);
    //   }
    // }

    for (var i = 0; i < duplicates.length; i++) {
      if (duplicates[i]['rate'] != 0) {
        log('@@@ product${duplicates[i]}');
        arr.add(duplicates[i]);
      }
    }

    if (arr.length == 0) {
      toast('Enter amount should be grater than 0');
    } else if (_txtinput.text == '') {
      toast('Enter delivery charges');
    } else {
      data1 = {
        "service_list": arr,
        "delivery_charge": _txtinput.text.toString(),
      };
      showLoader(context);
      log('${data1}');
      try {
        showLoader(context);
        final data = await ApiService().sendPostRequest(
            '/v1/delivery-boy/product/add-update-product-price', data1);
        if (kDebugMode) {
          log('@@ ${data}');
        }
        hideLoader(context);
        log('@@ ${data?['data']['data']}');
        // log('message@@@${data['data']['status']![0]}');
        if (data?['data']['status'] == 1) {
          var arr = [];
          var mes = '';
          for (var i = 0; i < data['data']['data'].length; i++) {
            // log('@@@ ${res['data'][i]}');
            arr.add(data['data']['data'][i]);
          }

          for (dynamic item in arr) {
            item.forEach((key, value) {
              print('Key: $key, Value: $value');
              mes = value.replaceAll('"', '') + '.';
            });
          }
          toast(mes);
        } else {
          var arr = [];
          var mes = '';
          // log(data['data']['data']);
          for (var i = 0; i < data['data']['data'].length; i++) {
            log('@@@ ${data['data']['data'][i]}');
            arr.add(data['data']['data'][i]);
          }

          for (dynamic item in arr) {
            item.forEach((key, value) {
              print('Key: $key, Value: $value');
              mes = value.replaceAll('"', '') + '.';
            });
          }
          toast(mes.replaceAll('_', ' '));
          log("error!");
          //toast()
        }
      } catch (ex) {
        if (kDebugMode) {
          print('x');
        }
        if (kDebugMode) {
          print(ex);
        }
        Future.delayed(const Duration(milliseconds: 200), () {
          hideLoader(context);
        });
      }

      // toast(msg!);
      hideLoader(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    routes = ModalRoute?.of(context)?.settings.arguments as dynamic == null
        ? null
        : ModalRoute?.of(context)?.settings.arguments as dynamic;
    log('@@@ !${ModalRoute?.of(context)?.settings.arguments as dynamic}');
    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'My Rates',
        ),
        backgroundColor: const Color.fromRGBO(92, 136, 218, 1),
        leading: IconButton(
          icon: Image(
            image: routes != null
                ? AssetImage("assets/images/ChevronLeft.png")
                : AssetImage("assets/images/Hover.png"),
            height: 22,
          ),
          onPressed: () {
            routes != null
                ? Navigator.pop(context)
                : Navigator.pushNamed(context, '/screens/DeliveryBoyProfile');
          },
        ),
      ),
      body: SingleChildScrollView(
        controller: _parentController,
        child: Stack(children: <Widget>[
          Column(
            children: [
              Container(
                height: 72,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 19),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Add Services & Rates",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                color: const Color.fromRGBO(28, 41, 65, 1.0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(3.0, 0, 0, 0),
                  child: Center(
                    child: ListView.builder(
                      itemCount: delivery.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        print('delivery $delivery');
                        return InkWell(
                          onTap: () {
                            setState(() {
                              currentindex = index.toString();
                              cate_id = delivery[index]['id'].toString();
                              // delivery[index]['isSelect'] =
                              //     !delivery[index]['isSelect'];
                            });
                            _product_list_added();
                            log('@@ ${delivery[index]['id'].toString()}');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9)),
                                color: currentindex == ''
                                    ? Color.fromRGBO(92, 136, 218, 1)
                                    : currentindex == index.toString()
                                        ? Colors.grey
                                        : Color.fromRGBO(92, 136, 218, 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  children: [
                                    Image(
                                      image: NetworkImage(
                                          baseImage + delivery[index]['image']),
                                      height: 25,
                                      width: 25,
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      delivery[index]['name'],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 12),
                height: 35,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 14.0, 0),
                  child: ListView.builder(
                    itemCount: gender.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          currentindexgen = index.toString();
                          id = gender[index]['id'].toString();
                          _product_list_added();
                          log('@@@ 803 ${gender[index]}');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: currentindexgen == ''
                                  ? HexColor('#1C2941')
                                  : currentindexgen == index.toString()
                                      ? Colors.grey
                                      : HexColor('#1C2941'),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 19.0,
                                vertical: 10,
                              ),
                              child: Text(
                                gender![index]['sub_category_name'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 35,
                color: const Color.fromRGBO(210, 210, 210, 1.0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Item",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "Service Rate",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: const Color.fromRGBO(236, 241, 255, 1.0),
                height: 220,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(7.0, 0, 7, 0),
                  child: ListView.builder(
                    controller: _childController,
                    itemCount: product.length,
                    itemBuilder: (context, index) {
                      print((product[index]));
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 9,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            // color: Colors.red,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 10, 10, 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.network(
                                  product[index]['image'],
                                  height: 29,
                                  width: 29,
                                  semanticsLabel: 'A shark?!',
                                  placeholderBuilder: (BuildContext context) =>
                                      Container(
                                          padding: const EdgeInsets.all(7.0),
                                          child:
                                              const CircularProgressIndicator()),
                                ),
                                // Text(
                                //   product[index]['name'],
                                //   style: const TextStyle(
                                //     fontSize: 12,
                                //     fontWeight: FontWeight.bold,
                                //     color: Colors.black,
                                //     // backgroundColor: Colors.amber,
                                //   ),
                                // ),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   crossAxisAlignment: CrossAxisAlignment.center,
                                //   children: [
                                //     Container(
                                //       height: 22,
                                //       width: 22,
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(12),
                                //         color: Colors.grey[400],
                                //       ),
                                //       child: const Center(
                                //         child: Text(
                                //           "-",
                                //           style: TextStyle(
                                //               // fontSize: 19,
                                //               ),
                                //         ),
                                //       ),
                                //     ),
                                //     SizedBox(
                                //       width: 12,
                                //     ),
                                //     Text(
                                //       cloths[index]['qty'].toString(),
                                //       style: const TextStyle(
                                //         fontSize: 12,
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.black,
                                //         // backgroundColor: Colors.amber,
                                //       ),
                                //     ),
                                //     SizedBox(
                                //       width: 12,
                                //     ),
                                //     Container(
                                //       height: 21,
                                //       width: 21,
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(12),
                                //         color: Colors.grey[400],
                                //       ),
                                //       child: const Icon(Icons.add, size: 12),
                                //     ),
                                //   ],
                                // ),
                                SizedBox(
                                  width: 45,
                                  height: 42,
                                  child: TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        product[index]['rate'] = value;
                                        product1[index]['rate'] = value;
                                      });
                                      log('product 466 $product');
                                      for (dynamic obj in product1) {
                                        if (uniqueId.add(
                                            obj['product_id'].toString())) {
                                          // If the name is already in the Set, it's a duplicate.
                                          duplicates.add(obj);
                                        }
                                      }
                                      for (dynamic objres in duplicates) {
                                        log('@@@ obj${objres}');
                                        if (objres['product_id'] ==
                                            product[index]['id']) {
                                          int index1 =
                                              duplicates.indexOf(objres);
                                          log('@@@ index ${index1}');
                                          duplicates[index1]['rate'] =
                                              value.toString();
                                        }
                                      }
                                    },
                                    initialValue:
                                        product[index]['rate'].toString() == '0'
                                            ? ''
                                            : product[index]['rate']
                                                .toString()!,
                                    // controller: _txtinput,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .grey), // Color of the bottom border when not focused
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .black), // Color of the bottom border when focused
                                      ),
                                      hintText: 'Rs.',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 18, 18.0, 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Delivery Charges",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 42,
                        child: TextFormField(
                          // onChanged: (text) {
                          //   setState(() {
                          //     delivery_charges = text;
                          //   });
                          // },
                          controller: _txtinput,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            fillColor: Colors.transparent,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 2.0,
                                color: Colors.grey,
                              ),
                            ),
                            filled: false,
                            hintText: "Enter delivery charges",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   child: Padding(
              //     padding: const EdgeInsets.fromLTRB(18.0, 18, 18.0, 7),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             // const Text(
              //             //   "Total",
              //             //   style: TextStyle(
              //             //     fontSize: 14,
              //             //     fontWeight: FontWeight.normal,
              //             //     color: Colors.black,
              //             //   ),
              //             // ),
              //             // Row(
              //             //   children: [
              //             //     Text(
              //             //       "Rs",
              //             //       style: TextStyle(
              //             //         fontSize: 14,
              //             //         fontWeight: FontWeight.bold,
              //             //         color: Colors.black,
              //             //       ),
              //             //     ),
              //             //     SizedBox(
              //             //       width: 21,
              //             //     ),
              //             //     Text(
              //             //       "210",
              //             //       style: TextStyle(
              //             //         fontSize: 14,
              //             //         fontWeight: FontWeight.normal,
              //             //         color: Colors.black,
              //             //       ),
              //             //     ),
              //             //   ],
              //             // ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 105,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(236, 241, 255, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Container(
                        //   // width: MediaQuery.of(context).size.width - 180,
                        //   height: 52,
                        //   margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                        //   child: TextButton(
                        //     onPressed: () {
                        //       Get.toNamed('/screens/CustomersOrders');
                        //     },
                        //     style: TextButton.styleFrom(
                        //       // Background color
                        //       // padding: EdgeInsets.symmetric(
                        //       //     horizontal: 20, vertical: 10), // Padding
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius:
                        //             BorderRadius.circular(9), // Button shape
                        //       ),
                        //       // textStyle: TextStyle(fontSize: 16), // Text style
                        //       alignment: Alignment
                        //           .center, // Alignment of text within the button
                        //     ),
                        //     child: Padding(
                        //       padding:
                        //           const EdgeInsets.fromLTRB(12.0, 4, 12, 4),
                        //       child: Text(
                        //         "Go Back".toUpperCase(),
                        //         style: TextStyle(
                        //           color: HexColor('#5C88DA'),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Container(
                          width: MediaQuery.of(context).size.width - 180,
                          height: 52,
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                          child: TextButton(
                            onPressed: () {
                              submit();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(
                                  28, 41, 65, 1.0), // Background color
                              // padding: EdgeInsets.symmetric(
                              //     horizontal: 20, vertical: 10), // Padding
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(9), // Button shape
                              ),
                              // textStyle: TextStyle(fontSize: 16), // Text style
                              alignment: Alignment
                                  .center, // Alignment of text within the button
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(12.0, 4, 12, 4),
                              child: Text(
                                "Send Confirmation".toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
