import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/screens/PickupOrder.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/services/global.dart';
import 'package:ishtri_db/statemanagemnt/provider/DBProfileDataProvider.dart';
import 'package:ishtri_db/statemanagemnt/provider/OrderDataProvider.dart';
import 'package:ishtri_db/widgets/CButton.dart';
import 'package:provider/provider.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List usersorde = [];
  List<String> category = [
    'In Hand',
    'In Laundry',
    'Delivered',
  ];

  var otp1 = '', otp2 = '', otp3 = '', otp4 = '';
  commonValidation() {}
  _passwordController() {}
  FocusNode _firstFocusNode = FocusNode();
  FocusNode _secondFocusNode = FocusNode();
  FocusNode _thirdFocusNode = FocusNode();
  FocusNode _forthFocusNode = FocusNode();
  dynamic newPickup = [],
      order = [],
      helper = [],
      inHand = [],
      orderDelivered = [];
  String currentSelectedIndex = '0'; //For Horizontal Date
  int currentCateSelectedIndex = 0;
  ScrollController _scrollController = ScrollController();
  ScrollController scrollController = ScrollController();
  int page = 0, count = 19, indexCount = 0;
  String helper_id = '';
  var issueList = [];
  String id = '', details = '', name = '';
  int _currentIndex = 0;
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    print(index);
    // Get.toNamed(_widgetOptions.elementAt(index));
    setState(() {
      _selectedIndex = index;
    });
  }

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      _details();
    });
    Future.delayed(Duration(seconds: 2), () {
      _helpers();
      _inLaundryOrder();
      // _inDeliveredOrder();
    });
    _orders();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // User has reached the end of the list, load more data.
        _orders();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _details() async {
    var arr = [];
    setState(() {
      arr = [];
    });
    Future.delayed(Duration(seconds: 1), () {
      showLoader(context);
    });
    await Provider.of<DBProfileDataProvider>(context, listen: false)
        .profileData(context);
    var res = await Provider.of<DBProfileDataProvider>(context, listen: false)
        .dBdetails;
    if (res?.status == 1) {
      arr.add({
        "name": res?.data![0].dbDetails?.firstName,
        "lastName": res?.data![0].dbDetails?.lastName,
        "dob": res?.data![0].dbDetails?.dob,
        "id": res?.data![0].dbDetails?.dbId,
      });
      setState(() {
        helper = arr;
      });
      log('@@ ${res?.data![0].dbDetails?.dbId}');
      Future.delayed(Duration(seconds: 1), () {
        hideLoader(context);
      });
    } else {
      Future.delayed(Duration(seconds: 1), () {
        hideLoader(context);
      });
    }
  }

  Widget paymentDialog(data, product) {
    log('@@ ${issueList}');
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          height: 200,
          width: MediaQuery.of(context).size.width - 90,
          child: Column(
            children: [
              Container(
                // height: 200,
                margin: EdgeInsets.only(bottom: 10),
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
                              style: TextStyle(
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
                          'Pay all amount first to LS',
                          style: TextStyle(
                              color: blackColor,
                              fontFamily: "Poppins-Regular",
                              fontSize: 16),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: ActionButton("Skip", () {
                                  Navigator.pop(context);
                                  _skipPayment(data, product);
                                }, MediaQuery.of(context).size.width * 0.25,
                                    HexColor('#1C2941'), whiteColor),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: ActionButton(
                                    "Pay ${product['total_price']}", () {
                                  Navigator.pop(context);
                                  _makePaymentVerify(data, product);
                                }, MediaQuery.of(context).size.width * 0.25,
                                    successGreen, whiteColor),
                              ),
                            ],
                          ),
                        ],
                      )
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

  Widget issueDialog() {
    log('@@ ${issueList}');
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return ListView.builder(
          itemCount: issueList.length,
          itemBuilder: (context, index) {
            return Container(
              height: 200,
              width: MediaQuery.of(context).size.width - 90,
              child: Column(
                children: [
                  Container(
                    // height: 200,
                    margin: EdgeInsets.only(bottom: 10),
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
                            child: Text(
                              id,
                              style: TextStyle(
                                  color: blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0, left: 3),
                            child: Row(
                              children: [
                                const Text(
                                  "Issue no",
                                  style: TextStyle(
                                      color: lightBlackColor,
                                      fontFamily: "Poppins-Regular"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                        color: blackColor,
                                        fontFamily: "Poppins-Regular"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, left: 3),
                            child: Row(
                              children: [
                                Text(
                                  issueList[index]['issue_type']['type'] ?? '',
                                  style: TextStyle(
                                      color: blackColor,
                                      fontFamily: "Poppins-Regular",
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 0, left: 3),
                            child: Row(
                              children: [
                                Text(
                                  "Details",
                                  style: TextStyle(
                                      color: lightBlackColor,
                                      fontFamily: "Poppins-Regular"),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, left: 3),
                            child: Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 142,
                                  child: Text(
                                    issueList[index]['issue_details'],
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: blackColor,
                                        fontFamily: "Poppins-Regular",
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              log("choose photot");
                            },
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10, left: 3),
                              child: Row(
                                children: [
                                  Text(
                                    "Photo Proof",
                                    style: TextStyle(
                                        color: lightBlackColor,
                                        fontFamily: "Poppins-Regular",
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            // decoration: const BoxDecoration(color: redColor),
                            padding: EdgeInsets.only(bottom: 10),
                            child:
                                // CarouselSlider(
                                //   items: issueList
                                //       .map((item) =>
                                SizedBox(
                              height: 130,
                              width: MediaQuery.of(context).size.width * 0.70,
                              child: Image.network(
                                  issueList[index]['new_file_name'].toString(),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          // .toList(),
                          // options: CarouselOptions(
                          //   height: 130,
                          //   // height: MediaQuery.of(context).size.height < 750
                          //   //     ? MediaQuery.of(context).size.height * 0.35
                          //   //     : MediaQuery.of(context).size.height * 0.308,
                          //   autoPlay: false,
                          //   //enlargeCenterPage: true,
                          //   initialPage: _currentIndex,
                          //   //height: MediaQuery.of(context).size.height / 4,
                          //   viewportFraction: 1,
                          //   //scrollDirection: Axis.vertical,
                          //   onPageChanged: (index, reason) {
                          //     setState(
                          //       () {
                          //         _currentIndex = index;
                          //       },
                          //     );
                          //   },
                          // ),
                          // ),
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                issueList[index]['status'] == 1
                                    ? 'Acknowledgement pending'
                                    : issueList[index]['status'] == 3
                                        ? "Issue rejected by customer"
                                        : "Known Issue",
                                style: TextStyle(
                                  color: issueList[index]['status'] == 2
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 12,
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
          scrollDirection: Axis.horizontal,
        );
      },
    );
  }

  void showItems(data, o_id) async {
    log('@@ ${data}');
    setState(() {
      issueList = data;
      id = o_id;
    });
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Container(
              height: 420,
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: issueDialog(),
            ),
          );
        });
  }

  void _orders() async {
    try {
      var arr = [], arr1 = [], data = "", data2 = '';
      // Future.delayed(Duration(seconds: 1), () {
      //   showLoader(context);
      // });
      data = "page=${page}" + '&' + "limit=${count}";
      data2 = "page=${page}" +
          '&' +
          "limit=${count}" +
          '&' +
          "helper_id=${helper_id.toString()}";
      final data1 = await ApiService().sendGetRequest(
          '/v1/delivery-boy/order/in-hand-order-list?${helper_id == '' ? data : data2}');
      // .sendGetRequest('/v1/delivery-boy/customer/schedule-list');
      if (kDebugMode) {
        log('@@ 457${data1['data']['data']}');
      }
      if (data1['data']['status'] == 1) {
        var arr = [];
        var mes = '';
        final res = {};
        if (data1['data']['status'] == 1) {
          data1['data']['data'].forEach((element) {
            // log('@@@ ${element}');
            if (element['order_status'] == 1) {
              arr.add({
                "id": element['id'] ?? '',
                "order_unique_id": element['order_unique_id'] ?? '',
                "name":
                    "${element['customer']['firstName']} ${element['customer']['lastName']}" ??
                        '',
                "uId": element['customer']['id'] ?? '',
                "pickup_request_date": element['pickup_request_date'] ?? '',
                "pickup_request_time": element['pickup_request_time'] ?? '',
                "orderQty": element['order_total_quantity'] ?? '',
                "customer_id": element['customer']['id'] ?? '',
                // "pickup_request_time": element['pickup_request_time'] ?? '',
                "order_status": element['order_status'] ?? '',
              });
            } else if (element['order_status'] == 2 ||
                element['order_status'] == 9) {
              arr1.add({
                "id": element['id'] ?? '',
                "order_unique_id": element['order_unique_id'] ?? '',
                "name":
                    "${element['customer']['firstName']} ${element['customer']['lastName']}" ??
                        '',
                "uId": element['customer']['id'] ?? '',
                "pickup_request_date": element['pickup_request_date'] ?? '',
                "pickup_request_time": element['pickup_request_time'] ?? '',
                "orderQty": element['order_total_quantity'] ?? '',
                "customer_id": element['customer']['id'] ?? '',
                // "pickup_request_time": element['pickup_request_time'],
                "order_status": element['order_status'] ?? '',
              });
            } else if (element['order_status'] == 6 ||
                element['order_status'] == 7 ||
                element['order_status'] == 11) {
              arr1.add({
                "id": element['id'] ?? '',
                "order_unique_id": element['order_unique_id'] ?? '',
                "name":
                    "${element['customer']['firstName']} ${element['customer']['lastName']}" ??
                        '',
                "uId": element['customer']['id'] ?? '',
                "pickup_request_date": element['pickup_request_date'] ?? '',
                "pickup_request_time": element['pickup_request_time'] ?? '',
                "orderQty": element['order_total_quantity'] ?? '',
                "customer_id": element['customer']['id'] ?? '',
                // "pickup_request_time": element['pickup_request_time'],
                "order_status": element['order_status'] ?? '',
                "order_issues": element['order_issues'] ?? '',
              });
            }
          });
        }
        setState(() {
          newPickup = arr;
          order = arr1;
        });
        log('@@@ ${arr}');
        // hideLoader(context);
      } else {
        var arr = [];
        var mes = '';
        for (var i = 0; i < data1['data']['data'].length; i++) {
          // log('@@@ ${res['data'][i]}');
          arr.add(data1['data']['data'][i]);
        }

        for (dynamic item in arr) {
          item.forEach((key, value) {
            print('Key: $key, Value: $value');
            mes = '${mes} ' + value.replaceAll('"', '') + '.';
          });
        }
        // hideLoader(context);
        // var mes = reg?.data![0].message;
        toast(mes!);
      }
      // hideLoader(context);
    } catch (ex) {
      if (kDebugMode) {
        print('x');
      }
      if (kDebugMode) {
        print(ex);
      }
      // Future.delayed(const Duration(milliseconds: 200), () {
      //   hideLoader(context);
      // });
    } catch (e) {}

    // ignore: use_build_context_synchronously
    Future.delayed(Duration(seconds: 2), () {
      // hideLoader(context);
    });
  }

  void _helpers() async {
    try {
      var arr = [], arr1 = [], data = {};
      Future.delayed(Duration(seconds: 1), () {
        showLoader(context);
      });
      final data1 = await ApiService().sendGetRequest(
          '/v1/delivery-boy/helper/helper-list-without-pagination');
      if (kDebugMode) {
        log('@@ 570${data1['data']}');
      }
      if (data1['data']['status'] == 1) {
        var arr = [];
        var mes = '';
        final res = {};
        data1['data']['data']?.forEach((element) {
          arr.add({
            "id": element['id'],
            "name": element['firstName'],
            "lastName": element['lastName'],
            "dob": element['dob'],
          });
        });
        setState(() {
          usersorde = helper + arr;
        });
        hideLoader(context);
      } else {
        var arr = [];
        var mes = '';
        for (var i = 0; i < data1['data']['data'].length; i++) {
          arr.add(data1['data']['data'][i]);
        }

        for (dynamic item in arr) {
          item.forEach((key, value) {
            print('Key: $key, Value: $value');
            mes = '${mes} ' + value.replaceAll('"', '') + '.';
          });
        }
        hideLoader(context);
        toast(mes!);
      }
      hideLoader(context);
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

    // ignore: use_build_context_synchronously
    Future.delayed(Duration(seconds: 2), () {
      hideLoader(context);
    });
  }

  void _acceptReject(String pickup, String id) async {
    try {
      var data = {
        "order_id": id,
        "order_status": pickup,
      };
      // Future.delayed(Duration(seconds: 1), () {
      //   showLoader(context);
      // });
      final data1 = await ApiService().sendPostRequest(
          '/v1/delivery-boy/order/accept-pickup-request', data);
      if (kDebugMode) {
        log('@@ ${data1['data']}');
      }
      if (data1['data']['status'] == 1) {
        setState(() {
          newPickup = newPickup.removeWhere((item) => item['id'] == id);
        });
        Future.delayed(Duration(seconds: 1), () {
          _orders();
        });
      } else {
        hideLoader(context);
      }
      hideLoader(context);
    } catch (ex) {
      hideLoader(context);
    }
    hideLoader(context);
  }

  void _acceptCloth(dynamic inhand, dynamic product) async {
    try {
      var data = {
        "order_id": inhand['id'],
        "order_details_id": product['id'],
      };
      log('@@@ ${data}');
      Future.delayed(Duration(seconds: 1), () {
        showLoader(context);
      });
      hideLoader(context);
      final data1 = await ApiService().sendPostRequest(
          '/v1/delivery-boy/order/accept-cloths-from-ls', data);
      if (kDebugMode) {
        log('@@ ${data1['data']}');
      }
      if (data1['data']['status'] == 1) {
        Future.delayed(Duration(seconds: 1), () {
          _orders();
          _inLaundryOrder();
        });
      } else {
        hideLoader(context);
      }
      hideLoader(context);
    } catch (ex) {
      hideLoader(context);
    }
    hideLoader(context);
  }

  void _selfClothOrder(dynamic inhand, dynamic product) async {
    try {
      var data = {
        "order_id": inhand['id'],
        "order_details_id": product['id'],
      };
      log('@@@ ${data}');
      Future.delayed(Duration(seconds: 1), () {
        showLoader(context);
      });
      hideLoader(context);
      final data1 = await ApiService().sendPostRequest(
          '/v1/delivery-boy/order/make-self-order-ready', data);
      if (kDebugMode) {
        log('@@ ${data1['data']}');
      }
      if (data1['data']['status'] == 1) {
        var res = data1['data']['message'];
        showErrorPopup(context, 'Success', res);
        Future.delayed(Duration(seconds: 1), () {
          _inLaundryOrder();
        });
      } else {
        hideLoader(context);
      }
      hideLoader(context);
    } catch (ex) {
      hideLoader(context);
    }
    hideLoader(context);
  }

  void _handovercs(dynamic inhand) async {
    try {
      var data = {
        "order_id": inhand,
      };
      // log('@@@ ${data}');
      // Future.delayed(Duration(seconds: 1), () {
      //   showLoader(context);
      // });
      hideLoader(context);
      final data1 = await ApiService().sendPostRequest(
          '/v1/delivery-boy/order/deliver-order-to-customer', data);
      if (kDebugMode) {
        log('@@ ${data1['data']}');
      }
      if (data1['data']['status'] == 1) {
        // Future.delayed(Duration(seconds: 1), () {
        _orders();
        hideLoader(context);
        showErrorPopup(context, 'Success', data['data']['message']!);

        // Navigator.pop(context);

        // });
      } else {
        _orders();
        var arr = [];
        var mes = '';
        for (var i = 0; i < data1['data']['data'].length; i++) {
          // log('@@@ ${res['data'][i]}');
          arr.add(data1['data']['data'][i]);
        }

        for (dynamic item in arr) {
          item.forEach((key, value) {
            print('Key: $key, Value: $value');
            if (value != false) {
              mes = mes + value + '.';
            }
          });
        }
        showErrorPopup(context, 'Error', mes!);
        hideLoader(context);
      }
      hideLoader(context);
    } catch (ex) {
      hideLoader(context);
    }
    hideLoader(context);
  }

  void _makePaymentVerify(dynamic inhand, dynamic product) async {
    try {
      var data = {
        "order_id": inhand['id'],
        "order_details_id": product['id'],
        "paid_amount": product['total_price'],
        "payment_otp": otp1 + otp2 + otp3 + otp4,
      };
      log('@@ ${data}');
      // Future.delayed(Duration(seconds: 1), () {
      //   showLoader(context);
      // });
      final data1 = await ApiService()
          .sendPostRequest('/v1/delivery-boy/order/make-payment-to-ls', data);
      if (kDebugMode) {
        log('@@ ${data1['data']['status'] == 1}');
      }
      if (data1['data']['status'] == 1) {
        showErrorPopup(context, 'Success', data1['data']['message']);
        // hideLoader(context);
        Future.delayed(Duration(milliseconds: 100), () {
          // _orders();
          _inLaundryOrder();
        });
      } else {
        showErrorPopup(context, 'Error! ', 'Something want wrong');
        // log('@@>>>>>>');
        // Future.delayed(Duration(milliseconds: 200), () {
        //   hideLoader(context);
        // });
      }
    } catch (ex) {
      // hideLoader(context);
    }
    // hideLoader(context);
  }

  void _getPaymentotp(dynamic inhand, dynamic product) async {
    try {
      var data = {
        "order_details_id": product['id'],
        "ls_id": product['laundry']['id'],
      };
      log('@@ ${data}');
      // Future.delayed(Duration(seconds: 1), () {
      //   showLoader(context);
      // });
      final data1 = await ApiService()
          .sendPostRequest('/v1/delivery-boy/order/order-payment-otp', data);
      if (kDebugMode) {
        log('@@ ${data1['data']['status'] == 1}');
      }
      if (data1['data']['status'] == 1) {
        // hideLoader(context);
        showErrorPopup(context, 'Success', data1['data']['message']);

        showOtpDialog(inhand, product);
      } else {
        showErrorPopup(context, 'Error! ', 'Something want wrong');
        // log('@@>>>>>>');
        // Future.delayed(Duration(milliseconds: 200), () {
        //   hideLoader(context);
        // });
      }
    } catch (ex) {
      // hideLoader(context);
    }
    // hideLoader(context);
  }

  void _skipPayment(dynamic inhand, dynamic product) async {
    try {
      var data = {
        "order_id": inhand['id'],
        "order_details_id": product['id'],
      };
      log('@@ ${data}');
      Future.delayed(Duration(seconds: 1), () {
        showLoader(context);
      });
      final data1 = await ApiService()
          .sendPostRequest('/v1/delivery-boy/order/make-payment-to-ls', data);
      if (kDebugMode) {
        log('@@ ${data1['data']['status'] == 1}');
      }
      if (data1['data']['status'] == 1) {
        showErrorPopup(context, 'Success', data1['data']['message']);
        hideLoader(context);
        Future.delayed(Duration(milliseconds: 100), () {
          // _orders();
          _inLaundryOrder();
        });
      } else {
        showErrorPopup(context, 'Error! ', 'Something want wrong');
        // log('@@>>>>>>');
        // Future.delayed(Duration(milliseconds: 200), () {
        //   hideLoader(context);
        // });
      }
    } catch (ex) {
      hideLoader(context);
    }
    hideLoader(context);
  }

  void iKnow(dynamic inhand, dynamic product, index, index2) async {
    log('@@@ ${product['order_details']}');
    try {
      var data = {
        "order_id": product['id'],
        "order_details_id": product['order_details'][index2]['id'],
        "laundry_order_issue_id": inhand['id'],
        "order_status": "1"
      };
      log('@@ ${data}');
      // Future.delayed(Duration(seconds: 1), () {
      //   showLoader(context);
      // });
      final data1 = await ApiService().sendPostRequest(
          '/v1/delivery-boy/order/verify-ls-issue-action', data);
      if (kDebugMode) {
        log('@@ ${data1['data']['status']}');
      }
      if (data1['data']['status'] == 1) {
        showErrorPopup(context, 'Success', data1['data']['message']);
        // hideLoader(context);
        setState(() {
          inhand[index]['order_details']['laundry_order_issues'][index2]
              ['status'] = 2;
        });
        // Future.delayed(Duration(milliseconds: 100), () {
        //   // _orders();
        //   _inLaundryOrder();
        // });
        // hideLoader(context);
      } else {
        showErrorPopup(context, 'Error! ', 'Something want wrong');
        // hideLoader(context);
        Navigator.pop(context);
        // log('@@>>>>>>');
        // Future.delayed(Duration(milliseconds: 200), () {
        //   hideLoader(context);
        // });
      }
    } catch (ex) {
      // hideLoader(context);
    }
    // hideLoader(context);
  }

  void returnCloths(dynamic order, dynamic inhand, dynamic product, index,
      index2, index1) async {
    log('@@@ 91${order[index]['order_details'][index2]['laundry_order_issues']}');
    try {
      var data = {
        "order_id": product['id'],
        "order_details_id": product['order_details'][index2]['id'],
        "laundry_order_issue_id": inhand['id'],
      };
      log('@@ ${data}');
      Future.delayed(Duration(seconds: 1), () {
        showLoader(context);
      });
      final data1 = await ApiService().sendPostRequest(
          '/v1/delivery-boy/order/return-issue-product-from-ls-to-cs', data);
      if (kDebugMode) {
        log('@@ ${data1['data']}');
      }
      if (data1['data']['status'] == 1) {
        showErrorPopup(context, 'Success', data1['data']['message']);
        hideLoader(context);
        setState(() {
          inHand[index]['order_details'][index2]['laundry_order_issues'][index1]
              ['status'] = 2;
        });
        // Future.delayed(Duration(milliseconds: 100), () {
        //   // _orders();
        //   _inLaundryOrder();
        // });
        // hideLoader(context);
      } else {
        showErrorPopup(context, 'Error! ', 'Something want wrong');
        hideLoader(context);
        Navigator.pop(context);
        // log('@@>>>>>>');
        // Future.delayed(Duration(milliseconds: 200), () {
        //   hideLoader(context);
        // });
      }
    } catch (ex) {
      hideLoader(context);
    }
    // hideLoader(context);
  }

  void esltodb(dynamic inhand, dynamic product, index, index2) async {
    try {
      var data = {
        "order_id": product['id'],
        "order_details_id": product['order_details'][index2]['id'],
        "laundry_order_issue_id": inhand['id'],
        "order_status": "2",
      };
      log('@@ ${data}');
      // Future.delayed(Duration(seconds: 1), () {
      //   showLoader(context);
      // });
      final data1 = await ApiService().sendPostRequest(
          '/v1/delivery-boy/order/verify-ls-issue-action', data);
      if (kDebugMode) {
        log('@@ ${data1['data']['status'] == 1}');
      }
      if (data1['data']['status'] == 1) {
        showErrorPopup(context, 'Success', data1['data']['message']);
        // hideLoader(context);
        setState(() {
          inhand[index]['order_details']['laundry_order_issues'][index2]
              ['status'] = 3;
        });
        // Future.delayed(Duration(milliseconds: 100), () {
        //   _inLaundryOrder();
        // });
      } else {
        showErrorPopup(context, 'Error! ', 'Something want wrong');
        // log('@@>>>>>>');
        // Future.delayed(Duration(milliseconds: 200), () {
        //   hideLoader(context);
        // });
      }
    } catch (ex) {
      // hideLoader(context);
    }
    // hideLoader(context);
  }

  void show(data, product) async {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: paymentDialog(data, product),
            ),
          );
        });
  }

  void showIssue(inhand, data, product, index, index2) async {
    log('@@ issues1 ${inhand}');
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: double.maxFinite,
              height: 430,
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: issueDialogEsc(inhand, data, product, index, index2),
            ),
          );
        });
  }

  Widget issueDialogEsc(inhand, dataRaise, product, index1, index2) {
    log('@@ issues${dataRaise}');
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState1) {
        return Column(
          children: [
            CarouselSlider(
              items: [
                ListView.builder(
                  itemCount: dataRaise.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    details = dataRaise[index]['issue_details'] ?? '';
                    //  setState(() {

                    //  });
                    log('@@ inds ${index}');
                    return Container(
                      // height: 200,
                      margin: EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.only(
                          left: 19, right: 22, bottom: 15),
                      // color: Colors.white,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Container(
                          height: 700,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 10),
                                // child: Text(
                                //   id.toString() ?? '',
                                //   style: TextStyle(
                                //       color: blackColor,
                                //       fontWeight: FontWeight.w600,
                                //       fontSize: 16),
                                //   textAlign: TextAlign.center,
                                // ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 0, left: 3),
                                child: Row(
                                  children: [
                                    const Text(
                                      "Issue no",
                                      style: TextStyle(
                                          color: lightBlackColor,
                                          fontFamily: "Poppins-Regular"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        (int.parse(index.toString()) + 1)
                                                .toString() ??
                                            '',
                                        style: TextStyle(
                                            color: blackColor,
                                            fontFamily: "Poppins-Regular"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.only(bottom: 10, left: 3),
                              //   child: Row(
                              //     children: [
                              //       // Text(
                              //       //   name.toString() ?? '',
                              //       //   style: TextStyle(
                              //       //       color: blackColor,
                              //       //       fontFamily: "Poppins-Regular",
                              //       //       fontSize: 16),
                              //       // ),
                              //     ],
                              //   ),
                              // ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 0, left: 3),
                                child: Row(
                                  children: [
                                    Text(
                                      "Details",
                                      style: TextStyle(
                                          color: lightBlackColor,
                                          fontFamily: "Poppins-Regular"),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, left: 3),
                                child: Text(
                                  details.toString() ?? '',
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: blackColor,
                                      fontFamily: "Poppins-Regular",
                                      fontSize: 12),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10, left: 3),
                                child: Text(
                                  "Photo Proof",
                                  style: TextStyle(
                                      color: lightBlackColor,
                                      fontFamily: "Poppins-Regular",
                                      fontSize: 12),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: SizedBox(
                                  height: 130,
                                  width:
                                      MediaQuery.of(context).size.width * 0.70,
                                  child: Image.network(
                                      dataRaise[index]['new_file_name']
                                          .toString(),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 120,
                                child: dataRaise[index]['status'] == 1
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: ActionButton(
                                              "I Know",
                                              () {
                                                iKnow(dataRaise[index], product,
                                                    index1, index2);
                                              },
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25,
                                              successGreen,
                                              whiteColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: ActionButton(
                                                "Discuss With CS", () {
                                              esltodb(dataRaise[index], product,
                                                  index1, index2);
                                            },
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.42,
                                                darkBlueColor,
                                                whiteColor),
                                          ),
                                        ],
                                      )
                                    : dataRaise[index]['status'] == 2
                                        ? Center(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                vertical: 12,
                                              ),
                                              child: Text(
                                                'I know this issue.',
                                                style: TextStyle(
                                                  color: HexColor('#5B5B5B'),
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          )
                                        : dataRaise[index]['status'] == 4
                                            ? Column(
                                                children: [
                                                  Center(
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                        vertical: 9,
                                                      ),
                                                      child: Text(
                                                        'Rejected by customer',
                                                        style: TextStyle(
                                                          color: HexColor(
                                                              '#E44500'),
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    child: ActionButton(
                                                      "Return Cloths",
                                                      () {
                                                        returnCloths(
                                                            inhand,
                                                            dataRaise[index],
                                                            product,
                                                            index1,
                                                            index2,
                                                            index);
                                                      },
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.35,
                                                      successGreen,
                                                      whiteColor,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Center(
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                    vertical: 12,
                                                  ),
                                                  child: Text(
                                                    'Escalation to Customer',
                                                    style: TextStyle(
                                                      color:
                                                          HexColor('#5B5B5B'),
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
              options: CarouselOptions(
                height: 370,
                // height: MediaQuery.of(context).size.height < 750
                //     ? MediaQuery.of(context).size.height * 0.35
                //     : MediaQuery.of(context).size.height * 0.308,
                autoPlay: false,
                //enlargeCenterPage: true,
                initialPage: _currentIndex,
                //height: MediaQuery.of(context).size.height / 4,
                viewportFraction: 1,
                //scrollDirection: Axis.vertical,
                onPageChanged: (index, reason) {
                  log('@@@ ${_currentIndex}');
                  // setState(
                  //   () {
                  //     _currentIndex = index;
                  //   },
                  // );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (int i = 0; i < dataRaise.length; i++) ...[
                  // index = issue_order.indexOf(issue_order[i]),
                  Container(
                    width: 10.0,
                    height: 10.0,
                    margin: const EdgeInsets.only(
                        left: 5, right: 5, top: 0, bottom: 0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == i ? themeBlueColor : whiteColor,
                    ),
                  ),
                ]
              ]),
            ),
          ],
        );
      },
    );
  }

  void showIssueLaundry(data, product, index, index2) async {
    log('@@ issues ${data}');
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: double.maxFinite,
              height: 430,
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: laundryIssueDialog(data, product, index, index2),
            ),
          );
        });
  }

  Widget laundryIssueDialog(dataRaise, product, index1, index2) {
    log('@@ issues${dataRaise}');
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState1) {
        return Column(
          children: [
            CarouselSlider(
              items: [
                ListView.builder(
                  itemCount: dataRaise.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    details = dataRaise[index]['issue_details'] ?? '';
                    //  setState(() {

                    //  });
                    log('@@ inds ${index}');
                    return Container(
                      // height: 200,
                      margin: EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.only(
                          left: 19, right: 22, bottom: 15),
                      // color: Colors.white,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Container(
                          height: 700,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 10),
                                // child: Text(
                                //   id.toString() ?? '',
                                //   style: TextStyle(
                                //       color: blackColor,
                                //       fontWeight: FontWeight.w600,
                                //       fontSize: 16),
                                //   textAlign: TextAlign.center,
                                // ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 0, left: 3),
                                child: Row(
                                  children: [
                                    const Text(
                                      "Issue no",
                                      style: TextStyle(
                                          color: lightBlackColor,
                                          fontFamily: "Poppins-Regular"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        (int.parse(index.toString()) + 1)
                                                .toString() ??
                                            '',
                                        style: TextStyle(
                                            color: blackColor,
                                            fontFamily: "Poppins-Regular"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.only(bottom: 10, left: 3),
                              //   child: Row(
                              //     children: [
                              //       // Text(
                              //       //   name.toString() ?? '',
                              //       //   style: TextStyle(
                              //       //       color: blackColor,
                              //       //       fontFamily: "Poppins-Regular",
                              //       //       fontSize: 16),
                              //       // ),
                              //     ],
                              //   ),
                              // ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 0, left: 3),
                                child: Row(
                                  children: [
                                    Text(
                                      "Details",
                                      style: TextStyle(
                                          color: lightBlackColor,
                                          fontFamily: "Poppins-Regular"),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, left: 3),
                                child: Text(
                                  details.toString() ?? '',
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: blackColor,
                                      fontFamily: "Poppins-Regular",
                                      fontSize: 12),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10, left: 3),
                                child: Text(
                                  "Photo Proof",
                                  style: TextStyle(
                                      color: lightBlackColor,
                                      fontFamily: "Poppins-Regular",
                                      fontSize: 12),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: SizedBox(
                                  height: 130,
                                  width:
                                      MediaQuery.of(context).size.width * 0.70,
                                  child: Image.network(
                                      dataRaise[index]['new_file_name']
                                          .toString(),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 120,
                                child: dataRaise[index]['status'] == 1
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: ActionButton(
                                              "I Know",
                                              () {
                                                iKnow(dataRaise[index], product,
                                                    index1, index2);
                                              },
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25,
                                              successGreen,
                                              whiteColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: ActionButton(
                                                "Discuss With CS", () {
                                              esltodb(dataRaise[index], product,
                                                  index1, index2);
                                            },
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.42,
                                                darkBlueColor,
                                                whiteColor),
                                          ),
                                        ],
                                      )
                                    : dataRaise[index]['status'] == 2
                                        ? Center(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                vertical: 12,
                                              ),
                                              child: Text(
                                                'I know this issue.',
                                                style: TextStyle(
                                                  color: HexColor('#5B5B5B'),
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Center(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                vertical: 12,
                                              ),
                                              child: Text(
                                                'Escalation to Customer',
                                                style: TextStyle(
                                                  color: HexColor('#5B5B5B'),
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
              options: CarouselOptions(
                height: 360,
                // height: MediaQuery.of(context).size.height < 750
                //     ? MediaQuery.of(context).size.height * 0.35
                //     : MediaQuery.of(context).size.height * 0.308,
                autoPlay: false,
                //enlargeCenterPage: true,
                initialPage: _currentIndex,
                //height: MediaQuery.of(context).size.height / 4,
                viewportFraction: 1,
                //scrollDirection: Axis.vertical,
                onPageChanged: (index, reason) {
                  log('@@@ ${_currentIndex}');
                  // setState(
                  //   () {
                  //     _currentIndex = index;
                  //   },
                  // );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (int i = 0; i < dataRaise.length; i++) ...[
                  // index = issue_order.indexOf(issue_order[i]),
                  Container(
                    width: 10.0,
                    height: 10.0,
                    margin: const EdgeInsets.only(
                        left: 5, right: 5, top: 0, bottom: 0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == i ? themeBlueColor : whiteColor,
                    ),
                  ),
                ]
              ]),
            ),
          ],
        );
      },
    );
  }

  Future<void> _inLaundryOrder() async {
    try {
      var arr1 = [], data = "", data2 = "";
      Future.delayed(Duration(seconds: 1), () {
        showLoader(context);
      });
      data = "page=${page}" + '&' + "limit=${count}";
      data2 = "page=${page}" +
          '&' +
          "limit=${count}" +
          "&" +
          "helper_id=${helper_id.toString()}";
      final data1 = await ApiService().sendGetRequest(
          '/v1/delivery-boy/order/in-laundry-order-list?${helper_id == '' ? data : data2}');
      if (kDebugMode) {
        log('@@@ 781${data1['data']['data']}');
      }
      if (data1['data']['status'] == 1) {
        var arr = [];
        data1['data']['data'].forEach((element) {
          if (element['order_status'] == 10) {
            log('@@ ${element}');
            arr.add({
              "id": element['id'] ?? '',
              // "order_id": element['order_details']['id'] ?? '',
              "order_unique_id": element['order_unique_id'] ?? '',
              "name":
                  "${element['customer']['firstName']} ${element['customer']['lastName']}" ??
                      '',
              "uId": element['customer']['id'] ?? '',
              "pickup_request_date": element['pickup_request_date'] ?? '',
              "pickup_request_time": element['pickup_request_time'] ?? '',
              "customer_delivery_date": element['customer_delivery_date'] ?? '',
              "customer_delivery_time": element['customer_delivery_time'] ?? '',
              "order_details": element['order_details'] ?? '',
              // "customer_id": element['customer_id'] ?? '',
              // "pickup_request_time": element['pickup_request_time'] ?? '',
              "order_status": element['order_status'] ?? '',
              'customer_total_amount': element['customer_total_amount'] ?? ''
            });
          } else if (element['order_status'] == 9 ||
              element['order_status'] == 11 ||
              element['order_status'] == 6) {
            log('@@ ${element}');
            arr.add({
              "id": element['id'] ?? '',
              // "order_id": element['order_details']['id'] ?? '',
              "order_unique_id": element['order_unique_id'] ?? '',
              "name":
                  "${element['customer']['firstName']} ${element['customer']['lastName']}" ??
                      '',
              "uId": element['customer']['id'] ?? '',
              "pickup_request_date": element['pickup_request_date'] ?? '',
              "pickup_request_time": element['pickup_request_time'] ?? '',
              "customer_delivery_date": element['customer_delivery_date'] ?? '',
              "customer_delivery_time": element['customer_delivery_time'] ?? '',
              "order_details": element['order_details'] ?? '',
              // "customer_id": element['customer_id'] ?? '',
              // "pickup_request_time": element['pickup_request_time'] ?? '',
              "order_status": element['order_status'] ?? '',
              "customer": element['customer'] ?? '',
              'customer_total_amount': element['customer_total_amount'] ?? ''
            });
          }
        });
        setState(() {
          inHand = arr;
        });
        hideLoader(context);
      } else {
        var arr = [];
        var mes = '';
        for (var i = 0; i < data1['data']['data'].length; i++) {
          // log('@@@ ${res['data'][i]}');
          arr.add(data1['data']['data'][i]);
        }

        for (dynamic item in arr) {
          item.forEach((key, value) {
            print('Key: $key, Value: $value');
            mes = '${mes} ' + value.replaceAll('"', '') + '.';
          });
        }
        hideLoader(context);
        toast(mes!);
      }
      hideLoader(context);
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
      log('@@ ${e}');
    }

    // ignore: use_build_context_synchronously
    Future.delayed(Duration(seconds: 2), () {
      hideLoader(context);
    });
  }

  Future<void> _inDeliveredOrder() async {
    try {
      var arr1 = [], data = "";
      Future.delayed(Duration(seconds: 1), () {
        showLoader(context);
      });
      data = "page=${page}" + '&' + "limit=${count}";
      final data1 = await ApiService().sendGetRequest(
          '/v1/delivery-boy/order/delivered-order-list?${data}');
      if (kDebugMode) {
        log('@@ ${data1['data']['data']}');
      }
      if (data1['data']['status'] == 1) {
        var arr = [];
        var mes = '';
        data1['data']['data'].forEach((element) {
          // log('@@@ ${element}');
          if (element['order_status'] == 14 ||
              element['order_status'] == 13 ||
              element['order_status'] == 12) {
            arr.add({
              "id": element['id'] ?? '',
              "order_unique_id": element['order_unique_id'] ?? '',
              "name":
                  "${element['customer']['firstName']} ${element['customer']['lastName']}" ??
                      '',
              "uId": element['customer']['id'] ?? '',
              "customer_delivery_date": element['customer_delivery_date'] ?? '',
              "customer_delivery_time": element['customer_delivery_time'] ?? '',
              "orderQty": element['order_total_quantity'] ?? '',
              "customer_id": element['customer_id'] ?? '',
              "customer_order_amount": element['customer_total_amount'] ?? '',
              // "pickup_request_time": element['pickup_request_time'] ?? '',
              "order_status": element['order_status'] ?? '',
            });
          }
        });
        setState(() {
          orderDelivered = arr;
        });
        hideLoader(context);
      } else {
        var arr = [];
        var mes = '';
        for (var i = 0; i < data1['data']['data'].length; i++) {
          arr.add(data1['data']['data'][i]);
        }
        for (dynamic item in arr) {
          item.forEach((key, value) {
            print('Key: $key, Value: $value');
            mes = '${mes} ' + value.replaceAll('"', '') + '.';
          });
        }
        hideLoader(context);
        toast(mes!);
      }
      hideLoader(context);
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
      log('@@ ${e}');
    }
    // ignore: use_build_context_synchronously
    Future.delayed(Duration(seconds: 2), () {
      hideLoader(context);
    });
  }

  pickupNavig(BuildContext context, dynamic data, dynamic id, dynamic c_id,
      dynamic oid) async {
    // final result = await Navigator.pushNamed(context, "/screens/PickupOrder",
    //     arguments: {"id": id});

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PickupOrder(
                det: order,
                data: id,
                cs_id: c_id,
                uniq_id: oid,
              )),
    );

    // log('@@ result${result}');
    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;
    if (result == null) {
    } else {
      _orders();
    }
  }

  Widget otpDialog(data, product) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          height: 200,
          width: MediaQuery.of(context).size.width - 90,
          child: Column(
            children: [
              Container(
                // height: 200,
                margin: EdgeInsets.only(bottom: 10),
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
                              "Enter Otp".toUpperCase(),
                              style: TextStyle(
                                color: lightBlackColor,
                                fontFamily: "Poppins-bold",
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(7.0, 22, 7, 13),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: 42,
                              width: 48,
                              margin: const EdgeInsets.only(bottom: 19),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: TextField(
                                onChanged: (text) {
                                  otp1 = text;
                                  _secondFocusNode.requestFocus();
                                },
                                focusNode: _firstFocusNode,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0, // Set the desired font size
                                ),
                                decoration: const InputDecoration(
                                  fillColor: Colors.transparent,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 42,
                              width: 48,
                              margin: const EdgeInsets.only(bottom: 19),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: TextField(
                                onChanged: (text) {
                                  otp2 = text;
                                  _thirdFocusNode.requestFocus();
                                },
                                focusNode: _secondFocusNode,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 20.0, // Set the desired font size
                                ),
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  fillColor: Colors.transparent,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 42,
                              width: 48,
                              margin: const EdgeInsets.only(bottom: 19),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: TextField(
                                onChanged: (text) {
                                  otp3 = text;
                                  _forthFocusNode.requestFocus();
                                },
                                focusNode: _thirdFocusNode,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 20.0, // Set the desired font size
                                ),
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  fillColor: Colors.transparent,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 42,
                              width: 48,
                              margin: const EdgeInsets.only(bottom: 19),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: TextField(
                                onChanged: (text) {
                                  otp4 = text;
                                  _thirdFocusNode.requestFocus();
                                },
                                focusNode: _forthFocusNode,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 20.0, // Set the desired font size
                                ),
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  fillColor: Colors.transparent,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: ActionButton("Skip", () {
                                  Navigator.pop(context);
                                  _skipPayment(data, product);
                                }, MediaQuery.of(context).size.width * 0.25,
                                    HexColor('#1C2941'), whiteColor),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: ActionButton(
                                    "Pay ${product['total_price']}", () {
                                  Navigator.pop(context);
                                  _makePaymentVerify(data, product);
                                }, MediaQuery.of(context).size.width * 0.25,
                                    successGreen, whiteColor),
                              ),
                            ],
                          ),
                        ],
                      )
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

  void showOtpDialog(data, product) async {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: otpDialog(data, product),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        backgroundColor: const Color.fromRGBO(92, 136, 218, 1),
        centerTitle: true,
        leading: IconButton(
          icon: const Image(
            image: AssetImage("assets/images/Hover.png"),
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/screens/DeliveryBoyProfile");
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Color.fromRGBO(28, 41, 65, 1.0),
            height: 52,
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(width: 10);
              },
              itemCount: usersorde.length,
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.fromLTRB(0, 7, 0, 7),
                  child: InkWell(
                    onTap: () {
                      if (index == 0) {
                        setState(() {
                          currentSelectedIndex = index.toString();
                          helper_id = '';
                        });
                      } else {
                        setState(() {
                          currentSelectedIndex = index.toString();
                          helper_id = usersorde[index]['id'].toString();
                        });
                      }
                      index == 0 ? _orders() : _orders();
                      currentCateSelectedIndex == 0
                          ? _orders()
                          : currentCateSelectedIndex == 1
                              ? _inLaundryOrder()
                              : currentCateSelectedIndex == 2
                                  ? _inDeliveredOrder()
                                  : null;
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18.0, 0, 0, 0),
                      child: Container(
                        height: 33,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                          color: currentSelectedIndex.toString() ==
                                  index.toString()
                              ? const Color.fromRGBO(92, 136, 218, 1)
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              usersorde[index]['name'] +
                                  ' ' +
                                  usersorde[index]['lastName'],
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 2,
            color: const Color.fromRGBO(245, 245, 245, 1),
          ),
          Container(
            color: const Color.fromRGBO(28, 41, 65, 1.0),
            height: 52,
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(width: 33);
              },
              itemCount: category.length,
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.fromLTRB(0.0, 6, 0, 6),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        currentCateSelectedIndex = index;
                      });
                      index == 0
                          ? _orders()
                          : index == 1
                              ? _inLaundryOrder()
                              : _inDeliveredOrder();
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18.0, 0, 0, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          color: currentCateSelectedIndex == index
                              ? Color.fromRGBO(92, 136, 218, 1)
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              category[index],
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          newPickup?.length != 0 && currentCateSelectedIndex == 0
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(26, 163, 1, 1),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 9, 0, 9),
                      child: const Text(
                        "New Pickup Request",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          newPickup?.length != 0 && currentCateSelectedIndex == 0
              ? Container(
                  height: 120,
                  child: currentCateSelectedIndex == 0
                      ? newPickup?.length != 0
                          ? ListView.builder(
                              itemCount: newPickup.length,
                              scrollDirection: Axis.horizontal,
                              controller: scrollController,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(26, 163, 1, 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        18.0, 7, 18, 0),
                                    child: Column(
                                      children: [
                                        Container(
                                          // width: MediaQuery.of(context).size.width - 36,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(9)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 0,
                                                blurRadius: 4,
                                                // offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            newPickup[index][
                                                                    'pickup_request_date'] ??
                                                                '' +
                                                                    ' | ' +
                                                                    newPickup[
                                                                            index]
                                                                        [
                                                                        'pickup_request_time'] ??
                                                                '',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          Text(
                                                            newPickup[index][
                                                                    'order_unique_id'] ??
                                                                ''.toString(),
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        0,
                                                                        9,
                                                                        0,
                                                                        0),
                                                                child: Text(
                                                                  newPickup[
                                                                          index]
                                                                      ['name'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        0,
                                                                        4,
                                                                        0,
                                                                        0),
                                                                child: Text(
                                                                  newPickup[index]
                                                                              [
                                                                              'orderQty']
                                                                          .toString() ??
                                                                      '' +
                                                                          " Cloths",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .fromLTRB(0,
                                                                    18, 0, 0),
                                                            child: Row(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    _acceptReject(
                                                                        '2',
                                                                        newPickup[index]['id']
                                                                            .toString());
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: 33,
                                                                    width: 84,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              198,
                                                                              7,
                                                                              7,
                                                                              1),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            6),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "Reject"
                                                                            .toUpperCase(),
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    _acceptReject(
                                                                        '1',
                                                                        newPickup[index]['id']
                                                                            .toString());
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 84,
                                                                    height: 36,
                                                                    margin: const EdgeInsets
                                                                        .fromLTRB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              26,
                                                                              163,
                                                                              1,
                                                                              1),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            6),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "Accept"
                                                                            .toUpperCase(),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 11),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                          : Container()
                      : Container(),
                )
              : Container(),
          Expanded(
            child: Container(
              // margin: EdgeInsets.fromLTRB(0, 28, 0, 0),
              // width: MediaQuery.of(context).size.width - 36,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.all(Radius.circular(9)),
              //   color: Color.fromRGBO(92, 136, 218, 1),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.grey.withOpacity(0.5),
              //       spreadRadius: 0,
              //       blurRadius: 4,
              //       // offset: Offset(0, 3),
              //     ),
              //   ],
              // ),
              child: currentCateSelectedIndex == 0
                  ? order.length != 0
                      ? ListView.builder(
                          itemCount: order.length,
                          controller: scrollController,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 12),
                                  width: MediaQuery.of(context).size.width - 36,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(9)),
                                    color: Color.fromRGBO(92, 136, 218, 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        // offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                    // width: MediaQuery.of(context).size.width - 36,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(9)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 0,
                                          blurRadius: 4,
                                          // offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              order[index]['order_status'] == 6
                                                  ? showItems(
                                                      order[index]
                                                          ['order_issues'],
                                                      order[index]
                                                          ['order_unique_id'])
                                                  : order[index]['order_status'] ==
                                                              7 ||
                                                          order[index][
                                                                  'order_status'] ==
                                                              9
                                                      ? Navigator.pushNamed(
                                                          context,
                                                          '/screens/OrderDetails',
                                                          arguments: {
                                                              'id': order[index]
                                                                  ['id']
                                                            })
                                                      : null;
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        order[index][
                                                                'pickup_request_date'] +
                                                            ' | ' +
                                                            order[index][
                                                                'pickup_request_time'],
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        order[index][
                                                                'order_unique_id']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(
                                                                    0, 9, 0, 0),
                                                            child: Text(
                                                              order[index]
                                                                      ['name']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 4, 0, 0),
                                                            child: Text(
                                                              order[index][
                                                                          'orderQty']
                                                                      .toString() +
                                                                  " Cloths",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      order[index][
                                                                  'order_status'] ==
                                                              2
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      0.0,
                                                                      18,
                                                                      0,
                                                                      0),
                                                              child: Container(
                                                                width: 130,
                                                                height: 33,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: order[index]
                                                                              [
                                                                              'order_status'] ==
                                                                          7
                                                                      ? Colors
                                                                          .transparent
                                                                      : Color.fromRGBO(
                                                                          28,
                                                                          41,
                                                                          65,
                                                                          1),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            6),
                                                                  ),
                                                                ),
                                                                child:
                                                                    TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    // Navigator.pushNamed(
                                                                    //     context,
                                                                    //     "/screens/PickupOrder",
                                                                    //     arguments: {
                                                                    //       "id":
                                                                    //           order[index]['id'].toString()
                                                                    //     });
                                                                    pickupNavig(
                                                                        context,
                                                                        order,
                                                                        order[index]['id']
                                                                            .toString(),
                                                                        order[index]
                                                                            [
                                                                            'customer_id'],
                                                                        order[index]['order_unique_id']
                                                                            .toString());
                                                                  },
                                                                  child: Text(
                                                                    "Pickup Cloths"
                                                                        .toUpperCase(),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : order[index][
                                                                      'order_status'] ==
                                                                  11
                                                              ? Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          0.0,
                                                                          18,
                                                                          0,
                                                                          0),
                                                                  child:
                                                                      Container(
                                                                    width: 130,
                                                                    height: 33,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          // order[index]['order_status'] == 7 ||
                                                                          order[index]['order_status'] == 11
                                                                              ? Colors.green
                                                                              : Colors.transparent,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            6),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        // Navigator.pushNamed(
                                                                        //     context,
                                                                        //     "/screens/PickupOrder",
                                                                        //     arguments: {
                                                                        //       "id":
                                                                        //           order[index]['id'].toString()
                                                                        //     });
                                                                        _handovercs(
                                                                            order[index]['id'].toString());
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        "handover to cs"
                                                                            .toUpperCase(),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              10,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : Text(
                                                                  order[index][
                                                                              'order_status'] ==
                                                                          6
                                                                      ? "Acknowledgement pending"
                                                                      : order[index]['order_status'] ==
                                                                              7
                                                                          ? "Picked up"
                                                                          : order[index]['order_status'] == 9
                                                                              ? 'Partial order pickup'
                                                                              : "",
                                                                  style:
                                                                      TextStyle(
                                                                    color: order[index]['order_status'] ==
                                                                            1
                                                                        ? Colors
                                                                            .white
                                                                        : order[index]['order_status'] ==
                                                                                6
                                                                            ? Colors.red
                                                                            : order[index]['order_status'] == 7
                                                                                ? HexColor('#1AA301')
                                                                                : order[index]['order_status'] == 9
                                                                                    ? Colors.green
                                                                                    : null,
                                                                    fontSize:
                                                                        10,
                                                                  ),
                                                                ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          })
                      : null
                  : currentCateSelectedIndex == 1
                      ? ListView.builder(
                          itemCount: inHand.length,
                          controller: scrollController,
                          itemBuilder: (BuildContext context, int index) {
                            int count = 0;
                            for (int i = 0;
                                i < inHand[index]['order_details'].length;
                                i++) {
                              for (int j = 0;
                                  j <
                                      inHand[index]['order_details'][i]
                                              ['order_products']
                                          .length;
                                  j++) {
                                count = count +
                                    int.parse(inHand[index]['order_details'][i]
                                                ['order_products'][j]
                                            ['product_quantity']
                                        .toString());
                              }
                            }
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 28, 0, 0),
                                  width: MediaQuery.of(context).size.width - 36,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(9)),
                                    color: Color.fromRGBO(92, 136, 218, 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        // offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                    // width: MediaQuery.of(context).size.width - 36,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(9)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 0,
                                          blurRadius: 4,
                                          // offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Delivery: ${inHand[index]['customer_delivery_date']} | ${inHand[index]['customer_delivery_time']}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      inHand[index]
                                                          ['order_unique_id'],
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 9, 0, 0),
                                                  child: Text(
                                                    "${inHand[index]['name']}",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 4, 0, 0),
                                                  child: Text(
                                                    "${count} Cloths",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                Container(
                                                    height: inHand[index][
                                                                    'order_details']
                                                                .length ==
                                                            1
                                                        ? 70
                                                        : inHand[index]['order_details']
                                                                    .length ==
                                                                0
                                                            ? 0
                                                            : 120,
                                                    child: ListView.builder(
                                                      itemCount: inHand[index]
                                                              ['order_details']
                                                          .length,
                                                      controller:
                                                          scrollController,
                                                      itemBuilder:
                                                          (context, index1) {
                                                        log('@@ data${inHand[index]['order_details'][index1]['order_products']}');
                                                        int val = 0;
                                                        for (int j = 0;
                                                            j <
                                                                inHand[index]['order_details']
                                                                            [
                                                                            index1]
                                                                        [
                                                                        'order_products']
                                                                    .length;
                                                            j++) {
                                                          log('@@ ${inHand[index]['order_details'][index1]['order_products'][j]['product_quantity']}');
                                                          val = val +
                                                              int.parse(inHand[index]['order_details']
                                                                              [
                                                                              index1]
                                                                          [
                                                                          'order_products'][j]
                                                                      [
                                                                      'product_quantity']
                                                                  .toString());
                                                        }
                                                        log('@@ 229 ${val}');
                                                        return inHand[index][
                                                                            'order_details']
                                                                        [index1]
                                                                    [
                                                                    'laundry'] !=
                                                                null
                                                            ? Column(
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            12,
                                                                            0,
                                                                            0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              inHand[index]['order_details'][index1]['status'] == 1 && (inHand[index]['order_details'][index1]['laundry']['laundry_aditional_detail'] == null)
                                                                                  ? "Self"
                                                                                  : inHand[index]['order_details'][index1]['status'] == 1
                                                                                      ? "Cloth Received Pending by LS"
                                                                                      : inHand[index]['order_details'][index1]['status'] == 2
                                                                                          ? "Order not ready"
                                                                                          : inHand[index]['order_details'][index1]['status'] == 9
                                                                                              ? "Order not ready"
                                                                                              : inHand[index]['order_details'][index1]['status'] == 6
                                                                                                  ? "Order ready"
                                                                                                  : inHand[index]['order_details'][index1]['status'] == 7
                                                                                                      ? "Issue Raise"
                                                                                                      : inHand[index]['order_details'][index1]['status'] == 4
                                                                                                          ? "Order ready"
                                                                                                          : inHand[index]['order_details'][index1]['status'] == 3 || inHand[index]['order_details'][index1]['status'] == 5
                                                                                                              ? "Order ready"
                                                                                                              : "Order not ready", // Order not ready //
                                                                              style: TextStyle(
                                                                                fontSize: 10,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: inHand[index]['order_details'][index1]['status'] == 1 || inHand[index]['order_details'][index1]['status'] == 2 || inHand[index]['order_details'][index1]['status'] == 7 ? Colors.red : Colors.green, //red
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              "${inHand[index]['order_details'][index1]['laundry']['laundry_aditional_detail'] == null ? 'Self' : inHand[index]['order_details'][index1]['laundry']['laundry_aditional_detail']['laundry_name'].toString()} ${val.toString()} cloths",
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            inHand[index]['order_details'][index1]['laundry_order_issues'].length > 0
                                                                                ? InkWell(
                                                                                    onTap: () {
                                                                                      showIssue(inHand, inHand[index]['order_details'][index1]['laundry_order_issues'], inHand[index], index, index1);
                                                                                    },
                                                                                    child: Text(
                                                                                      "Closed Issues",
                                                                                      style: TextStyle(
                                                                                        fontSize: 14,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.red,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                : Container(),
                                                                          ],
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              140,
                                                                          height:
                                                                              33,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color: inHand[index]['order_details'][index1]['status'] == 1 && (inHand[index]['order_details'][index1]['laundry']['laundry_aditional_detail'] == null)
                                                                                ? Colors.red
                                                                                : inHand[index]['order_details'][index1]['status'] == 1 || inHand[index]['order_details'][index1]['status'] == 2 || inHand[index]['order_details'][index1]['status'] == 3
                                                                                    ? Color.fromRGBO(182, 182, 182, 1.0)
                                                                                    : inHand[index]['order_details'][index1]['status'] == 4 || inHand[index]['order_details'][index1]['status'] == 5
                                                                                        ? Colors.green
                                                                                        : inHand[index]['order_details'][index1]['status'] == 6
                                                                                            ? HexColor('#D2D2D2')
                                                                                            : inHand[index]['order_details'][index1]['status'] == 7
                                                                                                ? Colors.red
                                                                                                : HexColor('#D2D2D2'),
                                                                            borderRadius:
                                                                                BorderRadius.all(
                                                                              Radius.circular(6),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              inHand[index]['order_details'][index1]['status'] == 1 && (inHand[index]['order_details'][index1]['laundry']['laundry_aditional_detail'] == null)
                                                                                  ? _selfClothOrder(inHand[index], inHand[index]['order_details'][index1])
                                                                                  : inHand[index]['order_details'][index1]['status'] == 4
                                                                                      ? _acceptCloth(inHand[index], inHand[index]['order_details'][index1])
                                                                                      : inHand[index]['order_details'][index1]['status'] == 5
                                                                                          ? _getPaymentotp(inHand[index], inHand[index]['order_details'][index1]) //inHand[index]
                                                                                          : inHand[index]['order_details'][index1]['status'] == 7
                                                                                              ? showIssue(inHand, inHand[index]['order_details'][index1]['laundry_order_issues'], inHand[index], index, index1)
                                                                                              : null;
                                                                              // Navigator.pushNamed(context,
                                                                              //     "/screens/home");
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              inHand[index]['order_details'][index1]['status'] == 1 && (inHand[index]['order_details'][index1]['laundry']['laundry_aditional_detail'] == null)
                                                                                  ? "Order ready".toUpperCase()
                                                                                  : inHand[index]['order_details'][index1]['status'] == 1 || inHand[index]['order_details'][index1]['status'] == 2 || inHand[index]['order_details'][index1]['status'] == 4 || inHand[index]['order_details'][index1]['status'] == 9 || inHand[index]['order_details'][index1]['status'] == 3
                                                                                      ? "Accept Cloths"
                                                                                      : inHand[index]['order_details'][index1]['status'] == 5
                                                                                          ? "Make Payment".toUpperCase()
                                                                                          : inHand[index]['order_details'][index1]['status'] == 6
                                                                                              ? "Collected".toUpperCase()
                                                                                              : inHand[index]['order_details'][index1]['status'] == 7
                                                                                                  ? "Check Issue"
                                                                                                  : "", //
                                                                              style: const TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 10,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Container();
                                                      },
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          })
                      : ListView.builder(
                          itemCount: orderDelivered.length,
                          controller: scrollController,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 28, 0, 0),
                                  width: MediaQuery.of(context).size.width - 36,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(9)),
                                    color: Color.fromRGBO(92, 136, 218, 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        // offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                    // width: MediaQuery.of(context).size.width - 36,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(9)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 0,
                                          blurRadius: 4,
                                          // offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Delivery: ${orderDelivered[index]['customer_delivery_date']} | ${orderDelivered[index]['customer_delivery_time']}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      orderDelivered[index][
                                                              'order_unique_id']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 9, 0, 0),
                                                          child: Text(
                                                            orderDelivered[
                                                                index]['name'],
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 4, 0, 0),
                                                          child: Text(
                                                            "${orderDelivered[index]['orderQty']} Cloths",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 27, 0, 0),
                                                      child: Text(
                                                        orderDelivered[index][
                                                                    'order_status'] ==
                                                                13
                                                            ? "Payment Pending: Rs. ${orderDelivered[index]['customer_order_amount']}"
                                                            : orderDelivered[
                                                                            index]
                                                                        [
                                                                        'order_status'] ==
                                                                    14
                                                                ? "Payment Recived: Rs. ${orderDelivered[index]['customer_order_amount']}"
                                                                : "Confirmation Pending",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: orderDelivered[
                                                                          index]
                                                                      [
                                                                      'order_status'] ==
                                                                  14
                                                              ? Colors.green
                                                              : orderDelivered[
                                                                              index]
                                                                          [
                                                                          'order_status'] ==
                                                                      13
                                                                  ? Colors.red
                                                                  : Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
            ),
          ),
        ],
      ),
    );
  }
}
