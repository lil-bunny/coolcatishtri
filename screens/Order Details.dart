// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/services/global.dart';
import 'package:ishtri_db/widgets/CButton.dart';
import '../widgets/CustomDialog.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  dynamic order = [], orp = [], helper = null;
  var ls_id = '',
      order_unique_id = '',
      customer_id = '',
      pickup_request_date = '',
      pickup_request_time = '',
      customer_delivery_date = '',
      customer_delivery_time = '',
      delivery_boy,
      delivery_charges = '',
      total_order_price = '',
      l_id = '',
      l_name = '';
  int? od_id, db_id, customer_order_amount = 0;
  CustomDialog(BuildContext context, data, index1, price) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Select Laundry',
              style: TextStyle(
                fontSize: 14,
                fontFamily: '',
              ),
            ),
          ),
          Container(
            height: 2,
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 190,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: laundry.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => {
                        setState(() {
                          l_name = laundry[index]['name'];
                          l_id = laundry[index]['id'].toString();
                          order[index1]['laundry_sel'] = laundry[index]['name'];
                          currentCateSelectedIndex = index.toString();
                        }),
                        laundry[index]['name'] == "Self"
                            ?
                            // log('@@@ 80${orp[index]['order_products']}')
                            setState(() {
                                order[index1]['order_products'] =
                                    orp[index1]['order_products'];
                              })
                            : orderLaundry(
                                data, laundry[index]['id'], index1, price),
                        Navigator.of(context).pop()
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              height: 22,
                              width: 22,
                              margin: const EdgeInsets.fromLTRB(0, 0, 9, 0),
                              decoration: BoxDecoration(
                                  color: HexColor('#D9D9D9'),
                                  borderRadius: BorderRadius.circular(17)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 14,
                                    width: 14,
                                    decoration: BoxDecoration(
                                        color: currentCateSelectedIndex == ''
                                            ? null
                                            : currentCateSelectedIndex ==
                                                    index.toString()
                                                ? HexColor('#5C88DA')
                                                : null,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              laundry[index]['name'],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // To close the dialog
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  CustomHelperDialog(BuildContext context, data) {
    // DialogHelper();
    log('@@ $helper');
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          helper != null
              ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        helper['firstName'] + ' ' + helper['lastName'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: '',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Helper',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: '',
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
          Container(
            height: 2,
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => {Navigator.of(context).pop()},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 9, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  // var url = Uri.parse("tel:9776765434");
                                  // if (await canLaunchUrl(url)) {
                                  //   await launchUrl(url);
                                  // }
                                },
                                child: Image(
                                  height: 25,
                                  width: 25,
                                  image: AssetImage("assets/images/call.png"),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                'Call Now',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 7),
                  height: 33,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: HexColor('#5C88DA'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 7),
                  height: 33,
                  width: 125,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    color: HexColor('#1C2941'),
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        // Future.delayed(Duration(microseconds: 300), () {
                        //   Navigator.pop(context);
                        // });
                        Navigator.pushNamed(context, '/screens/ChangeHelper',
                            arguments: {
                              "order": order,
                              "order_id": order_unique_id,
                              "or_id": od_id,
                            });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Change helper",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showCustomHelper(BuildContext context, data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomHelperDialog(
            context, data); // Use the custom dialog widget here
      },
    );
  }

  void _showCustomDialog(BuildContext context, data, index, price) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
            context, data, index, price); // Use the custom dialog widget here
      },
    );
  }

  void show(data, total_price) async {
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
              child: paymentDialog(data, total_price),
            ),
          );
        });
  }

  _skipPayment(de_id, total_price) async {
    try {
      var data = {
        "order_id": od_id,
        "order_details_id": de_id,
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
      } else {
        showErrorPopup(context, 'Error! ', 'Something want wrong');
      }
    } catch (ex) {
      // hideLoader(context);
    }
    // hideLoader(context);
  }

  _makePayment(de_id, total_price) async {
    try {
      var data = {
        "ls_id": l_id,
        "amount": total_price,
      };
      log('@@ ${data}');
      // Future.delayed(Duration(seconds: 1), () {
      //   showLoader(context);
      // });
      final data1 = await ApiService()
          .sendPostRequest('/v1/delivery-boy/auth/payment-by-db-to-lS', data);
      if (kDebugMode) {
        log('@@ ${data1['data']['status'] == 1}');
      }
      if (data1['data']['status'] == 1) {
        showErrorPopup(context, 'Success', data1['data']['message']);
        // hideLoader(context);
      } else {
        showErrorPopup(context, 'Error! ', 'Something want wrong');
      }
    } catch (ex) {
      // hideLoader(context);
    }
    // hideLoader(context);
  }

  Widget paymentDialog(data, total_price) {
    // log('@@ ${issueList}');
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
                              "You have pending payment",
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
                          'Payment of Rs ${total_price} is due from you to ${l_name} Laundry. Please pay or Skip to proceed',
                          style: TextStyle(
                            color: blackColor,
                            fontFamily: "Poppins-Regular",
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
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
                                  _skipPayment(data, total_price);
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
                                child: ActionButton("Pay ${total_price}", () {
                                  Navigator.pop(context);
                                  _makePayment(data, total_price);
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

  int currentSelectedIndex = 0; //For Horizontal Date
  String currentCateSelectedIndex = '';
  bool isShow = false;
  ScrollController scrollController = ScrollController();
  bool isSelect = false;
  dynamic routes;
  List<dynamic> laundry = [];

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        context: context,
        builder: (BuildContext bc) {
          return SizedBox(
              height: 200,
              child: Expanded(
                child: ListView.builder(
                    itemCount: laundry.length,
                    scrollDirection: Axis.vertical,
                    controller: scrollController,
                    itemBuilder: (BuildContext context1, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 19.0, vertical: 12.0),
                        child: Container(
                          child: Text(
                            laundry[index],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }),
              ));
        });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      orderdetails(routes['id']);
      laundryList();
    });
  }

  laundryList() async {
    try {
      var arr = [], arr1 = [];
      arr.add({
        "name": "Self",
        "id": "",
      });
      Future.delayed(const Duration(seconds: 1), () {
        showLoader(context);
      });
      final data = await ApiService().sendGetRequest(
          '/v1/delivery-boy/laundry-service/laundry-list-dropdown');
      if (kDebugMode) {
        log('@@ ${data['data']['data']}');
      }
      if (data['data']['status'] == 1) {
        data['data']['data'].forEach((element) => {
              arr.add({
                "name": element['laundry_name'],
                "id": element['laundry_id']
              })
            });
        setState(() {
          laundry = arr;
        });
        hideLoader(context);
      } else {
        var arr = [];
        var mes = '';
        for (var i = 0; i < data['data']['data'].length; i++) {
          // log('@@@ ${res['data'][i]}');
          arr.add(data['data']['data'][i]);
        }

        for (dynamic item in arr) {
          item.forEach((key, value) {
            print('Key: $key, Value: $value');
            mes = '${mes} ' + value.replaceAll('"', '') + '.';
          });
        }
        hideLoader(context);
        // var mes = reg?.data![0].message;
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
    Future.delayed(const Duration(seconds: 2), () {
      hideLoader(context);
    });
  }

  orderdetails(id) async {
    try {
      var arr = [], arr1 = [], data = "";
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      data = '';
      final data1 = await ApiService()
          .sendGetRequest('/v1/delivery-boy/order/order-detail/${id}');
      if (kDebugMode) {
        log('@@ ${data1['data']['data']['helper']}');
      }
      if (data1['data']['status'] == 1) {
        hideLoader(context);
        setState(() {
          od_id = data1['data']['data']['id'];
          ls_id = data1['data']['data']['ls_id'] ?? '';
          db_id = data1['data']['data']['db_id'] ?? '';
          order_unique_id = data1['data']['data']['order_unique_id'] ?? '';
          pickup_request_date =
              data1['data']['data']['pickup_request_date'] ?? '';
          pickup_request_time =
              data1['data']['data']['pickup_request_time'] ?? '';
          customer_delivery_date =
              data1['data']['data']['customer_delivery_date'] ?? '';
          customer_delivery_time =
              data1['data']['data']['customer_delivery_time'] ?? '';
          customer_order_amount =
              data1['data']['data']['customer_total_amount'] ?? '';
          delivery_boy = data1['data']['data']['delivery_boy'] ?? '';
          delivery_charges =
              data1['data']['data']['customer_delivery_charge'].toString() ??
                  '';
          helper = data1['data']['data']['helper'];
        });

        data1['data']['data']['order_details'].forEach((element) => {
              if (data1['data']['data']['db_id'] == element['ls_id'] ||
                  element['ls_id'] != null)
                {
                  log('@@@ ${element}'),
                  for (int i = 0; i < element['order_products'].length; i++)
                    {
                      arr1.add({
                        "product_price": element['order_products'][i]
                            ['product_price'],
                        "total_price": element['order_products'][i]
                            ['total_price'],
                        "product_id": element['order_products'][i]
                            ['product_id'],
                        "product_quantity": element['order_products'][i]
                            ['product_quantity'],
                        "product_name": element['order_products'][i]['product']
                            ['product_name'],
                        "id": element['order_products'][i]['id'],
                      })
                    },
                  arr.add({
                    "id": element['id'],
                    "helper": data1['data']['data']['helper'],
                    "product_category_id": element['product_category_id'],
                    "total_price": element['total_price'],
                    "category_name": element['product_category']
                        ['category_name'],
                    "order_products": arr1,
                    "status": element['status'],
                    "isChoice": false,
                  })
                }
              else
                {
                  log('@@@ ${element}'),
                  for (int i = 0; i < element['order_products'].length; i++)
                    {
                      arr1.add({
                        "product_price": element['order_products'][i]
                            ['customer_product_price'],
                        "total_price": element['order_products'][i]
                            ['customer_total_price'],
                        "product_quantity": element['order_products'][i]
                            ['product_quantity'],
                        "product_name": element['order_products'][i]['product']
                            ['product_name'],
                        "id": element['order_products'][i]['id'],
                        "product_id": element['order_products'][i]
                            ['product_id'],
                      })
                    },
                  arr.add({
                    "id": element['id'],
                    "helper": element['helper'],
                    "product_category_id": element['product_category_id'],
                    "total_price": element['customer_total_price'],
                    "category_name": element['product_category']
                        ['category_name'],
                    "order_products": arr1,
                    "status": element['status'],
                    "isChoice": false,
                    "laundry_sel": null
                  })
                },
              arr1 = [],
            });

        setState(() {
          orp = arr;
          order = arr;
        });
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
        // var mes = reg?.data![0].message;
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
    Future.delayed(const Duration(seconds: 1), () {
      hideLoader(context);
    });
  }

  orderLaundry(dynamic dataPro, id, index, price) async {
    try {
      var arr = [], arr1 = [], arr2 = [], data = "";
      setState(() {
        arr = [];
        arr1 = [];
        arr2 = [];
      });
      int qty = 0;
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      final data1 = await ApiService().sendGetRequest(
          '/v1/delivery-boy/order/order-product-list/?ls_id=${id}');
      if (kDebugMode) {
        // log('@@ ${data1['data']['data']}');
      }
      if (data1['data']['status'] == 1) {
        hideLoader(context);
        data1['data']['data'].forEach((element) => {
              log('@@@ ${element}'),
              arr.add({
                "product_id": element['product_id'],
                "rate": element['rate'],
              })
            });
        log('@@ ${arr}');
        log('@@ >>>>>>>>>>${dataPro}');
        for (int i = 0; i < arr.length; i++) {
          log('@@@ 60${arr[i]}');
          for (int j = 0; j < dataPro.length; j++) {
            if (arr[i]['product_id'] == dataPro[j]['product_id']) {
              log('@@@ 6${dataPro[j]}');
              qty = (arr[i]['rate']) * (dataPro[j]['product_quantity']);
              log('@@@ ${qty}');
              arr1.add({
                "product_price": arr[i]['rate'],
                "total_price": qty,
                "product_name": dataPro[j]['product_name'],
                "id": dataPro[j]['id'],
                "product_id": dataPro[j]['product_id'],
                "product_quantity": dataPro[j]['product_quantity'],
              });
            }
          }
        }
        // [1, 8, 9, 3, 5];
        // [5, 3, 7, 9, 2];
        for (int j = 0; j < dataPro.length; j++) {
          for (int i = 0; i < arr1.length; i++) {
            if (arr1[i]['product_id'] != dataPro[j]['product_id']) {
              qty = qty + int.parse(dataPro[j]['total_price']);
              arr2.add({
                "product_price": arr1[j]['product_price'],
                "total_price": qty,
                "product_name": dataPro[j]['product_name'],
                "id": dataPro[j]['id'],
                "product_id": dataPro[j]['product_id'],
                "product_quantity": dataPro[j]['product_quantity']
              });
            }
          }
        }
        if (arr1.length == 0 && arr2.length == 0) {
          arr1 = dataPro;
          qty = price;
        }
        log('@@@ 831${arr1}');
        log('@@@ 832 ${arr2}');
        setState(() {
          // order = arr;
          order[index]['order_products'] = arr1; //+ arr2;
          order[index]['total_price'] = qty;
          arr1 = [];
        });
        log('@@@ 833 ${order}');
        int amt = 0;
        for (int i = 0; i < order.length; i++) {
          for (int j = 0; j < order[i]['order_products'].length; j++) {
            amt = amt +
                int.parse(
                    order[i]['order_products'][j]['total_price'].toString());
          }
        }
        setState(() {
          customer_order_amount = amt + int.parse(delivery_charges);
        });
        log('@@@ ${amt}');
        // {
        //     "product_price": 22,
        //     "total_price": 390,
        //     "product_quantity": 18,
        //     "product_name": "Jeans",
        //     id: 110,
        //     "product_id": 4
        //   };
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
        // var mes = reg?.data![0].message;
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
    Future.delayed(const Duration(seconds: 1), () {
      hideLoader(context);
    });
  }

  Future<void> confirmHand(
      product_category_id, order_products, total_price) async {
    try {
      dynamic arr = [], arr1 = [];
      Map<String, dynamic> data;
      // Future.delayed(Duration(seconds: 1), () {
      //   showLoader(context);
      // });
      if (od_id == '') {
        showErrorPopup(context, 'Alert!', 'Please select any order service');
      } else if (product_category_id == '') {
        showErrorPopup(context, 'Alert!', 'Please select any order category');
      } else if (l_id == '' && l_name == '') {
        showErrorPopup(context, 'Alert!', 'Please select Laundry service');
      } else {
        log('@@ ${od_id}');
        for (int i = 0; i < order_products.length; i++) {
          arr1.add({
            "id": order_products[i]['id'].toString(),
            "product_id": order_products[i]['product_id'].toString(),
            "product_price": order_products[i]['product_price'].toString(),
            "product_quantity":
                order_products[i]['product_quantity'].toString(),
            "total_price": order_products[i]['total_price'].toString()
          });
        }
        if (l_id == '') {
          data = {
            "order_list": jsonEncode(arr1),
            "total_order_price": total_price.toString(),
            "order_id": od_id.toString(),
            "order_details_id": product_category_id.toString(),
            // "delivery_charge": int.parse(delivery_charges.toString())
          };
        } else {
          data = {
            "order_list": jsonEncode(arr1),
            "total_order_price": total_price.toString(),
            "order_id": od_id.toString(),
            "order_details_id": product_category_id.toString(),
            "ls_id": l_id.toString(),
            // "delivery_charge": int.parse(delivery_charges.toString())
          };
        }
        log('@@ ${data}');
        final data1 = await ApiService()
            .sendPostRequest('/v1/delivery-boy/order/order-handover-ls', data);
        if (kDebugMode) {
          log('@@ ${data1['data']}');
        }
        if (data1['data']['status'] == 1) {
          var mes = '';
          mes = data1['data']['data'][0]['message'];

          showErrorPopup(context, 'Success', mes!);
          // hideLoader(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushNamed(context, '/screens/BottomTab');
          });
        } else {
          var arr = [];
          var mes = '';
          for (var i = 0; i < data1['data']['data'].length; i++) {
            log('@@@ ${data1['data']['data'][i]}');
            arr.add(data1['data']['data'][i]);
          }

          for (dynamic item in arr) {
            item.forEach((key, value) {
              log('Key: $key, Value: $value');
              mes = '${mes} ' + '${value}' '.';
            });
          }
          // hideLoader(context);
          // var mes = reg?.data![0].message;
          showErrorPopup(context, 'Error!', mes!);
        }
      }
      // hideLoader(context);
    } catch (ex) {
      if (kDebugMode) {
        print('x');
      }
      if (kDebugMode) {
        print(ex);
      }
      Future.delayed(const Duration(milliseconds: 200), () {
        // hideLoader(context);
      });
    } catch (e) {}

    // ignore: use_build_context_synchronously
    Future.delayed(const Duration(seconds: 2), () {
      // hideLoader(context);
    });
  }

  Future<void> pandingAmount(
      product_category_id, order_products, total_price, l_id) async {
    try {
      dynamic arr = [], arr1 = [];
      Map<String, dynamic> data;
      data = {
        "ls_id": l_id.toString(),
      };
      log('@@ ${data}');
      final data1 = await ApiService().sendGetRequest(
          '/v1/delivery-boy/order/ls-pending-amount?ls_id=${l_id.toString()}');
      if (kDebugMode) {
        log('@@ ${data1['data']}');
      }
      if (data1['data']['status'] == 1) {
        if (data1['data']['pending_amount'] > 0) {
          show(product_category_id, data1['data']['pending_amount']);
        } else {
          confirmHand(product_category_id, order_products, total_price);
        }
      } else {
        var arr = [];
        var mes = '';
        for (var i = 0; i < data1['data']['data'].length; i++) {
          log('@@@ ${data1['data']['data'][i]}');
          arr.add(data1['data']['data'][i]);
        }

        for (dynamic item in arr) {
          item.forEach((key, value) {
            log('Key: $key, Value: $value');
            mes = '${mes} ' + '${value}' '.';
          });
        }
        // hideLoader(context);
        // var mes = reg?.data![0].message;
        showErrorPopup(context, 'Error!', mes!);
      }
      // hideLoader(context);
    } catch (ex) {
      if (kDebugMode) {
        print('x');
      }
      if (kDebugMode) {
        print(ex);
      }
      Future.delayed(const Duration(milliseconds: 200), () {
        // hideLoader(context);
      });
    } catch (e) {}

    // ignore: use_build_context_synchronously
    Future.delayed(const Duration(seconds: 2), () {
      // hideLoader(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    routes = ModalRoute.of(context)?.settings.arguments as dynamic;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Orders",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(92, 136, 218, 1),
        leading: IconButton(
          icon: const Image(
            image: AssetImage("assets/images/ChevronLeft.png"),
            height: 25,
          ),
          onPressed: () {
            Navigator.of(context).pop(context);
          },
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              // height: 82,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(28, 41, 65, 1.0),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(12, 16, 12, 6),
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 29,
                          width: 105,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(92, 136, 218, 1),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Picked up",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            order_unique_id,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 10, 7),
                      height: 33,
                      width: 125,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: Color.fromRGBO(92, 136, 218, 1),
                      ),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            // Navigator.pushNamed(
                            //     context, '/screens/ChangeHelper');
                            _showCustomHelper(context, order);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "${delivery_boy?['firstName'].toString() ?? ''} ${delivery_boy?['lastName'].toString() ?? ''}",
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
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.fromLTRB(18, 12, 18, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Image(
                        height: 25,
                        width: 25,
                        image: AssetImage("assets/images/Page Up Button.png"),
                      ),
                      const Text(
                        "Order picked up: ",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "${pickup_request_date} | ${pickup_request_time}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      const Image(
                        height: 25,
                        width: 25,
                        image: AssetImage("assets/images/Page Down Button.png"),
                      ),
                      const Text(
                        "Order Delivery: ",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        " ${customer_delivery_date} | ${customer_delivery_time}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Text(
                    "Total Amount: ${customer_order_amount.toString()} Rs.",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(190, 58, 58, 1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: order.length,
                scrollDirection: Axis.vertical,
                controller: scrollController,
                itemBuilder: (BuildContext context1, int index) {
                  int res = 0;
                  order[index]['order_products'].forEach((item) => {
                        res = res +
                            int.parse(item['product_quantity'].toString()),
                        log('@@ ${item['product_quantity']}'),
                      });
                  return Container(
                    color: const Color.fromRGBO(92, 136, 218, 1),
                    margin: const EdgeInsets.fromLTRB(0.0, 6, 0, 6),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              order[index]['isChoice'] =
                                  !order[index]['isChoice'];
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(9.0, 0, 0, 0),
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                color: Color.fromRGBO(92, 136, 218, 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      order[index]['category_name'],
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          res.toString() + ' Cloths' ?? '',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        order[index]['isChoice'] == true
                                            ? const Image(
                                                height: 25,
                                                width: 25,
                                                image: AssetImage(
                                                    "assets/images/Chevron Up.png"))
                                            : Transform(
                                                alignment: Alignment.center,
                                                transform: Matrix4.rotationZ(
                                                  3.1415926535897932,
                                                ),
                                                child: const Image(
                                                  height: 25,
                                                  width: 25,
                                                  image: AssetImage(
                                                      "assets/images/Chevron Up.png"),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        order[index]['isChoice']
                            ? Column(
                                children: [
                                  Container(
                                    height: 390,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Container(
                                          color: Colors.grey,
                                          height: 42,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                18.0, 0, 18, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Item',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      180,
                                                  child: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Qty.',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Text(
                                                        'Rate',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Amt.',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            child: ListView.separated(
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return const SizedBox(width: 33);
                                          },
                                          itemCount: order[index]
                                                  ['order_products']
                                              .length,
                                          scrollDirection: Axis.vertical,
                                          controller: scrollController,
                                          itemBuilder: (BuildContext context,
                                              int index1) {
                                            log('@@@ total${order[index]['order_products']}');
                                            return Container(
                                              // color: Colors.white,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                      width: 2,
                                                      color:
                                                          HexColor('#E3E3E3')),
                                                ),
                                              ),
                                              margin: const EdgeInsets.fromLTRB(
                                                  12, 0, 12, 0),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        7.0, 12, 12, 12),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: 60,
                                                      child: Text(
                                                        order[index]['order_products']
                                                                    [index1]
                                                                ['product_name']
                                                            .toString(),
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      order[index]['order_products']
                                                                  [index1][
                                                              'product_quantity']
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      order[index]['order_products']
                                                                  [index1]
                                                              ['product_price']
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      order[index]['order_products']
                                                                  [index1]
                                                              ['total_price']
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        )),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18.0),
                                            child: Text(
                                              "Amount: ${order[index]['total_price']} Rs.",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 2,
                                          color: Colors.grey,
                                          margin: const EdgeInsets.fromLTRB(
                                              18.0, 10, 18, 10),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                18.0, 0, 18, 10),
                                            child: const Text(
                                              "Select Laundry*",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              18.0, 0, 18, 10),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.8),
                                            ),
                                          ),
                                          child: InkWell(
                                            onTap: () => {
                                              _showCustomDialog(
                                                context,
                                                order[index]['order_products'],
                                                index,
                                                order[index]['total_price'],
                                              ),
                                              log('@@@ val${order[index]['order_products']}'),
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  order[index]['laundry_sel'] ??
                                                      "Select Laundry Services",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const Image(
                                                  height: 25,
                                                  width: 25,
                                                  image: AssetImage(
                                                      "assets/images/Sort Down.png"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            height: 52,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                180,
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 0, 12, 10),
                                            decoration: BoxDecoration(
                                              color:
                                                  order[index]['status'] == null
                                                      ? const Color.fromRGBO(
                                                          28, 41, 65, 1)
                                                      : Colors.grey,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(7),
                                              ),
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                // DialogHelper();
                                                order[index]['status'] == null
                                                    ? l_id != ''
                                                        ? pandingAmount(
                                                            order[index]['id'],
                                                            order[index][
                                                                'order_products'],
                                                            order[index]
                                                                ['total_price'],
                                                            l_id)
                                                        : confirmHand(
                                                            order[index]['id'],
                                                            order[index][
                                                                'order_products'],
                                                            order[index]
                                                                ['total_price'])
                                                    // show(
                                                    //     order[index]['id'],
                                                    //     order[index]
                                                    //         ['order_products'],
                                                    //     order[index]
                                                    //         ['total_price'])
                                                    : null;
                                              },
                                              child: Text(
                                                order[index]['status'] == null
                                                    ? "Confirm Handover"
                                                        .toUpperCase()
                                                    : "Handedover"
                                                        .toUpperCase(),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container()
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
