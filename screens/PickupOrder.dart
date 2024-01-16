import 'dart:collection';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/screens/Add%20Issue.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/services/global.dart';
import 'package:ishtri_db/statemanagemnt/provider/OrderDataProvider.dart';
import 'package:ishtri_db/widgets/CButton.dart';
import 'package:provider/provider.dart';
import '../../widgets/question.dart';
import '../../widgets/CustomText.dart';
import '../models/Data.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:io' as Io;
import 'package:intl/intl.dart';

class PickupOrder extends StatefulWidget {
  final dynamic? data, det;
  final dynamic? cs_id, uniq_id;
  const PickupOrder({super.key, this.det, this.data, this.cs_id, this.uniq_id});

  @override
  State<PickupOrder> createState() => _PickupOrderState();
}

class _PickupOrderState extends State<PickupOrder> {
  void submit() {
    showAlertDialog(context);
  }

  bool isChecked = false;
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    Widget remindButton = TextButton(
      child: const Text("Remind me later"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("AlertDialog"),
      content: const Text(
          "Would you like to continue learning how to use Flutter alerts?"),
      actions: [cancelButton, continueButton, remindButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    void cancel() {
      Navigator.pop(context, false);
    }
  }

  var _data = null;
  var page = 1;
  List _users = [];

  var delivery = [];
  var gender = [];
  var product = [];
  var product1 = [];
  var product2 = [];
  var tempproduct2 = [];
  var timeArr = [];
  Set<String> uniqueId = HashSet<String>();
  Set<String> uniqueNames = HashSet<String>();
  Set<String> uniqueId1 = HashSet<String>();
  dynamic duplicates = [];
  dynamic duplicates1 = [];
  var order = [];
  String currentindex = '';
  String currentindexgen = '';
  String delivery_charges = '',
      delivery_charge = '',
      credit_limit = '',
      extra_charges = '',
      note = '';
  String baseImage = '';
  String baseImageProduct = '', genderSel = '';
  String cate_id = '';
  String subCate_id = '';
  dynamic routes;
  late ScrollController _controller = ScrollController();
  TextEditingController txtCharges = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        print(_controller.position.pixels);
      }
    });
    _category_list();
    _subcategory_list();
    _scheduletime();
  }

  toast(String name) {
    return Fluttertoast.showToast(
        msg: name,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        textColor: Colors.white);
  }

  @override
  void dispose() {
    // _controller.removeListener(_loadMore);
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  List<Map<String, dynamic>> cloths = [];
  DateTime selectedDate = DateTime.now(); // TO tracking date

  String currentDateSelectedIndex = ''; //For Horizontal Date
  String currentDateSelectedIndex1 = ''; //For Horizontal Date
  ScrollController scrollController = ScrollController();
  List<String> listOfMonths = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  List<String> listOfDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  List<FocusNode> _focusNodes = List.generate(10, (index) => FocusNode());

  bool isSelect = false;
  bool isSelect1 = false;
  bool isSelect2 = false;
  bool isSelect3 = false;
  // void apicall() {
  int? _delcharges = 0;

  String formattedDate = '', time = '';
  Future<void> _getScheudle() async {
    try {
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      dynamic data1 = {
        "order_list": product1,
        "total_order_price": delivery_charges,
        "order_id": 1,
        "delivery_date": 25 - 09 - 2023,
        "delivery_time": 02 - 04,
        "issue_list": "",
        "deleveryCharge": txtCharges,
      };
      final data = await ApiService()
          .sendPostRequest('/v1/delivery-boy/delivery-boy/get-db-rate', data1);
      if (kDebugMode) {
        print(data);
      }
      hideLoader(context);
      log('@@${data['data']['data'][0]['productPriceList']}');
      if (data?['data']['status'] == 1) {
        // log('@@ 144 ${size2}');
      } else {
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
    } catch (e) {}
  }

  Future<void> _getScheudleId() async {
    try {
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      final data = await ApiService()
          .sendGetRequest('/v1/delivery-boy/delivery-boy/get-db-rate');
      if (kDebugMode) {
        print(data);
      }
      hideLoader(context);
      var arr = [];
      log('@@${data['data']}');
      if (data?['data']['data']?.length > 0) {
        int size = data['data']['data']?.length;
        for (int i = 0; i < size; i++) {
          log('@@ ${data['data']['data'][i]}');
          arr.add({
            'id': data['data']['data'][i]['master_schedule_id'],
            "schedule_range": data['data']['data'][i]['schedule_range'],
            "isSelect": false
          });
        }
        setState(() {
          // widgetList = arr;
        });
      } else {
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
    } catch (e) {}
  }

  _gender(id) async {
    var arr = [];
    var arr1 = [];
    var arr2 = [];
    setState(() {
      product = [];
      product1 = [];
      arr1 = [];
      arr2 = [];
    });

    showLoader(context);
    Future.delayed(const Duration(seconds: 1), () {
      print(id);
      int? size = order!.length;
      log('@@ size ${size}');
      hideLoader(context);
      // service?.data![0].product
      //     ?.map((item) => {
      for (int? i = 0; i! < size!; i++) {
        log('@i ${order?[i]['product_sub_categories'][0]['products']}');
        int? size1 = order?[i]?.length;
        // for (int? j = 0; j! < size1!; j++) {
        //   if (order?[i]![j]['id'] == id) {
        //     int? size2 = order?[i]![j]['products']?.length;
        //     for (int? l = 0; l! < size2!; l++) {
        // print(
        //     'product 12 ${service?.data![0].product![i].productSubCategories![j].products![l].productName}');
        // arr1.add({
        //   "id": service?.data![0].product![i].productSubCategories![j]
        //       .products![l].productId,
        //   "name": service?.data![0].product![i].productSubCategories![j]
        //       .products![l].productName,
        //   "rate": 0.toString(),
        // });
        // arr2.add({
        //   "product_id": service?.data![0].product![i]
        //       .productSubCategories![j].products![l].productId
        //       .toString(),
        //   "rate": 0.toString(),
        // });
        //     }
        //   }
        // }
      }
      setState(() {
        product = arr1;
        product1 = arr2;
      });
    });
    //     })
    // .toList();
  }
  // }

  _category_list() async {
    setState(() {
      delivery = [];
    });
    try {
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      String data1 = '';
      data1 = 'page=' + '1' + '&' + 'limit=' + '10';
      final data = await ApiService()
          .sendGetRequest('/v1/delivery-boy/product/category-list?${data1}');
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
        baseImage = data['data']['image_path'];
        for (int? i = 0; i! < size!; i++) {
          arr.add({
            "id": data['data']['data'][i]['id'],
            "name": data['data']['data'][i]['category_name'],
            "image": data['data']['data'][i]['new_category_image_name'],
          });
        }
        setState(() {
          delivery = arr;
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
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      String data1 = '';
      data1 = 'page=' + '1' + '&' + 'limit=' + '10';
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

  _product_list(id) async {
    log('@@ ${id}');
    setState(() {
      product = [];
      product1 = [];
    });
    try {
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      String data1 = '';
      data1 = 'category_id=' +
          cate_id.toString() +
          '&' +
          'sub_category_id=' +
          id.toString() +
          '&' +
          'customer_id=' +
          widget.cs_id.toString();
      log('@@@ ${data1}');
      hideLoader(context);
      final data = await ApiService().sendGetRequest(
          '/v1/delivery-boy/product/order-product-list?${data1}');
      if (kDebugMode) {
        log('@@@ ${data}');
      }
      hideLoader(context);
      var arr = [];
      var arr1 = [], arr2 = [], arr3 = [];
      log('@@ 99${data['data']['data']}');
      if (data?['data']['status'] == 1) {
        int size = data['data']['data']?.length;
        log('@@ 144 ${size}');
        // baseImageProduct = data['data']['image_path'];
        // var charge = data['data']['data']['delivery_charge'];
        for (int? i = 0; i! < size!; i++) {
          log('@@ 57 ${data['data']['data'][i]}');
          arr.add({
            "id": data['data']['data'][i]['id'].toString(),
            "name": data['data']['data'][i]['product_name'],
            "image": data['data']['data'][i]['new_product_image_name'],
            "rate": data['data']['data'][i]['rate'].toString(),
            "quentity": '',
            "charges": 0
          });
          arr1.add({
            "product_id": data['data']['data'][i]['id'].toString(),
            "customer_product_price":
                data['data']['data'][i]['rate'].toString(),
            //data['data']['data'][i]['product_price']['rate'].toString(),
            "product_quantity": "",
            "category_id": ""
          });
        }
        if (duplicates.length > 0) {
          for (int i = 0; i < arr.length; i++) {
            for (int j = 0; j < duplicates.length; j++) {
              if (arr[i]['id'] == duplicates[j]['product_id']) {
                log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
                log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>${arr[i]['quentity']}');
                arr[i]['quentity'] = duplicates[j]['product_quantity'];
                arr1[i]['product_quantity'] = duplicates[j]['product_quantity'];
              }
            }
          }
        } else {}
        log('@@@ ${data['data']['delivery_charge']}');
        setState(() {
          product = arr;
          product1 = arr1;
          txtCharges.text = data['data']['delivery_charge'].toString();
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

  void _scheduletime() async {
    DateTime time;
    String formated = '';
    List<Map<String, dynamic>> arr = [], arr1 = [], arr3 = [], arr4 = [];
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    formattedDate = formatter.format(DateTime.now());
    var data = {"date": formattedDate};
    Future.delayed(const Duration(microseconds: 500), () {
      showLoader(context);
    });
    setState(() {
      arr = [];
      arr1 = [];
      arr3 = [];
    });
    print(data);

    await Provider.of<OrderDataProvider>(context, listen: false)
        .fetchscheduleallData(context, data);
    final res = await Provider.of<OrderDataProvider>(context, listen: false)
        .scheduleSelect;

    // log('${jsonEncode(res)}');
    hideLoader(context);
    if (res?.status == 1) {
      // log('aa${jsonEncode(res?.data?.length)}');
      int? size = res?.data?.length;
      for (int? i = 0; i! < size!; i++) {
        int? count = res?.data![i]?.scheduleList?.length;

        for (int? j = 0; j! < count!; j++) {
          // log('item ${res?.data![i].scheduleList![j].isSchedule}');
          int? count1 = res?.data![i]?.scheduleList![j].socityArry?.length;

          arr.add({
            "schedule_range": res?.data![i].scheduleList![j].scheduleTime,
            "isSelect": res?.data![i].scheduleList![j].isSchedule,
            "masterId": res?.data![i].scheduleList![j].masterScheduleId,
            "society": res?.data![i].scheduleList![j].socityArry,
          });

          for (int? l = 0; l! < count1!; l++) {
            // log('@@ count ${res?.data![i]?.scheduleList![j]?.socityArry![l].isSelect}');

            arr1.add({
              "name": res?.data![i].scheduleList![j].socityArry![l].name,
              "isSchedule":
                  res?.data![i].scheduleList![j].socityArry![l].isSelect,
              "tower": res?.data![i].scheduleList![j].socityArry![l].towers,
              "id": res?.data![i].scheduleList![j].socityArry![l].id,
            });
          }

          // log('@@ len${arr1}');
        }
      }

      log('@@ $arr1');
      List<Map<String, dynamic>> dataList = [];

      // Create a Set to store unique elements
      Set<Map<String, dynamic>> uniqueList = {};

      for (var entry in arr1) {
        uniqueList.add(entry);
      }
      List<Map<String, dynamic>> isScheduleTrueData =
          arr1.where((element) => element["isSchedule"] == true).toList();

      List<Map<String, dynamic>> uniqueData2 = isScheduleTrueData.fold(
          <Map<String, dynamic>>[], (List<Map<String, dynamic>> accumulator,
              Map<String, dynamic> current) {
        bool isDuplicate = accumulator.any((element) {
          return element["name"] == current["name"] &&
              element["id"] == current["id"];
        });

        if (!isDuplicate) {
          accumulator.add(current);
        }

        return accumulator;
      });

      List<Map<String, dynamic>> isScheduleTrueData1 =
          arr1.where((element) => element["isSchedule"] == false).toList();

      List<Map<String, dynamic>> uniqueData1 = isScheduleTrueData1.fold(
          <Map<String, dynamic>>[], (List<Map<String, dynamic>> accumulator,
              Map<String, dynamic> current) {
        bool isDuplicate = accumulator.any((element) {
          return element["name"] == current["name"] &&
              element["id"] == current["id"];
        });

        if (!isDuplicate) {
          accumulator.add(current);
        }

        return accumulator;
      });

      arr3 = uniqueData1;
      if (uniqueData2.length != 0) {
        for (int i = 0; i < uniqueData2.length; i++) {
          for (int j = 0; j < uniqueData1.length; j++) {
            log('@@ =>>>${uniqueData2[i]['name']}');
            if (uniqueData2[i]['name'] == uniqueData1[j]['name']) {
              arr3[j]['isSchedule'] = uniqueData2[i]['isSchedule'];
            }
          }
        }
      }
      if (arr1.length != 0) {
        for (int i = 0; i < arr1.length; i++) {
          for (int j = 0; j < arr1[i]['tower'].length; j++) {
            // log('@@@=>>>>> ${jsonEncode(arr1[i]['tower'][j].isSelect)}');
            arr4.add({
              "id": arr1[i]['tower'][j].id,
              "name": arr1[i]['tower'][j].name,
              "isSelect": arr1[i]['tower'][j].isSelect,
            });
          }
        }
      }
      log('@@ =>>>${arr4.length}');
      var arr5 = [];
      List<Map<String, dynamic>> uniqueDataTower1 = [];
      List<Map<String, dynamic>> uniqueDataTower2 = [];
      List<Map<String, dynamic>> isTowerTrueData1 =
          arr4.where((element) => element["isSelect"] == false).toList();

      List<Map<String, dynamic>> isTowerTrueData2 =
          arr4.where((element) => element["isSelect"] == true).toList();

      if (arr4.length != 0) {
        uniqueDataTower1 = isTowerTrueData1.fold(<Map<String, dynamic>>[],
            (List<Map<String, dynamic>> accumulator,
                Map<String, dynamic> current) {
          bool isDuplicate = accumulator.any((element) {
            return element["name"] == current["name"];
          });

          if (!isDuplicate) {
            accumulator.add(current);
          }

          return accumulator;
        });

        uniqueDataTower2 = isTowerTrueData2.fold(<Map<String, dynamic>>[],
            (List<Map<String, dynamic>> accumulator,
                Map<String, dynamic> current) {
          bool isDuplicate = accumulator.any((element) {
            return element["name"] == current["name"];
          });

          if (!isDuplicate) {
            accumulator.add(current);
          }

          return accumulator;
        });

        arr5 = uniqueDataTower1;
        if (uniqueDataTower2.length != 0) {
          for (int i = 0; i < uniqueDataTower2.length; i++) {
            for (int j = 0; j < uniqueDataTower1.length; j++) {
              log('@@ =>>>${uniqueDataTower2[i]['name']}');
              if (uniqueDataTower2[i]['name'] == uniqueDataTower1[j]['name']) {
                arr5[j]['isSelect'] = uniqueDataTower2[i]['isSelect'];
              }
            }
          }
        }
        log('@@@=>>>${uniqueDataTower2}');
        // for(int i=0;i<arr4.length;i++)
      }
      if (uniqueData2.length == 0) {
        log('@@@ ${uniqueData1}');
        setState(() {
          timeArr = arr;
        });
      } else {
        setState(() {
          timeArr = arr;
        });
      }
    } else {
      log('bb');
      hideLoader(context);
    }
    // });
    log('arr $arr');
  }

  Widget paymentDialog() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          height: 200,
          width: MediaQuery.of(context).size.width - 90,
          child: Column(
            children: [
              Container(
                // height: 200,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                // color: Colors.white,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0, top: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "payment".toUpperCase(),
                              style: const TextStyle(
                                color: lightBlackColor,
                                fontFamily: "Poppins-bold",
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        child: Text(
                          'Set cradit limit for customer',
                          style: TextStyle(
                              color: blackColor,
                              fontFamily: "Poppins-Regular",
                              fontSize: 16),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 3),
                          child: TextField(
                            onChanged: (value) {
                              credit_limit = value;
                            },
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey), // Color of the bottom border when not focused
                              ),
                              hintText: 'Enter Amt',
                            ),
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 180,
                            height: 42,
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: TextButton(
                              onPressed: () {
                                setCradit();
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
                                  "Set cradit limit".toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 2),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: issueList.map((urlOfItem) {
              //       int index = issueList.indexOf(urlOfItem['id']);
              //       log('@@ ${index}');
              //       return Container(
              //         width: 10.0,
              //         height: 10.0,
              //         margin: const EdgeInsets.only(
              //             left: 5, right: 5, top: 0, bottom: 0),
              //         decoration: BoxDecoration(
              //           shape: BoxShape.circle,
              //           color: _currentIndex == index
              //               ? themeBlueColor
              //               : whiteColor,
              //         ),
              //       );
              //     }).toList(),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  void show() async {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: paymentDialog(),
            ),
          );
        });
  }

  void setCradit() async {
    log('@@@ ${widget.det}');
    try {
      if (credit_limit == '') {
        showErrorPopup(
            context, 'Warning!', 'Please enter customer credit limit');
      } else {
        var data = {
          "customer_id": widget.det[0]['customer_id'],
          "credit_limit": credit_limit,
        };
        log('@@ ${data}');
        // Future.delayed(const Duration(seconds: 1), () {
        //   showLoader(context);
        // });
        final data1 = await ApiService().sendPostRequest(
            '/v1/delivery-boy/customer/set-credit-limit', data);
        if (kDebugMode) {
          log('@@ ${data1['data']['status'] == 1}');
        }
        if (data1['data']['status'] == 1) {
          showErrorPopup(context, 'Success', data1['data']['message']);
          Navigator.pop(context);
          hideLoader(context);
        } else {
          showErrorPopup(context, 'Error! ', 'Something want wrong');
          hideLoader(context);
        }
      }
    } catch (ex) {
      hideLoader(context);
    }
    hideLoader(context);
  }

  dynamic arr9 = [];
  var arr7 = [], arr10 = [];
  _submit() async {
    for (var i = 0; i < duplicates.length; i++) {
      if (duplicates[i]['product_quantity'] != '') {
        log('@@@ product${duplicates[i]}');
        arr10.add(duplicates[i]);
      }
    }

    log('@@@ ${widget.data}');
    if (delivery_charges == '') {
      setState(() {
        arr10 = [];
      });
      showErrorPopup(context, 'Alert!', 'Please enter amount');
    } else if (txtCharges.text == '') {
      setState(() {
        arr10 = [];
      });
      showErrorPopup(context, 'Alert!', 'Please enter delivery charges');
    } else if (formattedDate == '') {
      setState(() {
        arr10 = [];
      });
      showErrorPopup(context, 'Alert!', 'Please select your date');
    } else if (time == '') {
      setState(() {
        arr10 = [];
      });
      showErrorPopup(context, 'Alert!', 'Please select your time');
    } else if (arr10.length < 0) {
      setState(() {
        arr10 = [];
      });
      showErrorPopup(context, 'Alert!', 'Please enter quentity');
    } else {
      try {
        Future.delayed(const Duration(microseconds: 200), () {
          showLoader(context);
        });
        Map<String, dynamic> data1, dataIss;
        data1 = {
          "order_list": jsonEncode(arr10),
          "total_order_price": delivery_charges.toString(),
          "order_id": widget.data.toString(),
          "delivery_date": formattedDate.toString(),
          "delivery_time": time.toString(),
          "issue_list": jsonEncode(arr9),
          "deleveryCharge": txtCharges.text.toString(),
          "special_charge_amount": extra_charges.toString(),
          "special_charge_note": note.toString()
        };
        dataIss = {
          "order_list": jsonEncode(arr10),
          "total_order_price": delivery_charges.toString(),
          "order_id": widget.data.toString(),
          "delivery_date": formattedDate.toString(),
          "delivery_time": time.toString(),
          "deleveryCharge": txtCharges.text.toString(),
          "special_charge_amount": extra_charges.toString(),
          "special_charge_note": note.toString()
        };
        setState(() {
          arr10 = [];
        });
        log('@@@ ${data1}');
        final data = await ApiService().sendPostRequest(
            '/v1/delivery-boy/order/create-order',
            arr9.length == 0 ? dataIss : data1);
        if (kDebugMode) {
          print(data);
        }
        hideLoader(context);
        var arr = [];
        var arr1 = [], arr2 = [], arr3 = [];
        log('@@ 99${data['data']}');
        if (data?['data']['status'] == 1) {
          var mes = '';
          mes = data['data']['data'][0]['message'];
          // showErrorPopup(context, 'Success', mes);
          setState(() {
            arr9 = [];
            temp = [];
          });
          // Navigator.pop(context, {"pickup": "1"});
          Navigator.pop(context);
        } else {
          var mes = '';
          // show();
          mes = data['data']['data'][0]['message'];
          toast(mes!);
        }
      } catch (ex) {
        if (kDebugMode) {
          print('x');
        }
        if (kDebugMode) {
          print(ex);
        }
        // Future.delayed(const Duration(milliseconds: 200), () {
        hideLoader(context);
        // });
      } catch (e) {}
    }
  }

  amount() {
    int charges = 0;
    // for (dynamic amt in product) {}
    log('@@@ ${tempproduct2}');
    tempproduct2.forEach((element) {
      log('@@ ${element['charges']}');
      charges = charges + int.parse(element['charges'].toString());
    });
    log('@@! ${charges}');
    setState(() {
      delivery_charges = charges.toString();
    });
  }

  dynamic temp = [];
  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddIssue(
                orid: widget.uniq_id,
                product: tempproduct2,
              )),
    );
    var req = [];
    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;
    log('@@ 835${result}');
    log('@@ ${arr9 == null}');
    log('@@ 835${temp.length}');
    // [9][7,6,5,3,9]
    int qty = 0;
    if (result != null) {
      if (arr9.length > 0) {
        for (var obj in duplicates) {
          log('@@@ ${obj}');
          for (var obj1 in arr9) {
            if (obj['product_id'] == obj1['product_id']) {
              log('@@@ 856 ${obj1}');
              qty = int.parse(obj1['quantity']) + qty;
            }
          }
          log('@@@ ${qty}');
          if (qty > int.parse(obj['product_quantity'])) {
            showErrorPopup(context, 'Error!',
                'Enter quentity not graterthan product pickup order quantity');
          } else {
            log('>>>>>>>>>>>>>>>>>>>>>>>>>');
            if (result != null) {
              qty = int.parse(result['quantity']) + qty;

              log('=========================${qty}');
              if (qty > int.parse(obj['product_quantity'])) {
                qty = 0;
                showErrorPopup(context, 'Error!',
                    'Enter quentity not graterthan product pickup order quantity');
              } else {
                qty = 0;
                log('.................................');
                if (obj['product_id'] == result['product_id']) {
                  temp.add(result);
                }
              }
            } else {}
          }
        }
      } else {
        temp.add(result);
      }
    }
    setState(() {
      arr9 = temp;
    });
    // temp = result;
    // log('@@@ temp${temp[0]}');
    // log('@@@ temp${temp[1]}');
    // log('@@@ temp${temp[2]}');
    // arr9.add(result);
    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    // ScaffoldMessenger.of(context)
    //   ..removeCurrentSnackBar()
    //   ..showSnackBar(SnackBar(content: Text('$result')));
  }

  void issueQty() {
    // for (var obj in arr9) {
    //   if (uniqueId1.add(obj['product_id'])) {
    //     duplicates1.add(obj);
    //   }
    // }

    // log('@@@ 843 ${uniqueId1.length}');
    // log('@@@ ${result}');
    // // for (int i = 0; i < result.length; i++) {
    // req = uniqueId1.where((id) => id == result['product_id']).toList();
    // log('@@@ ${req}');
    // // }
    // log('@@@ req${req}');
    // if (req.length > 0) {
    //   temp = arr9;
    //   for (var obj1 in arr9) {
    //     if (result['product_id'] == obj1['product_id']) {
    //       // if (obj1['quentity'] > result[0]['quentity']) {
    //       int index1 = arr9.indexOf(obj1);
    //       temp[index1] = result;
    //       // }
    //     } else {}
    //   }
    // } else {
    //   temp.add(result);
    // }
    // log('@@@ 860${temp}');
  }
  @override
  Widget build(BuildContext context) {
    // widget.data;
    // log('@@@ val ${widget.data}');
    // routes = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    log('@@@ ${routes}');
    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: AppBar(
        title: const Text(
          'Pickup Order',
        ),
        backgroundColor: const Color.fromRGBO(92, 136, 218, 1),
        leading: IconButton(
          icon: const Image(
            image: AssetImage("assets/images/ChevronLeft.png"),
            height: 33,
          ),
          onPressed: () {
            Navigator.of(context).pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(children: <Widget>[
          Column(
            children: [
              Container(
                color: const Color.fromRGBO(28, 41, 65, 1.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 9.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                                        cate_id =
                                            delivery[index]['id'].toString();
                                        // delivery[index]['isSelect'] =
                                        //     !delivery[index]['isSelect'];
                                      });
                                      _product_list(genderSel);
                                      log('@@ ${delivery[index]['id'].toString()}');
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(9)),
                                          color: currentindex == ''
                                              ? const Color.fromRGBO(
                                                  92, 136, 218, 1)
                                              : currentindex == index.toString()
                                                  ? Colors.grey
                                                  : const Color.fromRGBO(
                                                      92, 136, 218, 1),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Column(
                                            children: [
                                              Image(
                                                image: NetworkImage(baseImage +
                                                    delivery[index]['image']),
                                                height: 25,
                                                width: 25,
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                delivery[index]['name'],
                                                style: const TextStyle(
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
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 62,
                margin: const EdgeInsets.symmetric(horizontal: 18),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // margin: const EdgeInsets.fromLTRB(0, 10, 0, 12),
                  height: 35,
                  child: ListView.builder(
                    itemCount: gender.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          currentindexgen = index.toString();
                          setState(() {
                            genderSel = gender![index]['id'].toString();
                          });
                          _product_list(gender![index]['id'].toString());
                          log('@@id ${gender![index]['id']}');
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 7.0,
                          ),
                          decoration: BoxDecoration(
                            color: currentindexgen == ''
                                ? HexColor('#1C2941')
                                : currentindexgen == index.toString()
                                    ? Colors.grey
                                    : HexColor('#1C2941'),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 19.0,
                              vertical: 10,
                            ),
                            child: Text(
                              gender![index]['sub_category_name'],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Item",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Qty",
                        style: TextStyle(
                          fontSize: 16,
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
                height: 270,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 0, 18, 0),
                  child: ListView.builder(
                    itemCount: product.length,
                    itemBuilder: (context, index) {
                      // print((cloths[index]));
                      return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: index == 0
                              ? const EdgeInsets.fromLTRB(0.0, 10, 0, 7.0)
                              : const EdgeInsets.fromLTRB(0.0, 28, 0, 7.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Text(
                              //   cloths[index]['item'],
                              //   style: const TextStyle(
                              //     fontSize: 12,
                              //     fontWeight: FontWeight.bold,
                              //     color: Colors.black,
                              //     // backgroundColor: Colors.amber,
                              //     height: 2,
                              //   ),
                              // ),

                              SvgPicture.network(
                                product[index]['image'],
                                height: 22,
                                width: 22,
                                placeholderBuilder: (BuildContext context) =>
                                    Container(
                                        padding: const EdgeInsets.all(19.0),
                                        child:
                                            const CircularProgressIndicator()),
                              ),
                              SizedBox(
                                width: 45,
                                height: 25,
                                child: TextFormField(
                                  onChanged: (value) {
                                    log('1175 ${value == ''}');
                                    setState(() {
                                      product1[index]['product_quantity'] =
                                          value == '' ? "0" : value.toString();
                                      product[index]['quentity'] =
                                          value == '' ? "0" : value.toString();
                                      product1[index]['category_id'] =
                                          cate_id.toString();
                                      product[index]['charges'] = value == ''
                                          ? "0"
                                          : int.parse(value) *
                                              int.parse(product[index]['rate']
                                                  .toString());
                                      // product2[index]['category_id'] =
                                      //     cate_id.toString();
                                    });
                                    // log('len ${product1}');
                                    // if (tempproduct2.length == 0) {
                                    //   tempproduct2.add(product1[index]);
                                    // } else {
                                    //   // log('@@# ${tempproduct2}');
                                    //   tempproduct2.forEach((element) {
                                    //     log('@@# ${element['product_id']} + '
                                    //         ' + ${product[index]['id']}');
                                    //     // log('@@# ${product1[index]}');
                                    //     if (element['product_id'].toString() !=
                                    //         product1[index]['product_id']
                                    //             .toString()) {
                                    //       tempproduct2.add(product1[index]);
                                    //     } else {}
                                    //   });
                                    // }

                                    for (dynamic obj in product1) {
                                      if (uniqueId
                                          .add(obj['product_id'].toString())) {
                                        // If the name is already in the Set, it's a duplicate.
                                        duplicates.add(obj);
                                      }
                                    }
                                    log('unique ${product1}');
                                    for (dynamic obj in product) {
                                      if (uniqueNames
                                          .add(obj['id'].toString())) {
                                        // If the name is already in the Set, it's a duplicate.
                                        tempproduct2.add(obj);
                                      }
                                    }
                                    for (dynamic objres in duplicates) {
                                      log('@@@ obj${objres}');
                                      if (objres['product_id'] ==
                                          product[index]['id']) {
                                        int index1 = duplicates.indexOf(objres);
                                        log('@@@ index${index1}');
                                        duplicates[index1]['product_quantity'] =
                                            value.toString();
                                      }
                                    }
                                    for (dynamic objres in tempproduct2) {
                                      log('@@@ ${objres}');
                                      if (objres['product_id'] ==
                                          product[index]['id']) {
                                        int index1 = duplicates.indexOf(objres);
                                        // log('@@@ ${index}');
                                        tempproduct2[index1]
                                                ['product_quantity'] =
                                            value == ''
                                                ? "0"
                                                : value.toString();
                                        tempproduct2[index1]['charges'] =
                                            value == ''
                                                ? 0
                                                : int.parse(value) *
                                                    int.parse(product[index]
                                                            ['rate']
                                                        .toString());
                                      }
                                    }
                                    // log('@@# ${duplicates}');
                                    amount();
                                  },
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .grey), // Color of the bottom border when not focused
                                    ),
                                    hintText: 'Qty',
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .black), // Color of the bottom border when focused
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  initialValue: product[index]['quentity'],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 36,
                color: const Color.fromRGBO(210, 210, 210, 1.0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 0, 18.0, 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Additional Charge",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        width: 42,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 3),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                extra_charges = value;
                              });
                            },
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey), // Color of the bottom border when not focused
                              ),
                              hintText: 'Amt',
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .black), // Color of the bottom border when focused
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: const Color.fromRGBO(210, 210, 210, 1.0),
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 0, 18.0, 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Special Note",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 3),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              note = value;
                            });
                          },
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .grey), // Color of the bottom border when not focused
                            ),
                            hintText: 'Enter note',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .black), // Color of the bottom border when focused
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 36,
                color: const Color.fromRGBO(210, 210, 210, 1.0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 0, 18.0, 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Delivery Charges",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        width: 42,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 3),
                          child: TextField(
                            controller: txtCharges,
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey), // Color of the bottom border when not focused
                              ),
                              hintText: 'Amt',
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .black), // Color of the bottom border when focused
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 46,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Amount",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 3),
                        child: Text(
                          delivery_charges,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(190, 58, 58, 1.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
                child: Container(
                  color: const Color.fromRGBO(210, 210, 210, 1.0),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 10, 18, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, '/screens/AddIssue');
                          // submit();
                          _navigateAndDisplaySelection(context);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(
                              236, 71, 0, 1.0), // Background color
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
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(12.0, 4, 12, 4),
                          child: Text(
                            "Add Issue",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        arr9.length > 0
                            ? "${arr9.length} " "issue found"
                            : "No issue found",
                        style: const TextStyle(
                          fontSize: 22,
                          color: Color.fromRGBO(182, 182, 182, 1.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 3,
                child: Container(
                  color: const Color.fromRGBO(210, 210, 210, 1.0),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: const Text(
                  "Select Delivery Date",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromRGBO(6, 6, 6, 1),
                  ),
                ),
              ),
              Container(
                height: 30,
                margin: const EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  selectedDate.day.toString() +
                      '-' +
                      listOfMonths[selectedDate.month - 1] +
                      ', ' +
                      selectedDate.year.toString(),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.indigo[700]),
                ),
              ),
              Container(
                  height: 90,
                  margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: Container(
                      color: const Color(0xFFEAEAEA),
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(width: 10);
                        },
                        itemCount: 7,
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              final DateFormat formatter =
                                  DateFormat('dd-MM-yyyy');
                              String formattedDateSe = formatter.format(
                                  DateTime.now().add(Duration(days: index)));
                              setState(() {
                                currentDateSelectedIndex = index.toString();
                                selectedDate = DateTime.now()
                                    .add(Duration(days: index + 1));
                                formattedDate = formattedDateSe;
                              });
                            },
                            child: Container(
                              height: 97,
                              width: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  currentDateSelectedIndex == ''
                                      ? const BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0, 0),
                                          blurRadius: 0,
                                        )
                                      : currentDateSelectedIndex ==
                                              index.toString()
                                          ? const BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(2, 2),
                                              blurRadius: 5)
                                          : const BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(0, 0),
                                              blurRadius: 0,
                                            ),
                                ],
                                color: currentDateSelectedIndex == ''
                                    ? const Color(0xFFEAEAEA)
                                    : currentDateSelectedIndex ==
                                            index.toString()
                                        ? const Color(0xFF5C88DA)
                                        : const Color(0xFFEAEAEA),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    listOfMonths[DateTime.now()
                                                .add(Duration(days: index + 1))
                                                .month -
                                            1]
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: currentDateSelectedIndex == ''
                                            ? Colors.black
                                            : currentDateSelectedIndex ==
                                                    index.toString()
                                                ? Colors.white
                                                : Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    DateTime.now()
                                        .add(Duration(days: index + 1))
                                        .day
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: currentDateSelectedIndex == ''
                                            ? Colors.black
                                            : currentDateSelectedIndex ==
                                                    index.toString()
                                                ? Colors.white
                                                : Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    listOfDays[DateTime.now()
                                                .add(Duration(days: index + 1))
                                                .weekday -
                                            1]
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: currentDateSelectedIndex == ''
                                            ? Colors.black
                                            : currentDateSelectedIndex ==
                                                    index.toString()
                                                ? Colors.white
                                                : Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ))),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: const Text(
                  "Select Delivery Time*",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                height: 38,
                margin: const EdgeInsets.fromLTRB(12, 12, 4, 12),
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(width: 10);
                  },
                  itemCount: timeArr.length,
                  scrollDirection: Axis.horizontal,
                  controller: scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    List<String> textList =
                        timeArr[index]['schedule_range'].split(' ');
                    return InkWell(
                      onTap: () {
                        setState(() {
                          currentDateSelectedIndex1 = index.toString();
                          // selectedDate =
                          //     DateTime.now().add(Duration(days: index));
                          time = timeArr[index]['schedule_range'].toString();
                        });
                        log('@@@ ${selectedDate}');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            currentDateSelectedIndex1 == ''
                                ? const BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 0),
                                    blurRadius: 0,
                                  )
                                : currentDateSelectedIndex1 == index.toString()
                                    ? const BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(2, 2),
                                        blurRadius: 5)
                                    : const BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0, 0),
                                        blurRadius: 0,
                                      ),
                          ],
                          color: currentDateSelectedIndex1 == ''
                              ? const Color(0xFFEAEAEA)
                              : currentDateSelectedIndex1 == index.toString()
                                  ? const Color.fromRGBO(92, 136, 218, 1.0)
                                  : const Color(0xFFEAEAEA),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(2.0),
                          width: 82,
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: textList[0],
                                  style: TextStyle(
                                      color: currentDateSelectedIndex1 == ''
                                          ? Colors.black
                                          : currentDateSelectedIndex1 ==
                                                  index.toString()
                                              ? Colors.white
                                              : Colors.black,
                                      fontSize: 16),
                                ),
                                TextSpan(
                                  text: "\n    " + textList[1],
                                  style: TextStyle(
                                    color: currentDateSelectedIndex1 == ''
                                        ? Colors.black
                                        : currentDateSelectedIndex1 ==
                                                index.toString()
                                            ? Colors.white
                                            : Colors.black,
                                    // fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
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
              Container(
                width: MediaQuery.of(context).size.width - 180,
                height: 52,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                child: TextButton(
                  onPressed: () {
                    _submit();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(
                        28, 41, 65, 1.0), // Background color
                    // padding: EdgeInsets.symmetric(
                    //     horizontal: 20, vertical: 10), // Padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9), // Button shape
                    ),
                    // textStyle: TextStyle(fontSize: 16), // Text style
                    alignment:
                        Alignment.center, // Alignment of text within the button
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 4, 12, 4),
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
        ]),
      ),
    );
  }
}
