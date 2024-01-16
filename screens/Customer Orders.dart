import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/app_services.dart';

class CustomerOrders extends StatefulWidget {
  const CustomerOrders({super.key});

  @override
  State<CustomerOrders> createState() => _CustomerOrdersState();
}

class _CustomerOrdersState extends State<CustomerOrders> {
  dynamic customer = [];
  dynamic customerClose = [];
  dynamic routes;

  int currentSelectedIndex = 0; //For Horizontal Date
  int currentCateSelectedIndex = 0;
  bool isChecked = true;
  dynamic customer_id = 0, status = 'active';
  ScrollController scrollController = ScrollController();

  _customerActive() async {
    var arr = [], arr1 = [];
    setState(() {
      customer = [];
      customerClose = [];
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
          '/v1/delivery-boy/customer/order-list?customer_id=${customer_id}&status=${status}');
      if (kDebugMode) {
        log('@@ ${data['data']['data']}');
      }
      hideLoader(context);
      int size = 0;
      if (data?['data']['status'] == 1) {
        size = data['data']['data']?.length;
        log('@@ 144 ${size}');
        if (status == 'active') {
          for (int? i = 0; i! < size!; i++) {
            log('@@ 57 ${data['data']['data'][i]}');
            arr.add({
              "id": data['data']['data'][i]['id'],
              "order_unique_id":
                  data['data']['data'][i]['order_unique_id'].toString(),
              "pickup_request_date": data['data']['data'][i]
                  ['pickup_request_date'],
              "pickup_request_time": data['data']['data'][i]
                  ['pickup_request_time'],
              "order_status": data['data']['data'][i]['order_status'],
              "delivery_boy": data['data']['data'][i]['delivery_boy'],
              "order_total_quantity": data['data']['data'][i]
                  ['order_total_quantity'],
              "customer": data['data']['data'][i]['customer']
            });
          }
        } else {
          for (int? i = 0; i! < size!; i++) {
            log('@@ 57 ${data['data']['data'][i]}');
            arr1.add({
              "id": data['data']['data'][i]['id'],
              "order_unique_id":
                  data['data']['data'][i]['order_unique_id'].toString(),
              "pickup_request_date": data['data']['data'][i]
                  ['pickup_request_date'],
              "pickup_request_time": data['data']['data'][i]
                  ['pickup_request_time'],
              "order_status": data['data']['data'][i]['order_status'],
              "delivery_boy": data['data']['data'][i]['delivery_boy'],
              "order_total_quantity": data['data']['data'][i]
                  ['order_total_quantity'],
              "customer": data['data']['data'][i]['customer']
            });
          }
        }
        setState(() {
          customer = arr;
          customerClose = arr1;
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

  _customerClose() async {
    setState(() {
      customer = [];
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
          customer = arr;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      _customerActive();
    });
  }

  @override
  Widget build(BuildContext context) {
    routes = ModalRoute.of(context)?.settings.arguments;
    log('@@@ ${routes}');
    setState(() {
      customer_id = routes['c_id'];
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Orders"),
        backgroundColor: const Color.fromRGBO(92, 136, 218, 1),
        centerTitle: true,
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
      body: Column(
        children: [
          // Container(
          //   height: 60,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //     child: Align(
          //       alignment: Alignment.centerLeft,
          //       child: SizedBox(
          //         height: 32,
          //         child: TextField(
          //           // autofillHints: "Enter your address",
          //           // obscureText: true,
          //           onChanged: (text) {
          //             // value = text;
          //           },
          //           decoration: const InputDecoration(
          //             fillColor: Colors.transparent,
          //             enabledBorder: UnderlineInputBorder(
          //               borderSide: BorderSide(
          //                 width: 2.0,
          //                 color: Colors.grey,
          //               ),
          //             ),
          //             filled: false,
          //             hintText: "Search customer",
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Container(
            color: Color.fromRGBO(28, 41, 65, 1.0),
            height: 52,
            child: Row(
              children: [
                InkWell(
                  onTap: () => {
                    setState(() {
                      isChecked = true;
                      status = 'active';
                    }),
                    _customerActive()
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
                      status = 'closed';
                    }),
                    _customerActive()
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
                        "Closed",
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
          status == 'active'
              ? Container(
                  height: 450,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: ListView.builder(
                      itemCount: customer.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.fromLTRB(0, 28, 0, 0),
                          width: MediaQuery.of(context).size.width - 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                            color: Color.fromRGBO(190, 58, 58, 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
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
                                                  "Pickup:${customer[index]['pickup_request_date']} | ${customer[index]['pickup_request_time']}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  customer[index]
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 9, 0, 0),
                                                      child: Text(
                                                        customer[index]
                                                                    ['customer']
                                                                ['firstName'] +
                                                            ' ' +
                                                            customer[index]
                                                                    ['customer']
                                                                ['lastName'],
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .fromLTRB(0, 4, 0, 0),
                                                      child: Text(
                                                        "${customer[index]['order_total_quantity']} Cloths",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                customer[index]
                                                            ['order_status'] ==
                                                        9
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0.0, 18, 0, 0),
                                                        child: Container(
                                                          width: 130,
                                                          height: 33,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  6),
                                                            ),
                                                          ),
                                                          child: TextButton(
                                                            onPressed: () {
                                                              // Navigator.pushNamed(
                                                              //     context,
                                                              //     "/screens/PickupOrder");
                                                            },
                                                            child: Text(
                                                              "Active Oreder"
                                                                  .toUpperCase(),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        child: Text(
                                                          "cloths received",
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 12,
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
                      }))
              : Container(
                  height: 450,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: ListView.builder(
                      itemCount: customerClose.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.fromLTRB(0, 28, 0, 0),
                          width: MediaQuery.of(context).size.width - 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                            color: Color.fromRGBO(190, 58, 58, 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
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
                                                  "Pickup:${customerClose[index]['pickup_request_date']} | ${customerClose[index]['pickup_request_time']}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  customerClose[index]
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 9, 0, 0),
                                                      child: Text(
                                                        customerClose[index]
                                                                    ['customer']
                                                                ['firstName'] ??
                                                            '' +
                                                                ' ' +
                                                                customerClose[
                                                                            index]
                                                                        [
                                                                        'customer']
                                                                    [
                                                                    'lastName'] ??
                                                            '',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .fromLTRB(0, 4, 0, 0),
                                                      child: Text(
                                                        "${customerClose[index]['order_total_quantity']} Cloths",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                customerClose[index]
                                                            ['order_status'] ==
                                                        9
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0.0, 18, 0, 0),
                                                        child: Container(
                                                          width: 130,
                                                          height: 33,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  6),
                                                            ),
                                                          ),
                                                          child: TextButton(
                                                            onPressed: () {
                                                              // Navigator.pushNamed(
                                                              //     context,
                                                              //     "/screens/PickupOrder");
                                                            },
                                                            child: Text(
                                                              "Active Oreder"
                                                                  .toUpperCase(),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
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
                      })),
        ],
      ),
    );
  }
}
