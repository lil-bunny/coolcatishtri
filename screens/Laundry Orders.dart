import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/app_services.dart';
import '../../widgets/question.dart';
import '../../widgets/CustomText.dart';
import '../models/Data.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class LaundryOrders extends StatefulWidget {
  const LaundryOrders({super.key});

  @override
  State<LaundryOrders> createState() => _LaundryOrdersState();
}

class _LaundryOrdersState extends State<LaundryOrders> {
  bool isChecked = true;
  var _data = null;
  var page = 1;
  List _laundry = [];
  late ScrollController _controller = ScrollController();
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
    laundryList();
  }

  @override
  void dispose() {
    // _controller.removeListener(_loadMore);
    super.dispose();
  }

  bool isSelect = false;
  int currentSelectedIndex = 0; //For Horizontal Date
  int currentCateSelectedIndex = 0;
  ScrollController scrollController = ScrollController();
  dynamic laundryactive = [],
      laundryClose = [],
      status = 'active',
      la_id,
      l_name = '';
  List<dynamic> laundry = [];

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(context); // Use the custom dialog widget here
      },
    );
  }

  CustomDialog(BuildContext context) {
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
                          la_id = laundry[index]['id'].toString();
                          currentCateSelectedIndex = index;
                        }),
                        _laundryActive(),
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
                                        color: currentCateSelectedIndex == index
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

  laundryList() async {
    try {
      var arr = [], arr1 = [];
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

  _laundryActive() async {
    var arr = [], arr1 = [];
    setState(() {
      laundryactive = [];
      laundryClose = [];
      arr = [];
      arr1 = [];
    });
    try {
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      String data1 = '';
      data1 = 'page=' + '1' + '&' + 'limit=' + '10';
      final data = await ApiService().sendGetRequest(
          '/v1/delivery-boy/laundry-service/order-list?laundry_id=${la_id}&status=${status}');
      if (kDebugMode) {
        log('@@ ${data['data']['data']}');
      }
      hideLoader(context);
      int size = 0, count = 0;
      if (data?['data']['status'] == 1) {
        size = data['data']['data']?.length;
        log('@@ 144 ${size}');
        if (status == "active") {
          for (int? i = 0; i! < size!; i++) {
            log('@@ 57 ${data['data']['data'][i]}');
            for (int j = 0;
                j < data['data']['data'][i]['order_products'].length;
                j++) {
              count = count +
                  int.parse(data['data']['data'][i]['order_products'][j]
                          ['product_quantity']
                      .toString());
            }
            arr.add({
              "id": data['data']['data'][i]['id'],
              "order_unique_id": data['data']['data'][i]['order']
                      ['order_unique_id']
                  .toString(),
              "pickup_request_date": data['data']['data'][i]['order']
                  ['pickup_request_date'],
              "pickup_request_time": data['data']['data'][i]['order']
                  ['pickup_request_time'],
              "order_status": data['data']['data'][i]['status'],
              "order_total_quantity": count.toString(),
              "customer": data['data']['data'][i]['order']['customer']
            });
            count = 0;
          }
        } else {
          for (int? i = 0; i! < size!; i++) {
            log('@@ 57 ${data['data']['data'][i]}');
            for (int j = 0;
                j < data['data']['data'][i]['order_products'].length;
                j++) {
              count = count +
                  int.parse(data['data']['data'][i]['order_products'][j]
                          ['product_quantity']
                      .toString());
            }
            arr1.add({
              "id": data['data']['data'][i]['id'],
              "order_unique_id": data['data']['data'][i]['order']
                      ['order_unique_id']
                  .toString(),
              "pickup_request_date": data['data']['data'][i]['order']
                  ['pickup_request_date'],
              "pickup_request_time": data['data']['data'][i]['order']
                  ['pickup_request_time'],
              "order_status": data['data']['data'][i]['status'],
              "order_total_quantity": count.toString(),
              "customer": data['data']['data'][i]['order']['customer']
            });
            count = 0;
          }
        }
        setState(() {
          laundryactive = arr;
          laundryClose = arr1;
          // arr = [];
          // arr1 = [];
        });
        log('@@@ ${arr}');
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

  _laundryClose() async {
    setState(() {
      laundryClose = [];
      laundryactive = [];
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
        log('@@ ${data['data']['data']}');
      }
      hideLoader(context);
      var arr = [];
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
          laundryClose = arr;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text(
          'Laundry Orders',
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(92, 136, 218, 1),
        leading: IconButton(
          icon: const Image(
            image: AssetImage("assets/images/ChevronLeft.png"),
            height: 22,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(18.0, 0, 18, 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1.8),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Laundry*",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      InkWell(
                        onTap: () => {
                          _showCustomDialog(context),
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l_name == '' ? "Select Laundry" : l_name,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Image(
                              height: 25,
                              width: 25,
                              image: AssetImage("assets/images/Sort Down.png"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  height: 52,
                  // width: MediaQuery.of(context).size.width - 22,
                  decoration: BoxDecoration(
                    color: const Color(0xff1C2941),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () => {
                          setState(() {
                            isChecked = true;
                            status = 'active';
                          }),
                          _laundryActive(),
                        },
                        child: Container(
                          height: 42,
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          decoration: BoxDecoration(
                            color: !isChecked
                                ? const Color.fromRGBO(28, 41, 65, 1)
                                : const Color.fromRGBO(92, 136, 218, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                7,
                              ),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width / 2 - 22,
                          child: Center(
                            child: Text(
                              "Active",
                              style: TextStyle(
                                color: !isChecked
                                    ? Color.fromRGBO(92, 136, 218, 1)
                                    : Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          setState(() {
                            isChecked = false;
                            status = "closed";
                          }),
                          _laundryActive(),
                        },
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: isChecked
                                ? const Color(0xff1C2941)
                                : Color.fromRGBO(92, 136, 218, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                7,
                              ),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width / 2 - 22,
                          child: Center(
                            child: Text(
                              "Inactive",
                              style: TextStyle(
                                color: isChecked
                                    ? Color.fromRGBO(92, 136, 218, 1)
                                    : Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                status == "active"
                    ? Container(
                        height: 450,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 33);
                          },
                          itemCount: laundryactive.length,
                          scrollDirection: Axis.vertical,
                          controller: scrollController,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.fromLTRB(14, 10, 14, 0),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9)),
                                color: Color.fromRGBO(190, 58, 58, 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    // offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                    width:
                                        MediaQuery.of(context).size.width - 30,
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
                                                      "Pickup:${laundryactive[index]['pickup_request_date']} | ${laundryactive[index]['pickup_request_time']}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      laundryactive[index]
                                                          ['order_unique_id'],
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
                                                            laundryactive[index]
                                                                        [
                                                                        'customer']
                                                                    [
                                                                    'firstName'] +
                                                                ' ' +
                                                                laundryactive[
                                                                            index]
                                                                        [
                                                                        'customer']
                                                                    [
                                                                    'lastName'],
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
                                                            "${laundryactive[index]['order_total_quantity']} Cloths",
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
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          0.0, 18, 0, 0),
                                                      child: Container(
                                                        width: 130,
                                                        height: 33,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(6),
                                                          ),
                                                        ),
                                                        child: TextButton(
                                                          onPressed: () {},
                                                          child: Text(
                                                            "pickup for Delivery"
                                                                .toUpperCase(),
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10,
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        height: 450,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 33);
                          },
                          itemCount: laundryClose.length,
                          scrollDirection: Axis.vertical,
                          controller: scrollController,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.fromLTRB(14, 10, 14, 0),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9)),
                                color: Color.fromRGBO(190, 58, 58, 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    // offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                    width:
                                        MediaQuery.of(context).size.width - 30,
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
                                                      "Pickup:${laundryClose[index]['pickup_request_date']} | ${laundryClose[index]['pickup_request_time']}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      laundryClose[index]
                                                          ['order_unique_id'],
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
                                                            laundryClose[index][
                                                                        'customer']
                                                                    [
                                                                    'firstName'] +
                                                                ' ' +
                                                                laundryClose[
                                                                            index]
                                                                        [
                                                                        'customer']
                                                                    [
                                                                    'lastName'],
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
                                                            "${laundryClose[index]['order_total_quantity']} Cloths",
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
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
