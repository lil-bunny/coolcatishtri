import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/app_services.dart';
import '../widgets/CustomDialog.dart';
import 'package:get/get.dart';

class ChangeHelper extends StatefulWidget {
  const ChangeHelper({super.key});

  @override
  State<ChangeHelper> createState() => _ChangeHelperState();
}

class _ChangeHelperState extends State<ChangeHelper> {
  dynamic helper = [];

  int currentSelectedIndex = 0; //For Horizontal Date
  int currentCateSelectedIndex = 0;
  bool isShow = false;
  ScrollController scrollController = ScrollController();
  dynamic routes, order_id, order_un_id, helper_id;

  helperSel() async {
    try {
      var arr = [];
      setState(() {
        arr = [];
      });
      int qty = 0;
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      final data1 = await ApiService().sendGetRequest(
          '/v1/delivery-boy/helper/helper-list-without-pagination');
      if (kDebugMode) {
        // log('@@ ${data1['data']['data']}');
      }
      if (data1['data']['status'] == 1) {
        hideLoader(context);
        for (int i = 0; i < data1['data']['data'].length; i++) {
          arr.add({
            "name": data1['data']['data'][i]['firstName'] +
                data1['data']['data'][i]['lastName'],
            "primary_phone_no": data1['data']['data'][i]['primary_phone_no'],
            "id": data1['data']['data'][i]['id'],
            "job": 'Helper',
            "new_profile_image_name": data1['data']['data'][i]
                ['new_profile_image_name'],
            "isChoice": false,
          });
        }
        setState(() {
          helper = arr;
        });
        // [1, 8, 9, 3, 5];
        // [5, 3, 7, 9, 2];
        // {
        //     "product_price": 22,
        //     "total_price": 390,
        //     "product_quantity": 18,
        //     "product_name": "Jeans",
        //     id: 110,
        //     "product_id": 4
        //   };
      } else {
        var mes = '';
        mes = data1['data']['data']['message'];

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

  submit() async {
    try {
      dynamic data = {};
      if (helper_id == '') {
        showErrorPopup(context, 'Alert!', "Please select any helper");
      } else {
        data = {"order_id": order_id, "helper_id": helper_id};
        Future.delayed(const Duration(microseconds: 700), () {
          showLoader(context);
        });
        final data1 = await ApiService().sendPostRequest(
            '/v1/delivery-boy/order/change-order-helper', data);
        if (kDebugMode) {
          log('@@ ${data1['data']['data']}');
        }
        if (data1['data']['status'] == 1) {
          hideLoader(context);
          Navigator.pop(context);
          // [1, 8, 9, 3, 5];
          // [5, 3, 7, 9, 2];
        } else {
          var mes = '';
          mes = data1['data']['data']['message'];

          hideLoader(context);
          // var mes = reg?.data![0].message;
          toast(mes!);
        }
        hideLoader(context);
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

    // ignore: use_build_context_synchronously
    Future.delayed(const Duration(seconds: 1), () {
      hideLoader(context);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    helperSel();
  }

  @override
  Widget build(BuildContext context) {
    routes = ModalRoute.of(context)?.settings.arguments;
    setState(() {
      order_id = routes['or_id'];
      order_un_id = routes['order_id'];
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Change Helper",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromRGBO(92, 136, 218, 1),
        leading: IconButton(
          icon: const Image(
            image: AssetImage("assets/images/ChevronLeft.png"),
            height: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
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
                    margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 33,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(236, 71, 0, 1),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                "", //Order Ready by LS
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
                          child: Text(
                            order_un_id.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          // width: 12,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Change helper for this order",
                          style: TextStyle(
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
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.fromLTRB(18, 28, 18, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: helper.length,
                scrollDirection: Axis.vertical,
                controller: scrollController,
                itemBuilder: (BuildContext context1, int index) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(0.0, 6, 0, 6),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(9.0, 0, 0, 0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: Color.fromRGBO(92, 136, 218, 1),
                                  value: helper[index]['isChoice'],
                                  onChanged: (value) {
                                    setState(() {
                                      helper_id = helper[index]['id'];
                                      helper[index]['isChoice'] =
                                          !helper[index]['isChoice'];
                                    });
                                  },
                                  // tristate: true,
                                  shape: CircleBorder(),
                                ),
                                const Image(
                                  image: AssetImage(
                                      'assets/images/AccountLaundry.png'),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      helper[index]['name'],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      helper[index]['job'],
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                    Text(
                                      helper[index]['primary_phone_no'],
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                  ],
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 105,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(236, 241, 255, 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 42,
                      width: MediaQuery.of(context).size.width - 180,
                      margin: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(28, 41, 65, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          submit();
                        },
                        child: Text(
                          "Confirm".toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
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
  }
}
