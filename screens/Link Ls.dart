import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/statemanagemnt/provider/CustomerDataProvider.dart';
import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:ishtri_db/ApiRequest/ApiRequestPost.dart';
import 'package:provider/provider.dart';

class Linkls extends StatefulWidget {
  const Linkls({super.key});

  @override
  State<Linkls> createState() => _LinklsState();
}

class _LinklsState extends State<Linkls> {
  var Linkls = '';
  var isSelect = '';
  dynamic laundry = [], helper = [], laundry_id = '', helper_id = '';
  int selIndex = 0;

  _laundry_list() async {
    log('@@ ${laundry_id}');
    setState(() {
      helper = [];
    });
    try {
      Future.delayed(Duration(microseconds: 700), () {
        showLoader(context);
      });
      final data = await ApiService()
          .sendGetRequest('/v1/delivery-boy/laundry-service/ls-list');
      if (kDebugMode) {
        print(data);
      }
      hideLoader(context);
      var arr = [];
      log('@@${data['data']['data']}');
      if (data?['data']['status'] == 1) {
        int size = data['data']['data']?.length;
        for (int? i = 0; i! < size!; i++) {
          arr.add({
            "id": data['data']['data'][i]['laundry_id'],
            "name": data['data']['data'][i]['laundry']
                ['laundry_aditional_detail']['laundry_name'],
            "usChoice": false,
          });
        }
        setState(() {
          laundry = arr;
        });
        Future.delayed(Duration(microseconds: 200), () {
          _helper_list();
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

  _helper_list() async {
    setState(() {
      helper = [];
    });
    try {
      Future.delayed(Duration(microseconds: 700), () {
        showLoader(context);
      });
      // String data1 = '';
      // data1 = 'sub_category_id=' + laundry_id.toString();
      final data = await ApiService().sendGetRequest(
          '/v1/delivery-boy/helper/helper-list-without-pagination');
      if (kDebugMode) {
        log('@@@ ${data}');
      }
      hideLoader(context);
      var arr = [];
      if (data?['data']['status'] == 1) {
        int size = data['data']['data'].length;
        for (int? i = 0; i! < size!; i++) {
          log('@@ 57 ${data['data']['data'][i]}');
          arr.add({
            "id": data['data']['data'][i]['id'],
            "phone": data['data']['data'][i]['primary_phone_no'],
            "name": data['data']['data'][i]['firstName'] +
                ' ' +
                data['data']['data'][i]['lastName'],
          });
        }
        log('@@@ ${arr}');
        setState(() {
          helper = arr;
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

  _assign_helper() async {
    try {
      if (helper_id == '') {
        showErrorPopup(context, 'Alert!', 'Please select helper');
      } else if (laundry_id == '') {
        showErrorPopup(context, 'Alert!', 'Please select laundry');
      } else {
        Future.delayed(Duration(microseconds: 700), () {
          showLoader(context);
        });
        dynamic data1 = {};
        data1 = {'laundry_id': laundry_id, 'helper_id': helper_id};
        log('@@@ ${data1}');
        final data = await ApiService().sendPostRequest(
            '/v1/delivery-boy/laundry-service/assign-helper-to-laundry', data1);
        if (kDebugMode) {
          log('@@@ ${data}');
        }
        hideLoader(context);
        var arr = [];
        if (data?['data']['status'] == 1) {
          showErrorPopup(context, 'Success', data['data']['message']);
        } else {
          showErrorPopup(context, "error!", data['data']['message']);
        }
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
    _laundry_list();
    _helper_list();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Link Laundry"),
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
      body: SingleChildScrollView(
        child: Container(
          // height: 200,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 53,
                color: const Color.fromRGBO(28, 41, 65, 1.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ListView.builder(
                      itemCount: laundry.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            selIndex = index;
                            laundry_id = laundry[index]['id'].toString();
                            _helper_list();
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: selIndex == index
                                    ? HexColor('#5C88DA')
                                    : HexColor('#1C2941'),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 19.0,
                                  vertical: 10,
                                ),
                                child: Text(
                                  laundry![index]['name'],
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
              ),
              Container(
                // color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Container(
                    height: 350,
                    child: ListView.builder(
                      itemCount: helper.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 22,
                                      width: 22,
                                      margin:
                                          const EdgeInsets.fromLTRB(0, 0, 9, 0),
                                      decoration: BoxDecoration(
                                          color: HexColor('#D9D9D9'),
                                          borderRadius:
                                              BorderRadius.circular(17)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 14,
                                            width: 14,
                                            decoration: BoxDecoration(
                                                color:
                                                    isSelect == index.toString()
                                                        ? HexColor('#5C88DA')
                                                        : HexColor('#FFFFFF'),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      helper[index]['name'],
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Container(
                                  child: Text(
                                    helper[index]['phone'].toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
                              setState(() {
                                isSelect = index.toString();
                                helper_id = helper[index]['id'];
                              });
                              // Handle selection
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 42,
                  width: MediaQuery.of(context).size.width - 180,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(28, 41, 65, 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(7),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      _assign_helper();
                    },
                    child: Text(
                      "Update".toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
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
    );
  }
}
